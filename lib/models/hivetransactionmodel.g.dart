// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hivetransactionmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTransactionsAdapter extends TypeAdapter<HiveTransactions> {
  @override
  final int typeId = 1;

  @override
  HiveTransactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTransactions(
      amount: fields[0] as int,
      description: fields[1] as String,
      dateTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTransactions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTransactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
