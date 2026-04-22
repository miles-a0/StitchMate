import 'package:hive_flutter/hive_flutter.dart';

import '../models/yarn.dart';

/// Manual Hive TypeAdapter for [Yarn].
///
/// typeId: 3 (must be unique across all adapters).
class YarnAdapter extends TypeAdapter<Yarn> {
  @override
  final int typeId = 3;

  @override
  Yarn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Yarn(
      id: fields[0] as String,
      brand: fields[1] as String,
      colourName: fields[2] as String,
      weight: fields[3] as String,
      fibre: fields[4] as String,
      yardagePerSkein: fields[5] as int,
      metreagePerSkein: fields[6] as int,
      gramsPerSkein: fields[7] as int,
      skeinCount: fields[8] as int,
      hexColour: fields[9] as String,
      notes: fields[10] as String? ?? '',
      purchaseLocation: fields[11] as String?,
      status: fields[12] as String? ?? YarnStatus.available,
      linkedProjectIds:
          (fields[13] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      photoUris:
          (fields[14] as List<dynamic>?)?.cast<String>() ?? const <String>[],
    );
  }

  @override
  void write(BinaryWriter writer, Yarn obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.colourName)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.fibre)
      ..writeByte(5)
      ..write(obj.yardagePerSkein)
      ..writeByte(6)
      ..write(obj.metreagePerSkein)
      ..writeByte(7)
      ..write(obj.gramsPerSkein)
      ..writeByte(8)
      ..write(obj.skeinCount)
      ..writeByte(9)
      ..write(obj.hexColour)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.purchaseLocation)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.linkedProjectIds)
      ..writeByte(14)
      ..write(obj.photoUris);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YarnAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
