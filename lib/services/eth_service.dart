// ignore_for_file: deprecated_member_use

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' hide Wallet;
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/web3dart.dart' as HEX;
import 'package:web3_wallet/models/wallet.dart';

class EthService {
  static Future<Map<String, String>> createHDWallet() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final privateKey = child.privateKey!;
    final credentials = EthPrivateKey.fromHex(HEX.encode(privateKey) as String);
    final address = (await credentials.extractAddress()).hex;
    return {
      'mnemonic': mnemonic,
      'address': address,
      'privateKey': HEX.encode(privateKey) as String,
    };
  }

  static Future<Map<String, String>> importFromMnemonic(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final privateKey = child.privateKey!;
    final credentials = EthPrivateKey.fromHex(HEX.encode(privateKey) as String);
    final address = (await credentials.extractAddress()).hex;
    return {
      'address': address,
      'privateKey': HEX.encode(privateKey) as String,
    };
  }

  static Future<String?> send(
      Wallet wallet, String toAddress, double amount) async {
    // TODO: 实现ETH/BSC链转账逻辑
    final client = Web3Client(
      'https://rpc.ankr.com/eth',
      Client(),
    );
    final credentials = EthPrivateKey.fromHex(wallet.privateKey as String);
    final transaction = Transaction(
      from: credentials.address,
      to: EthereumAddress.fromHex(toAddress),
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
    );
    final txHash = await client.sendTransaction(
      credentials,
      transaction,
      chainId: 1,
    );
    return txHash;
  }
}
