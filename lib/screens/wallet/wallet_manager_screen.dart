import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../models/wallet.dart';
import 'create_wallet_screen.dart';
import 'import_wallet_screen.dart';
import 'wallet_detail_screen.dart';

class WalletManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('钱包管理'),
      ),
      body: ListView(
        children: [
          ...walletProvider.wallets.map((wallet) => ListTile(
                title: Text(wallet.name),
                subtitle: Text(wallet.address),
                onTap: () {
                  walletProvider.switchWallet(wallet);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WalletDetailScreen(wallet: wallet),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    walletProvider.removeWallet(wallet);
                  },
                ),
              )),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('创建新钱包'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateWalletScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('导入钱包'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ImportWalletScreen()),
            ),
          ),
        ],
      ),
    );
  }
}