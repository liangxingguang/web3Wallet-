import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wallet_provider.dart';
import 'screens/main_tab_screen.dart';

void main() {
  runApp(Web3WalletApp());
}

class Web3WalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: MaterialApp(
        title: 'Web3Wallet',
        theme: ThemeData(
          primaryColor: Color(0xFF2176FF),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xFF2176FF),
            secondary: Color(0xFF6EC6FF),
          ),
          scaffoldBackgroundColor: Color(0xFFF6F8FC),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF2176FF),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: MainTabScreen(),
        routes: {
          '/create_wallet': (_) => throw UnimplementedError(),
          '/import_wallet': (_) => throw UnimplementedError(),
        },
      ),
    );
  }
}