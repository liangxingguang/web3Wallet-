import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/locale_provider.dart';
import 'providers/wallet_provider.dart';
import 'generated/app_localizations.dart';
import 'screens/main_tab_screen.dart';

void main() {
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
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
        Locale('ja'),
      ],
      home: MainTabScreen(),
    );
  }
}