import '../models/wallet.dart';

class ExportService {
  static String exportMnemonic(Wallet wallet) {
    return wallet.mnemonic ?? '';
  }

  static String exportPrivateKey(Wallet wallet) {
    return wallet.privateKey ?? '';
  }
}