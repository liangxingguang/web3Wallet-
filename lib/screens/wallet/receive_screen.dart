import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/wallet.dart';

class ReceiveScreen extends StatelessWidget {
  final Wallet wallet;

  const ReceiveScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收款')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: wallet.address,
              size: 200,
            ),
            const SizedBox(height: 16),
            SelectableText('钱包地址: ${wallet.address}'),
          ],
        ),
      ),
    );
  }
}
