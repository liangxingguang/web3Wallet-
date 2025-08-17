import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'dart:async';

import 'providers/locale_provider.dart';
import 'providers/wallet_provider.dart';
import 'generated/app_localizations.dart';
import 'screens/main_tab_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/set_password_screen.dart';
import 'models/wallet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
    final storage = FlutterSecureStorage();
    final hasPassword = await storage.containsKey(key: 'wallet_password_hash');
    final hasWallet = Hive.box<Wallet>('wallets').isNotEmpty;

    // 等待一小段时间，让启动画面有足够的显示时间
    await Future.delayed(Duration(milliseconds: 500));

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 这里可以添加应用logo
            const Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Color(0xFF2176FF),
            ),
            const SizedBox(height: 20),
            const Text(
              'Web3 Wallet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2176FF),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
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
  Hive.registerAdapter(WalletAdapter());
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
      title: 'Web3Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2176FF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF2176FF),
          secondary: const Color(0xFF6EC6FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2176FF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
        Locale('ja'),
      ],
      home: SplashScreen(),
    );
  }
}