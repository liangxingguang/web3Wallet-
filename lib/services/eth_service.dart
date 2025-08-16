import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import '../models/wallet.dart';

class EthService {
  static Future<Map<String, String>> createHDWallet() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final privateKey = child.privateKey!;
    final credentials = EthPrivateKey.fromHex(privateKey.toHex());
    final address = (await credentials.extractAddress()).hex;
    return {
      'mnemonic': mnemonic,
      'address': address,
      'privateKey': privateKey.toHex(),
    };
  }

  static Future<Map<String, String>> importFromMnemonic(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final privateKey = child.privateKey!;
    final credentials = EthPrivateKey.fromHex(privateKey.toHex());
    final address = (await credentials.extractAddress()).hex;
    return {
      'address': address,
      'privateKey': privateKey.toHex(),
    };
  }

  static Future<String?> send(
      Wallet wallet, String toAddress, double amount) async {
    // TODO: 实现ETH/BSC链转账逻辑
    return 'MOCK_TX_HASH_ETH';
  }
}