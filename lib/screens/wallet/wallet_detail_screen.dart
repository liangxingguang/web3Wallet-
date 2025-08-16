import 'package:flutter/material.dart';
import '../../models/wallet.dart';
import 'receive_screen.dart';
import 'send_screen.dart';

class WalletDetailScreen extends StatelessWidget {
  final Wallet wallet;

  const WalletDetailScreen({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${wallet.name} 详情'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SelectableText('地址: ${wallet.address}'),
          if (wallet.mnemonic != null) SelectableText('助记词: ${wallet.mnemonic}'),
          if (wallet.privateKey != null) SelectableText('私钥: ${wallet.privateKey}'),
          ListTile(
            leading: Icon(Icons.arrow_downward),
            title: Text('收款'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReceiveScreen(wallet: wallet),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_upward),
            title: Text('转账'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SendScreen(wallet: wallet),
              ),
            ),
          ),
        ],
      ),
    );
  }
}