import 'package:bdk_flutter/bdk_flutter.dart' as bdk;
import 'package:bip39/bip39.dart' as bip39;
import '../models/wallet.dart';

class BtcService {
  static var electrumUrl = "https://electrum.blockstream.info/testnet";

  static get descriptorSecretKey => null;

  static Future<Map<String, String>> createHDWallet() async {
    final mnemonic = bip39.generateMnemonic();
    final mnemonicObj = await bdk.Mnemonic.fromString(mnemonic);
    final descriptorSecretKey = await bdk.DescriptorSecretKey.create(
        network: bdk.Network.testnet, mnemonic: mnemonicObj);
    final externalDescriptor = await bdk.Descriptor.newBip44(
        secretKey: descriptorSecretKey,
        network: bdk.Network.testnet,
        keychain: bdk.KeychainKind.externalChain);
    final internalDescriptor = await bdk.Descriptor.newBip44(
        secretKey: descriptorSecretKey,
        network: bdk.Network.testnet,
        keychain: bdk.KeychainKind.internalChain);

    final wallet = await bdk.Wallet.create(
        descriptor: externalDescriptor,
        changeDescriptor: internalDescriptor,
        network: bdk.Network.testnet,
        databaseConfig: const bdk.DatabaseConfig.memory());
    final addressInfo =
        wallet.getAddress(addressIndex: const bdk.AddressIndex.peek(index: 0));
    final address = addressInfo.address;
    final privateKey = descriptorSecretKey.asString();

    return {
      'mnemonic': mnemonic,
      'address': address.toString(),
      'privateKey': privateKey,
    };
  }

  static Future<Map<String, String>> importFromMnemonic(String mnemonic) async {
    final mnemonicObj = await bdk.Mnemonic.fromString(mnemonic);
    final descriptorSecretKey = await bdk.DescriptorSecretKey.create(
        network: bdk.Network.testnet, mnemonic: mnemonicObj);
    final externalDescriptor = await bdk.Descriptor.newBip44(
        secretKey: descriptorSecretKey,
        network: bdk.Network.testnet,
        keychain: bdk.KeychainKind.externalChain);
    final internalDescriptor = await bdk.Descriptor.newBip44(
        secretKey: descriptorSecretKey,
        network: bdk.Network.testnet,
        keychain: bdk.KeychainKind.internalChain);

    final wallet = await bdk.Wallet.create(
        descriptor: externalDescriptor,
        changeDescriptor: internalDescriptor,
        network: bdk.Network.testnet,
        databaseConfig: const bdk.DatabaseConfig.memory());
    final addressInfo =
        wallet.getAddress(addressIndex: const bdk.AddressIndex.peek(index: 0));
    final address = addressInfo.address;
    final privateKey = descriptorSecretKey.asString();

    return {
      'address': address.toString(),
      'privateKey': privateKey,
    };
  }

  static Future<String?> send(
      Wallet myWallet, String toAddress, double amount) async {
    final mnemonic = myWallet.mnemonic;

    const network = bdk.Network.bitcoin; // 或 Network.BITCOIN
    const electrumUrl = 'ssl://electrum.blockstream.info:60002';

    // 推荐用 bdk_flutter 的 DescriptorSecretKey.fromMnemonic 生成 descriptor
    final mnemonicObj =
        await bdk.Mnemonic.create(bdk.WordCount.words12); // 或从字符串导入
    final secretKey = await bdk.DescriptorSecretKey.create(
      network: network,
      mnemonic: mnemonicObj,
      password: '', // 如无密码留空
    );
    // 单签 segwit 钱包通用描述符如下
    final descriptor =
        "wpkh(${await secretKey.asString()}/84'/1'/0'/0/*)"; // testnet
    final changeDescriptor =
        "wpkh(${await secretKey.asString()}/84'/1'/0'/1/*)"; // testnet

    // 创建钱包
    final wallet = await createWallet(
      mnemonic: mnemonic,
      network: network,
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
    );

    // 同步钱包
    await syncWallet(wallet, electrumUrl);

    // 查询余额
    final balance = await wallet.getBalance();
    print('当前余额: ${balance.total} sats');

    // 发起转账
    const toAddress = 'tb1...'; // 目标 testnet 地址
    const amountSats = 10000; // 发送 0.0001 BTC

    try {
      final txid = await sendBitcoin(
        wallet: wallet,
        toAddress: toAddress,
        amountSats: amountSats,
        electrumUrl: electrumUrl,
        feeRate: 1.5,
      );
      print('广播成功，TXID: $txid');
    } catch (e) {
      print('转账失败: $e');
    }
    return 'MOCK_TX_HASH_BTC';
  }
}

Future sendBitcoin(
    {required wallet,
    required String toAddress,
    required int amountSats,
    required String electrumUrl,
    required double feeRate}) async {
  final bdk.BlockchainConfig config = bdk.BlockchainConfig.electrum(
      config: bdk.ElectrumConfig(
    url: electrumUrl,
    socks5: null,
    retry: 5,
    timeout: 5,
    stopGap: BigInt.from(10),
    validateDomain: false,
  ));
  final blockchain = await bdk.Blockchain.create(config: config);

  final addressObj = await bdk.Address.fromString(
    s: toAddress,
    network: wallet.network,
  );
  final script = addressObj.scriptPubkey();

  // 构建交易
  final txBuilder = bdk.TxBuilder()
    ..addRecipient(
      script,
      BigInt.from(amountSats),
    )
    ..feeRate(feeRate);

  // 这里直接获得psbt对象
  final (psbt, _) = await txBuilder.finish(wallet);

  // 签名
  await wallet.sign(psbt);

  // 广播
  final transaction = psbt.extractTx();
  final txid = await blockchain.broadcast(transaction: transaction);
  return txid;
}

Future<void> syncWallet(wallet, String electrumUrl) async {
  final bdk.BlockchainConfig config = bdk.BlockchainConfig.electrum(
      config: bdk.ElectrumConfig(
    url: electrumUrl,
    socks5: null,
    retry: 5,
    timeout: 5,
    stopGap: BigInt.from(10),
    validateDomain: false,
  ));
  final blockchain = await bdk.Blockchain.create(config: config);
  await wallet.sync(blockchain);
}

Future createWallet(
    {String? mnemonic,
    required bdk.Network network,
    required String descriptor,
    required String changeDescriptor}) async {
  final walletDescriptor = await bdk.Descriptor.create(
    descriptor: descriptor,
    network: network,
  );

  return await bdk.Wallet.create(
    descriptor: walletDescriptor,
    changeDescriptor: null,
    network: network,
    databaseConfig: const bdk.DatabaseConfig.memory(),
  );
}
