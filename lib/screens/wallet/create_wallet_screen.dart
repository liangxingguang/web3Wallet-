import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/wallet.dart';
import '../../providers/wallet_provider.dart';
import '../../services/btc_service.dart';
import '../../services/eth_service.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({super.key});

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  WalletType _selectedType = WalletType.btc;
  String? _mnemonic;
  String? _address;
  String? _privateKey;

  void _createWallet(BuildContext context) async {
    if (_selectedType == WalletType.btc) {
      final btcWallet = await BtcService.createHDWallet();
      setState(() {
        _mnemonic = btcWallet['mnemonic'];
        _address = btcWallet['address'];
        _privateKey = btcWallet['privateKey'];
      });
    } else if (_selectedType == WalletType.eth ||
        _selectedType == WalletType.bsc) {
      final ethWallet = await EthService.createHDWallet();
      setState(() {
        _mnemonic = ethWallet['mnemonic'];
        _address = ethWallet['address'];
        _privateKey = ethWallet['privateKey'];
      });
    }
    // 其他链同理扩展
  }

  void _saveWallet(BuildContext context) {
    if (_mnemonic == null || _address == null) return;
    final wallet = Wallet(
      name: "${_selectedType.name.toUpperCase()} 钱包",
      address: _address!,
      mnemonic: _mnemonic,
      privateKey: _privateKey,
      type: _selectedType,
      isHD: true,
    );
    Provider.of<WalletProvider>(context, listen: false).addWallet(wallet);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('创建钱包')),
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
            ElevatedButton(
              onPressed: () => _createWallet(context),
              child: const Text('生成钱包'),
            ),
            if (_mnemonic != null) ...[
              SelectableText('助记词: $_mnemonic'),
              SelectableText('地址: $_address'),
              SelectableText('私钥: $_privateKey'),
              ElevatedButton(
                onPressed: () => _saveWallet(context),
                child: const Text('保存钱包'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
