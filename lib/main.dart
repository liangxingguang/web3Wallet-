import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wallet_provider.dart';
import 'screens/wallet/wallet_manager_screen.dart';

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
          primarySwatch: Colors.blue,
        ),
        home: WalletManagerScreen(),
      ),
    );
  }
}