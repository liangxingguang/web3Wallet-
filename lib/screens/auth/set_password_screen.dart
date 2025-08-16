import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _pwd1 = TextEditingController();
  final _pwd2 = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _savePassword(String password) async {
    final storage = FlutterSecureStorage();
    // 生成随机盐
    final salt = base64Url.encode(List<int>.generate(16, (_) => Random.secure().nextInt(256)));
    // 使用PBKDF2生成hash
    final key = pbkdf2Hash(password, salt);
    await storage.write(key: 'wallet_password_hash', value: key);
    await storage.write(key: 'wallet_password_salt', value: salt);
  }

  String pbkdf2Hash(String password, String salt) {
    // 简单PBKDF2实现（可用更安全的包如crypto或argon2替换）
    final key = pbkdf2(
      password: utf8.encode(password),
      salt: utf8.encode(salt),
      iterations: 10000,
      bits: 256,
    );
    return base64Url.encode(key);
  }

  // PBKDF2核心算法
  List<int> pbkdf2({
    required List<int> password,
    required List<int> salt,
    int iterations = 10000,
    int bits = 256,
  }) {
    final hmac = Hmac(sha256, password);
    final blocks = (bits / 32).ceil();
    var output = <int>[];
    for (var i = 1; i <= blocks; i++) {
      var block = List<int>.from(salt)..addAll([0, 0, 0, i]);
      var u = hmac.convert(block).bytes;
      var x = u;
      for (var j = 1; j < iterations; j++) {
        u = hmac.convert(u).bytes;
        for (var k = 0; k < x.length; k++) x[k] ^= u[k];
      }
      output.addAll(x);
    }
    return output.sublist(0, bits ~/ 8);
  }

  void _trySetPassword() async {
    setState(() { _error = null; _loading = true; });
    final p1 = _pwd1.text;
    final p2 = _pwd2.text;
    if (p1.length < 8) {
      setState(() {
        _error = "密码至少8位";
        _loading = false;
      });
      return;
    }
    if (p1 != p2) {
      setState(() {
        _error = "两次输入密码不一致";
        _loading = false;
      });
      return;
    }
    await _savePassword(p1);
    setState(() { _loading = false; });
    Navigator.pop(context, true); // 返回登录页
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置主密码')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pwd1,
              obscureText: true,
              decoration: InputDecoration(labelText: '输入主密码（至少8位）'),
            ),
            TextField(
              controller: _pwd2,
              obscureText: true,
              decoration: InputDecoration(labelText: '再次输入主密码'),
            ),
            SizedBox(height: 24),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _trySetPassword,
              child: _loading ? CircularProgressIndicator() : Text('设置密码'),
            ),
          ],
        ),
      ),
    );
  }
}