// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  final int typeId = 0;

  @override
  Wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet(
      name: fields[0] as String,
      address: fields[1] as String,
      mnemonic: fields[2] as String?,
      privateKey: fields[3] as String?,
      type: fields[4] as WalletType,
      isHD: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.mnemonic)
      ..writeByte(3)
      ..write(obj.privateKey)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isHD);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WalletTypeAdapter extends TypeAdapter<WalletType> {
  @override
  final int typeId = 1;

  @override
  WalletType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WalletType.btc;
      case 1:
        return WalletType.eth;
      case 2:
        return WalletType.bsc;
      case 3:
        return WalletType.tron;
      case 4:
        return WalletType.sol;
      case 5:
        return WalletType.polygon;
      case 6:
        return WalletType.avax;
      case 7:
        return WalletType.ftm;
      case 8:
        return WalletType.arbitrum;
      default:
        return WalletType.btc;
    }
  }

  @override
  void write(BinaryWriter writer, WalletType obj) {
    switch (obj) {
      case WalletType.btc:
        writer.writeByte(0);
        break;
      case WalletType.eth:
        writer.writeByte(1);
        break;
      case WalletType.bsc:
        writer.writeByte(2);
        break;
      case WalletType.tron:
        writer.writeByte(3);
        break;
      case WalletType.sol:
        writer.writeByte(4);
        break;
      case WalletType.polygon:
        writer.writeByte(5);
        break;
      case WalletType.avax:
        writer.writeByte(6);
        break;
      case WalletType.ftm:
        writer.writeByte(7);
        break;
      case WalletType.arbitrum:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
