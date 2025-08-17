import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web3_wallet/screens/wallet/create_wallet_screen.dart';
import 'package:web3_wallet/screens/wallet/import_wallet_screen.dart';

import '../providers/locale_provider.dart';
import '../providers/wallet_provider.dart';
import '../generated/app_localizations.dart';
import '../screens/main_tab_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/set_password_screen.dart';
import '../models/wallet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkPasswordAndNavigate();
  }

  Future<void> _checkPasswordAndNavigate() async {
    const storage = FlutterSecureStorage();
    final hasPassword = await storage.containsKey(key: 'wallet_password_hash');
    final hasWallet = Hive.box<Wallet>('wallets').isNotEmpty;

    // 等待一小段时间，让启动画面有足够的显示时间
    await Future.delayed(const Duration(milliseconds: 500));

    if (hasPassword) {
      // 有密码，导航到登录屏幕
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else if (hasWallet) {
      // 有钱包但没有密码，提示设置密码
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetPasswordScreen()),
      );
    } else {
      // 没有钱包也没有密码，直接进入主页（或创建钱包页面）
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainTabScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 这里可以添加应用logo
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Color(0xFF2176FF),
            ),
            SizedBox(height: 20),
            Text(
              'Web3 Wallet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2176FF),
                fontFamily: 'System',
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              color: Color(0xFF2176FF),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // 注册 WalletAdapter
  if (!Hive.isAdapterRegistered(WalletAdapter().typeId)) {
    Hive.registerAdapter(WalletAdapter());
  }
  await Hive.openBox<Wallet>('wallets');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: const Web3WalletApp(),
    ),
  );
}

class Web3WalletApp extends StatelessWidget {
  const Web3WalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('ja', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/create_wallet': (context) => const CreateWalletScreen(),
        '/import_wallet': (context) => const ImportWalletScreen(),
        '/login': (context) => const LoginScreen(),
        '/set_password': (context) => const SetPasswordScreen(),
        '/main_tab': (context) => const MainTabScreen(),
      },
    );
  }
}
