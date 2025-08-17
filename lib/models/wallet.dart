import 'package:hive/hive.dart';

part 'wallet.g.dart';

@HiveType(typeId: 1)
enum WalletType {
  @HiveField(0)
  btc,
  @HiveField(1)
  eth,
  @HiveField(2)
  bsc,
  @HiveField(3)
  tron,
  @HiveField(4)
  sol,
  @HiveField(5)
  polygon,
  @HiveField(6)
  avax,
  @HiveField(7)
  ftm,
  @HiveField(8)
  arbitrum,
}

@HiveType(typeId: 0)
class Wallet {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String address;

  @HiveField(2)
  final String? mnemonic;

  @HiveField(3)
  final String? privateKey;

  @HiveField(4)
  final WalletType type;

  @HiveField(5)
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
        'type': type.name,
        'isHD': isHD,
      };

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        name: json['name'],
        address: json['address'],
        mnemonic: json['mnemonic'],
        privateKey: json['privateKey'],
        type: WalletType.values.firstWhere((e) => e.name == json['type']),
        isHD: json['isHD'] ?? false,
      );

  get descriptor => null;

  get changeDescriptor => null;

  get chain => null;

  Future getBalance() async {}
}
