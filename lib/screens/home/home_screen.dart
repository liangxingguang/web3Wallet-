import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Web3多链钱包')),
      body: ListView.builder(
        itemCount: walletProvider.wallets.length,
        itemBuilder: (ctx, idx) {
          final wallet = walletProvider.wallets[idx];
          // 可展示余额、链类型等
          return ListTile(
            title: Text(wallet.name),
            subtitle: Text(wallet.address),
            trailing: Text(wallet.chain.toUpperCase()),
            onTap: () {
              // 跳转至钱包详情/资产页面
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_wallet');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
