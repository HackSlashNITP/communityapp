// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMessageAdapter extends TypeAdapter<HiveMessage> {
  @override
  final int typeId = 0;

  @override
  HiveMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMessage(
      id: fields[0] as String,
      authorId: fields[1] as String,
      authorName: fields[2] as String?,
      createdAt: fields[3] as int?,
      type: fields[4] as String,
      text: fields[5] as String?,
      uri: fields[6] as String?,
      mimeType: fields[7] as String?,
      size: fields[8] as int?,
      height: fields[9] as double?,
      width: fields[10] as double?,
      name: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMessage obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.authorId)
      ..writeByte(2)
      ..write(obj.authorName)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.text)
      ..writeByte(6)
      ..write(obj.uri)
      ..writeByte(7)
      ..write(obj.mimeType)
      ..writeByte(8)
      ..write(obj.size)
      ..writeByte(9)
      ..write(obj.height)
      ..writeByte(10)
      ..write(obj.width)
      ..writeByte(11)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
