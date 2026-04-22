import 'package:hive/hive.dart';

import 'timer_session.dart';

/// Manual Hive TypeAdapter for [TimerSession].
///
/// typeId: 4 — must be unique and never change.
class TimerSessionAdapter extends TypeAdapter<TimerSession> {
  @override
  final int typeId = 4;

  @override
  TimerSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerSession(
      id: fields[0] as String,
      projectId: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      durationSeconds: fields[4] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, TimerSession obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.durationSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
