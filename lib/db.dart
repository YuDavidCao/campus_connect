import 'package:campus_connect/volunteerEvent.dart';
import 'main.dart';

String collection = 'SCIE-Students';

//tested
Future<void> sendParticipateMessage(
    String docId, String creatorId, String name, String eventName) async {
  await supabase.from("Messages").insert({
    "receiver": creatorId,
    "text": "$name joined $eventName",
    "docId": docId,
    "time": DateTime.now().toIso8601String(),
    "studentId": supabase.auth.currentUser!.id
  });
}

//tested
Future<void> sendQuitMessage(
    String docId, String creatorId, String name, String eventName) async {
  await supabase.from("Messages").insert({
    "receiver": creatorId,
    "text": "$name quit $eventName",
    "docId": docId,
    "time": DateTime.now().toIso8601String(),
    "studentId": supabase.auth.currentUser!.id
  });
}

//tested
Future<void> participate(String docId, VolunteerEvent volunteerEvent) async {
  List<Map<String, dynamic>> volunteerInfo =
      await supabase.from("Volunteer").select().eq(
            "id",
            docId,
          );
  Map<String, dynamic> volunteerEventMap = volunteerInfo[0];
  volunteerEventMap["Participants"].add(supabase.auth.currentUser!.id);
  await supabase.from("Volunteer").upsert(volunteerEventMap);
  volunteerBox.put(docId, volunteerEvent);
  Map<String, dynamic>? studentInfo =
      await getStudentInfo(supabase.auth.currentUser!.id);
  if (studentInfo == null) return;
  await sendParticipateMessage(docId, volunteerEvent.creatorUid,
      studentInfo["username"], volunteerEvent.eventName);
}

//tested
Future<void> quitEvent(String docId, VolunteerEvent volunteerEvent) async {
  List<Map<String, dynamic>> volunteerInfo =
      await supabase.from("Volunteer").select().eq(
            "id",
            docId,
          );
  Map<String, dynamic> volunteerEventMap = volunteerInfo[0];
  volunteerEventMap["Participants"].remove(supabase.auth.currentUser!.id);
  print(volunteerEventMap["Participants"]);
  await supabase.from("Volunteer").upsert(volunteerEventMap);
  volunteerBox.put(docId, volunteerEvent);
  Map<String, dynamic>? studentInfo =
      await getStudentInfo(supabase.auth.currentUser!.id);
  if (studentInfo == null) return;
  await sendQuitMessage(docId, volunteerEvent.creatorUid,
      studentInfo["username"], volunteerEvent.eventName);
}
// await FirebaseFirestore.instance.collection('Volunteer').doc(docId).update({
//   "Participants":
//       FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
// });
// if (volunteerBox.containsKey(docId)) {
//   volunteerBox.delete(docId);
// }
// Map? studentInfo =
//     await getStudentInfo(FirebaseAuth.instance.currentUser!.uid);
// if (studentInfo == null) return;
// await sendQuitMessage(docId, volunteerEvent.creatorUid,
//     studentInfo["username"], volunteerEvent.eventName);

// tested
Future<void> storeVolunteerEvent(VolunteerEvent volunteerEvent) async {
  await supabase.from("Volunteer").upsert(volunteerEvent.toMap());
}

// tested
Future<void> updateVolunteerEvent(
    String docId, VolunteerEvent volunteerEvent) async {
  await supabase
      .from("Volunteer")
      .update(volunteerEvent.toMap())
      .eq("id", docId);
}

//tested
Future<bool> ifStarred(String docId) async {
  var volunteerEvent = await supabase
      .from(collection)
      .select()
      .eq("id", supabase.auth.currentUser!.id);
  return volunteerEvent.isNotEmpty &&
      volunteerEvent[0]["starred"].contains(docId);
}

//tested
Future<Map<String, dynamic>?> getVolunteerEvent(String docId) async {
  final response = await supabase.from("Volunteer").select().eq("id", docId);
  return response.isEmpty ? null : response[0];
}

//tested
Future<void> unStarVolunteerEventOnFirebase(String docId) async {
  Map<String, dynamic>? student =
      await getStudentInfo(supabase.auth.currentUser!.id);
  if (student == null) return;
  student["starred"].remove(docId);
  await supabase.from(collection).update({"starred": student["starred"]}).eq(
      "id", supabase.auth.currentUser!.id);
}

//tested
Future<void> starVolunteerEventOnFirebase(String docId) async {
  Map<String, dynamic>? student =
      await getStudentInfo(supabase.auth.currentUser!.id);
  if (student == null) return;
  student["starred"].add(docId);
  print(student["starred"]);
  await supabase.from(collection).update({"starred": student["starred"]}).eq(
      "id", supabase.auth.currentUser!.id);
}

//tested
Future<Map<String, dynamic>?> getUserInfo() async {
  Map<String, dynamic>? userInfo =
      await getStudentInfo(supabase.auth.currentUser!.id);
  return userInfo;
}

//tested
Future<Map<String, dynamic>?> getStudentInfo(String uid) async {
  final response = await supabase.from(collection).select().eq('id', uid);
  return response.isEmpty ? null : response[0];
}

//tested
Future<bool> setUserInfo(Map<String, dynamic> data) async {
  data['id'] = supabase.auth.currentUser!.id;
  supabase
      .from(collection)
      .upsert(data)
      .then((value) => print('upsert successful'));
  return true;
}

//tested
Future<bool> ifStudentNumberUnique(String studentNumber) async {
  final response = await supabase
      .from(collection)
      .select()
      .eq('studentNumber', studentNumber);
  return response.isEmpty;
}

Future recordApproveStudent(
    List<bool> approved, List participants, String docId) async {
  List<String> approvedStudents = [];
  List<String> disapprovedStudents = [];
  for (int i = 0; i < participants.length; i++) {
    if (approved[i]) {
      approvedStudents.add(participants[i]);
    } else {
      disapprovedStudents.add(participants[i]);
    }
  }
  await supabase.from("Volunteer").update({
    "Completed": approvedStudents,
  }).eq("id", docId);
  for (int i = 0; i < approvedStudents.length; i++) {
    markAsCompleted(approvedStudents[i], docId);
  }
  for (int i = 0; i < disapprovedStudents.length; i++) {
    undoMarkAsCompleted(disapprovedStudents[i], docId);
  }
}

Future<void> markAsCompleted(String uid, String docId) async {
  Map<String, dynamic>? studentInfo = await getStudentInfo(uid);
  if (studentInfo == null) return;
  studentInfo["completed"].add(docId);
  await supabase.from(collection).update({
    "completed": studentInfo["completed"],
  }).eq("id", uid);
}

Future<void> undoMarkAsCompleted(String uid, String docId) async {
  Map<String, dynamic>? studentInfo = await getStudentInfo(uid);
  if (studentInfo == null) return;
  studentInfo["completed"].remove(docId);
  await supabase.from(collection).update({
    "completed": studentInfo["completed"],
  }).eq("id", uid);
}

//untested
Future<bool> deleteAccount() async {
  try {
    await supabase
        .from(collection)
        .delete()
        .eq('id', supabase.auth.currentUser!.id);
    await supabase.auth.admin.deleteUser(supabase.auth.currentUser!.id);
    return true;
  } catch (e) {
    return false;
  }
}
