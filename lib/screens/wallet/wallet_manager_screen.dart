import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';

class WalletManagerScreen extends StatelessWidget {
  const WalletManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('资产总览'),
        backgroundColor: const Color(0xFF2176FF),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...walletProvider.wallets.map((wallet) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                margin: const EdgeInsets.only(bottom: 14),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[50],
                    child: const Icon(Icons.account_balance_wallet,
                        color: Color(0xFF2176FF)),
                  ),
                  title: Text(wallet.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(wallet.address,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    walletProvider.switchWallet(wallet);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WalletDetailScreen(),
                      ),
                    );
                  },
                ),
              )),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.add, color: Color(0xFF2176FF)),
              title: const Text('添加/导入钱包',
                  style: TextStyle(color: Color(0xFF2176FF))),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.add_circle_outline),
                        title: const Text('创建新钱包'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/create_wallet');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.input),
                        title: const Text('导入钱包'),
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

WalletDetailScreen() {}
