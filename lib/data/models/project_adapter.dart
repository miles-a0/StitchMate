import 'package:hive/hive.dart';

import 'project.dart';
import 'counter.dart';

/// Hive TypeAdapter for [Project].
///
/// Manually written to avoid generator dependency issues.
class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 2;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Project(
      id: fields[0] as String,
      name: fields[1] as String,
      craftType: CraftType.values[fields[2] as int],
      status: ProjectStatus.values[fields[3] as int],
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime?,
      notes: fields[6] as String? ?? '',
      yarnIds:
          (fields[7] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      needleSize: fields[8] as String?,
      gaugeStitches: fields[9] as double?,
      gaugeRows: fields[10] as double?,
      counters:
          (fields[11] as List<dynamic>?)?.cast<Counter>() ?? const <Counter>[],
      totalTimeSeconds: fields[12] as int? ?? 0,
      photoUris:
          (fields[13] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      tags: (fields[14] as List<dynamic>?)?.cast<String>() ?? const <String>[],
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.craftType.index)
      ..writeByte(3)
      ..write(obj.status.index)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.yarnIds)
      ..writeByte(8)
      ..write(obj.needleSize)
      ..writeByte(9)
      ..write(obj.gaugeStitches)
      ..writeByte(10)
      ..write(obj.gaugeRows)
      ..writeByte(11)
      ..write(obj.counters)
      ..writeByte(12)
      ..write(obj.totalTimeSeconds)
      ..writeByte(13)
      ..write(obj.photoUris)
      ..writeByte(14)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
