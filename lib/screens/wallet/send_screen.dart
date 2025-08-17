import 'package:flutter/material.dart';
import 'package:web3_wallet/models/wallet.dart';
import '../../services/btc_service.dart';
import '../../services/eth_service.dart';

class SendScreen extends StatefulWidget {
  final Wallet wallet;

  const SendScreen({super.key, required this.wallet});

  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  String? _txHash;
  bool _sending = false;

  void _send() async {
    setState(() {
      _sending = true;
      _txHash = null;
    });
    String? txHash;
    if (widget.wallet.type == WalletType.btc) {
      txHash = await BtcService.send(
        widget.wallet,
        _addressController.text.trim(),
        double.tryParse(_amountController.text.trim()) ?? 0,
      );
    } else if (widget.wallet.type == WalletType.eth ||
        widget.wallet.type == WalletType.bsc) {
      txHash = await EthService.send(
        widget.wallet,
        _addressController.text.trim(),
        double.tryParse(_amountController.text.trim()) ?? 0,
      );
    }
    // 其他链同理扩展
    setState(() {
      _txHash = txHash;
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('转账')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: '收款地址'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: '金额'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sending ? null : _send,
              child: Text(_sending ? '发送中...' : '发送'),
            ),
            if (_txHash != null) SelectableText('交易哈希: $_txHash'),
          ],
        ),
      ),
    );
  }
}
