import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/wallet.dart';
import '../../providers/wallet_provider.dart';
import '../../services/btc_service.dart';
import '../../services/eth_service.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  WalletType _selectedType = WalletType.btc;
  final _mnemonicController = TextEditingController();

  void _importWallet(BuildContext context) async {
    final mnemonic = _mnemonicController.text.trim();
    if (mnemonic.isEmpty) return;

    String? address, privateKey;
    if (_selectedType == WalletType.btc) {
      final btcWallet = await BtcService.importFromMnemonic(mnemonic);
      address = btcWallet['address'];
      privateKey = btcWallet['privateKey'];
    } else if (_selectedType == WalletType.eth ||
        _selectedType == WalletType.bsc) {
      final ethWallet = await EthService.importFromMnemonic(mnemonic);
      address = ethWallet['address'];
      privateKey = ethWallet['privateKey'];
    }
    // 其他链同理扩展

    if (address != null) {
      final wallet = Wallet(
        name: "${_selectedType.name.toUpperCase()} 钱包",
        address: address,
        mnemonic: mnemonic,
        privateKey: privateKey,
        type: _selectedType,
        isHD: true,
      );
      Provider.of<WalletProvider>(context, listen: false).addWallet(wallet);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('导入钱包')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<WalletType>(
              value: _selectedType,
              items: WalletType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (type) {
                if (type != null) setState(() => _selectedType = type);
              },
            ),
            TextField(
              controller: _mnemonicController,
              decoration: const InputDecoration(labelText: '助记词'),
            ),
            ElevatedButton(
              onPressed: () => _importWallet(context),
              child: const Text('导入钱包'),
            ),
          ],
        ),
      ),
    );
  }
}
