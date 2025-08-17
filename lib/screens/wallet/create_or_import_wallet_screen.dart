import 'package:flutter/material.dart';

class CreateOrImportWalletScreen extends StatelessWidget {
  const CreateOrImportWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('创建或导入钱包')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/create_wallet'),
              child: const Text('创建新钱包'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/import_wallet'),
              child: const Text('导入已有钱包'),
            ),
          ],
        ),
      ),
    );
  }
}
