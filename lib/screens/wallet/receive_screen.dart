import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/wallet.dart';

class ReceiveScreen extends StatelessWidget {
  final Wallet wallet;

  const ReceiveScreen({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('收款')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: wallet.address,
              size: 200,
            ),
            SizedBox(height: 16),
            SelectableText('钱包地址: ${wallet.address}'),
          ],
        ),
      ),
    );
  }
}