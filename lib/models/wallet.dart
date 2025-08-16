import 'package:flutter/foundation.dart';

enum WalletType { btc, eth, bsc, tron, sol, polygon, avax, ftm, arbitrum }

class Wallet {
  final String name;
  final String address;
  final String? mnemonic;
  final String? privateKey;
  final WalletType type;
  final bool isHD;

  Wallet({
    required this.name,
    required this.address,
    this.mnemonic,
    this.privateKey,
    required this.type,
    this.isHD = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'mnemonic': mnemonic,
        'privateKey': privateKey,
        'type': describeEnum(type),
        'isHD': isHD,
      };

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        name: json['name'],
        address: json['address'],
        mnemonic: json['mnemonic'],
        privateKey: json['privateKey'],
        type: WalletType.values.firstWhere((e) => describeEnum(e) == json['type']),
        isHD: json['isHD'] ?? false,
      );
}