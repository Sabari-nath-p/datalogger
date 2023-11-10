// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MDataAdapter extends TypeAdapter<MData> {
  @override
  final int typeId = 0;

  @override
  MData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MData(
      fields[2] as String?,
      fields[3] as String?,
      fields[1] as String?,
      fields[4] as String?,
      fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.timeStamp)
      ..writeByte(1)
      ..write(obj.ph)
      ..writeByte(2)
      ..write(obj.Dh)
      ..writeByte(3)
      ..write(obj.temp)
      ..writeByte(4)
      ..write(obj.pressure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
