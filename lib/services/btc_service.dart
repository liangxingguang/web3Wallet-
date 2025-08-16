import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bip39/bip39.dart' as bip39;
import '../models/wallet.dart';

class BtcService {
  static Future<Map<String, String>> createHDWallet() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    final hdWallet = HDWallet.fromSeed(seed);
    final address = hdWallet.address!;
    final privateKey = hdWallet.privKey!;
    return {
      'mnemonic': mnemonic,
      'address': address,
      'privateKey': privateKey,
    };
  }

  static Future<Map<String, String>> importFromMnemonic(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final hdWallet = HDWallet.fromSeed(seed);
    final address = hdWallet.address!;
    final privateKey = hdWallet.privKey!;
    return {
      'address': address,
      'privateKey': privateKey,
    };
  }

  static Future<String?> send(
      Wallet wallet, String toAddress, double amount) async {
    // TODO: 实现BTC转账逻辑
    return 'MOCK_TX_HASH_BTC';
  }
}