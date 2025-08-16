import 'package:flutter/material.dart';
import '../models/wallet.dart';

class WalletProvider extends ChangeNotifier {
  final List<Wallet> _wallets = [];
  Wallet? _currentWallet;

  List<Wallet> get wallets => _wallets;
  Wallet? get currentWallet => _currentWallet;

  void addWallet(Wallet wallet) {
    _wallets.add(wallet);
    _currentWallet ??= wallet;
    notifyListeners();
  }

  void removeWallet(Wallet wallet) {
    _wallets.remove(wallet);
    if (_currentWallet == wallet) {
      _currentWallet = _wallets.isNotEmpty ? _wallets.first : null;
    }
    notifyListeners();
  }

  void switchWallet(Wallet wallet) {
    _currentWallet = wallet;
    notifyListeners();
  }
}