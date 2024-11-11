import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'volunteerEvent.g.dart';

@HiveType(typeId: 0)
class VolunteerEvent extends Equatable {
  @override
  List<Object?> get props => [
        eventName,
        count,
        kind,
        csHours,
        time,
        location,
        details,
        eventOfficer,
        spots,
        phoneNumber,
        email,
        wechat,
        creatorUid,
        hostClub,
      ];

  @HiveField(0)
  final String eventName;

  @HiveField(1)
  final int count;

  @HiveField(2)
  final List kind;

  @HiveField(3)
  final double csHours;

  @HiveField(4)
  final DateTime time;

  @HiveField(5)
  final String location;

  @HiveField(6)
  final String details;

  @HiveField(7)
  final String eventOfficer;

  @HiveField(8)
  final int spots;

  @HiveField(9)
  final List participants;

  @HiveField(10)
  final int phoneNumber;

  @HiveField(11)
  final String email;

  @HiveField(12)
  final String wechat;

  @HiveField(13)
  final String creatorUid;

  @HiveField(14)
  final List completed;

  @HiveField(15)
  final String hostClub;

  const VolunteerEvent({
    required this.eventName,
    required this.count,
    required this.kind,
    required this.csHours,
    required this.time,
    required this.location,
    required this.details,
    required this.eventOfficer,
    required this.spots,
    required this.participants,
    required this.phoneNumber,
    required this.email,
    required this.wechat,
    required this.creatorUid,
    required this.completed,
    required this.hostClub,
  });

  Map<String, dynamic> toMap() {
    return {
      'EventName': eventName,
      'Count': count,
      'Kind': kind,
      'CsHours': csHours,
      'Time': time.toIso8601String(),
      'Location': location,
      'Details': details,
      'EventOfficer': eventOfficer,
      'Spots': spots,
      'Participants': participants,
      'PhoneNumber': phoneNumber,
      'Email': email,
      'Wechat': wechat,
      'CreatorUid': creatorUid,
      'Completed': completed,
      'HostClub': hostClub,
    };
  }

  static VolunteerEvent firebaseDeSerialize(Map<String, dynamic> firebaseData) {
    print(firebaseData);
    return VolunteerEvent(
      eventName: firebaseData["EventName"],
      count: firebaseData["Count"],
      kind: firebaseData["Kind"],
      csHours: firebaseData["CsHours"].toDouble(),
      time: DateTime.parse(firebaseData["Time"]),
      location: firebaseData["Location"],
      details: firebaseData["Details"],
      eventOfficer: firebaseData["EventOfficer"],
      spots: firebaseData["Spots"],
      participants: firebaseData["Participants"],
      phoneNumber: int.parse(firebaseData["PhoneNumber"]),
      email: firebaseData["Email"],
      wechat: firebaseData["Wechat"],
      creatorUid: firebaseData["CreatorUid"],
      completed: firebaseData["Completed"],
      hostClub: firebaseData["HostClub"],
    );
  }

  static VolunteerEvent fromMap(Map<String, dynamic> map) {
    return VolunteerEvent(
      eventName: map['EventName'],
      count: map['Count'],
      kind: map['Kind'],
      csHours: map['CsHours'].toDouble(),
      // time: map['Time'],
      time: DateTime.parse(map['Time']),
      location: map['Location'],
      details: map['Details'],
      eventOfficer: map['EventOfficer'],
      spots: map['Spots'],
      participants: map['Participants'],
      phoneNumber: map['PhoneNumber'],
      email: map['Email'],
      wechat: map['Wechat'],
      creatorUid: map['CreatorUid'],
      completed: map['Completed'],
      hostClub: map['HostClub'],
    );
  }

  @override
  String toString() {
    return 'VolunteerEvent{eventName: $eventName, count: $count, kind: $kind, csHours: $csHours, time: $time, location: $location, details: $details, eventOfficer: $eventOfficer, spots: $spots, participants: $participants, phoneNumber: $phoneNumber, email: $email, wechat: $wechat, creatorUid: $creatorUid, completed: $completed, hostClub: $hostClub}';
  }
}
