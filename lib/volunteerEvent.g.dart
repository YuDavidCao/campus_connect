// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteerEvent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VolunteerEventAdapter extends TypeAdapter<VolunteerEvent> {
  @override
  final int typeId = 0;

  @override
  VolunteerEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VolunteerEvent(
      eventName: fields[0] as String,
      count: fields[1] as int,
      kind: (fields[2] as List).cast<dynamic>(),
      csHours: fields[3] as double,
      time: fields[4] as DateTime,
      location: fields[5] as String,
      details: fields[6] as String,
      eventOfficer: fields[7] as String,
      spots: fields[8] as int,
      participants: (fields[9] as List).cast<dynamic>(),
      phoneNumber: fields[10] as int,
      email: fields[11] as String,
      wechat: fields[12] as String,
      creatorUid: fields[13] as String,
      completed: (fields[14] as List).cast<dynamic>(),
      hostClub: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VolunteerEvent obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.kind)
      ..writeByte(3)
      ..write(obj.csHours)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.details)
      ..writeByte(7)
      ..write(obj.eventOfficer)
      ..writeByte(8)
      ..write(obj.spots)
      ..writeByte(9)
      ..write(obj.participants)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.wechat)
      ..writeByte(13)
      ..write(obj.creatorUid)
      ..writeByte(14)
      ..write(obj.completed)
      ..writeByte(15)
      ..write(obj.hostClub);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolunteerEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
