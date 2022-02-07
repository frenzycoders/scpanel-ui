// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerAdapter extends TypeAdapter<Server> {
  @override
  final int typeId = 1;

  @override
  Server read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Server(
      id: fields[0] as int,
      ip: fields[1] as String,
      port: fields[2] as String,
      status: fields[3] as bool,
      error: fields[4] as bool,
      email: fields[5] as String,
      homeDir: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Server obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.port)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.error)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.homeDir);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
