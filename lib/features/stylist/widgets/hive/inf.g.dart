// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inf.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfluencerCodeAdapter extends TypeAdapter<InfluencerCode> {
  @override
  final int typeId = 1;

  @override
  InfluencerCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfluencerCode(
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InfluencerCode obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfluencerCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
