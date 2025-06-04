// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepEntryAdapter extends TypeAdapter<StepEntry> {
  @override
  final int typeId = 1;

  @override
  StepEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepEntry(
      date: fields[0] as DateTime,
      stepCount: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.stepCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
