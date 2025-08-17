import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import '../../models/wallet.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;
  int _failCount = 0;
  DateTime? _nextTryTime;

  Future<bool> _checkPassword(String password) async {
    const storage = FlutterSecureStorage();
    final salt = await storage.read(key: 'wallet_password_salt');
    final hash = await storage.read(key: 'wallet_password_hash');
    if (salt == null || hash == null) return false;
    final inputHash = pbkdf2Hash(password, salt);
    return hash == inputHash;
  }

  String pbkdf2Hash(String password, String salt) {
    // 与设置密码时的算法保持一致
    final key = pbkdf2(
      password: utf8.encode(password),
      salt: utf8.encode(salt),
      iterations: 10000,
      bits: 256,
    );
    return base64Url.encode(key);
  }

  List<int> pbkdf2(
      {required List<int> password,
      required List<int> salt,
      int iterations = 10000,
      int bits = 256}) {
    final hmac = Hmac(sha256, password);
    final blocks = (bits / 32).ceil();
    var output = <int>[];
    for (var i = 1; i <= blocks; i++) {
      var block = List<int>.from(salt)..addAll([0, 0, 0, i]);
      var u = hmac.convert(block).bytes;
      var x = u;
      for (var j = 1; j < iterations; j++) {
        u = hmac.convert(u).bytes;
        for (var k = 0; k < x.length; k++) {
          x[k] ^= u[k];
        }
      }
      output.addAll(x);
    }
    return output.sublist(0, bits ~/ 8);
  }

  Future<bool> _hasWallet() async {
    var box = await Hive.openBox<Wallet>('wallets');
    return box.isNotEmpty;
  }

  void _login() async {
    if (_nextTryTime != null && DateTime.now().isBefore(_nextTryTime!)) {
      setState(() {
        _error = "尝试次数过多，请稍后再试";
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final pwd = _passwordController.text;
    final ok = await _checkPassword(pwd);
    final hasWallet = await _hasWallet();
    setState(() {
      _loading = false;
    });
    if (ok && hasWallet) {
      setState(() {
        _failCount = 0;
      });
      Navigator.pushReplacementNamed(context, '/home');
    } else if (!hasWallet && ok) {
      Navigator.pushReplacementNamed(context, '/create_or_import_wallet');
    } else {
      setState(() {
        _failCount++;
        _error = "密码错误";
        if (_failCount >= 5) {
          _nextTryTime = DateTime.now().add(Duration(seconds: 30 * _failCount));
          Timer(_nextTryTime!.difference(DateTime.now()), () {
            setState(() {
              _error = null;
              _failCount = 0;
              _nextTryTime = null;
            });
          });
        }
      });
    }
  }

  void _toSetPassword() {
    Navigator.pushNamed(context, '/set_password');
  }

  void _toCreateOrImportWallet() {
    Navigator.pushReplacementNamed(context, '/create_or_import_wallet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('钱包登录')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: '主密码',
                suffixIcon: IconButton(
                  icon:
                      Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('登录'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: _toSetPassword,
              child: const Text('忘记密码？重设'), // 实际重设流程需清空钱包
            ),
            TextButton(
              onPressed: _toCreateOrImportWallet,
              child: const Text('创建/导入钱包'),
            ),
          ],
        ),
      ),
    );
  }
}
