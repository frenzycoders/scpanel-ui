// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UtilsAdapter extends TypeAdapter<Utils> {
  @override
  final int typeId = 2;

  @override
  Utils read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Utils(
      httpType: fields[0] as String,
      token: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Utils obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.httpType)
      ..writeByte(1)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UtilsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
