import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../models/wallet.dart';
import 'wallet_detail_screen.dart';

class WalletManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF6F8FC),
      appBar: AppBar(
        title: Text('资产总览'),
        backgroundColor: Color(0xFF2176FF),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ...walletProvider.wallets.map((wallet) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                margin: EdgeInsets.only(bottom: 14),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[50],
                    child: Icon(Icons.account_balance_wallet, color: Color(0xFF2176FF)),
                  ),
                  title: Text(wallet.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(wallet.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    walletProvider.switchWallet(wallet);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WalletDetailScreen(wallet: wallet),
                      ),
                    );
                  },
                ),
              )),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.add, color: Color(0xFF2176FF)),
              title: Text('添加/导入钱包', style: TextStyle(color: Color(0xFF2176FF))),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text('创建新钱包'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/create_wallet');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.input),
                        title: Text('导入钱包'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/import_wallet');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}