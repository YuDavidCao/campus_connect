import 'package:campus_connect/volunteerForm.dart';
import 'package:campus_connect/widgets.dart';
import 'package:flutter/material.dart';
import 'package:campus_connect/db.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/volunteerEvent.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'themeProvider.dart';
import 'package:flutter/foundation.dart';
import 'main.dart';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';

// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';

class volunteerInfoScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  final ValueNotifier starredNotifier;
  const volunteerInfoScreen(
      {super.key, required this.event, required this.starredNotifier});

  @override
  State<volunteerInfoScreen> createState() => _volunteerInfoScreenState();
}

class _volunteerInfoScreenState extends State<volunteerInfoScreen> {
  late bool signedUp;
  bool originallySignedUp = false;
  bool ifUpdated = false;

  late final bool eventNameUpdated =
      volunteerBox.containsKey(widget.event["id"]) &&
          volunteerBox.get(widget.event["id"])!.eventName !=
              widget.event["EventName"];
  late final bool csHoursUpdated = volunteerBox
          .containsKey(widget.event["id"]) &&
      volunteerBox.get(widget.event["id"])!.csHours != widget.event["CsHours"];
  late final bool hostClubUpdated =
      volunteerBox.containsKey(widget.event["id"]) &&
          volunteerBox.get(widget.event["id"])!.hostClub !=
              widget.event["HostClub"];
  late final bool kindUpdated = volunteerBox.containsKey(widget.event["id"]) &&
      !listEquals(
          volunteerBox.get(widget.event["id"])!.kind, widget.event["Kind"]);
  late final bool detailsUpdated = volunteerBox
          .containsKey(widget.event["id"]) &&
      volunteerBox.get(widget.event["id"])!.details != widget.event["Details"];
  late final bool timeUpdated = volunteerBox.containsKey(widget.event["id"]) &&
      volunteerBox.get(widget.event["id"])!.time !=
          DateTime.parse(widget.event["Time"]);
  late final bool locationUpdated =
      volunteerBox.containsKey(widget.event["id"]) &&
          volunteerBox.get(widget.event["id"])!.location !=
              widget.event["Location"];
  late final bool eventOfficerUpdated =
      volunteerBox.containsKey(widget.event["id"]) &&
          volunteerBox.get(widget.event["id"])!.eventOfficer !=
              widget.event["EventOfficer"];
  late final bool phoneNumberUpdated =
      volunteerBox.containsKey(widget.event["id"]) &&
          volunteerBox.get(widget.event["id"])!.phoneNumber !=
              widget.event["PhoneNumber"];
  late final bool emailUpdated = volunteerBox.containsKey(widget.event["id"]) &&
      volunteerBox.get(widget.event["id"])!.email != widget.event["Email"];
  late final bool wechatUpdated = volunteerBox
          .containsKey(widget.event["id"]) &&
      volunteerBox.get(widget.event["id"])!.wechat != widget.event["Wechat"];
  late final bool countUpdated = volunteerBox.containsKey(widget.event["id"]) &&
      volunteerBox.get(widget.event["id"])!.count != widget.event["Count"];
  late final bool spotUpdated = volunteerBox.containsKey(widget.event["id"]) &&
      volunteerBox.get(widget.event["id"])!.spots != widget.event["Spots"];

  bool userNotified = false;

  @override
  void initState() {
    signedUp =
        widget.event["Participants"].contains(supabase.auth.currentUser!.id);
    if (signedUp) {
      originallySignedUp = true;
      // initialize if Updated
      ifUpdated = updatedEventIdBox.containsKey(widget.event["id"]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Volunteer Info'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                widget.starredNotifier.value = !widget.starredNotifier.value;
              });
              if (!widget.starredNotifier.value) {
                unStarVolunteerEventOnFirebase(widget.event["id"]);
              } else {
                starVolunteerEventOnFirebase(widget.event["id"]);
              }
            },
            icon: ValueListenableBuilder(
              valueListenable: widget.starredNotifier,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Icon(widget.starredNotifier.value
                    ? Icons.star
                    : Icons.star_border);
              },
            ),
          )
          // IconButton(
          //   icon: Icon(Icons.star_border),
          //   onPressed: () {
          //     // change the appearance of the Icon to solid star, manage volunteer info screen in starred screen
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Header('Event name:'),
                // if (eventNameUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event["EventName"]),

            Row(
              children: [
                const Header('Cs hours:'),
                // if (csHoursUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event["CsHours"].toString()),

            Row(
              children: [
                const Header('Host club:'),
                // if (hostClubUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event["HostClub"]),

            Row(
              children: [
                const Header('Kind:'),
                // if (kindUpdated) const UpdatedChip(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Wrap(
                children: [
                  for (int i = 0; i < widget.event["Kind"].length; i++)
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: FilterChip(
                        label: Text(widget.event["Kind"][i]),
                        selected: true, //display true / false
                        onSelected: (bool selected) {},
                      ),
                    ),
                ],
              ),
            ),

            Row(
              children: [
                const Header('Details:'),
                // if (detailsUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event["Details"]),

            Row(
              children: [
                const Header('Time:'),
                // if (timeUpdated) const UpdatedChip(),
              ],
            ), //////////////////edit
            Paragraph(DateFormat("MM/dd hh:mm")
                .format(DateTime.parse(widget.event["Time"]))
                .toString()),

            Row(
              children: [
                const Header('Location:'),
                // if (locationUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event["Location"]),

            Row(
              children: [
                const Header('Event Officer:'),
                // if (eventOfficerUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event["EventOfficer"]),

            Row(
              children: [
                const Icon(Icons.phone),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.event['PhoneNumber'].toString(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                // if (phoneNumberUpdated) const UpdatedChip(),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.email),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.event['Email'],
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                // if (emailUpdated) const UpdatedChip(),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.wechat),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.event['Wechat'],
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                // if (wechatUpdated) const UpdatedChip(),
              ],
            ),
            // we want to increase the spot by 1 only if the user is
            // originally signed up and they have quitted, since
            // the variable signedUp will change, we created originallySignedUp
            // to keep track of whether the user is originally signed up
            // if both condition is met, we add 1 to the spot.
            // similar to other case
            Row(
              children: [
                const Header('Spots left:'),
                // if (spotUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph((widget.event["Spots"] -
                    widget.event["Participants"].length +
                    ((originallySignedUp && !signedUp) ? 1 : 0) +
                    ((!originallySignedUp && signedUp) ? -1 : 0))
                .toString()),

            Row(
              children: [
                const Header('Overall spots:'),
                // if (spotUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event['Spots'].toString()),

            if (widget.event["CreatorUid"] == supabase.auth.currentUser!.id)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(
                      'Participants info:'), //only available to the creator of this event
                  for (int i = 0; i < widget.event["Participants"].length; i++)
                    FutureBuilder<Map?>(
                      future: getStudentInfo(widget.event["Participants"][i]),
                      builder:
                          (BuildContext context, AsyncSnapshot<Map?> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.data! != null
                                    ? Paragraph(
                                        "${snapshot.data!["username"]} ${snapshot.data!["chineseName"]}  ${snapshot.data!["studentNumber"]} ${snapshot.data!["email"]}")
                                    : const Paragraph("Deleted User"),
                                Divider(
                                  color: Provider.of<ThemeProvider>(context,
                                                  listen: false)
                                              .themeMode ==
                                          ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  thickness: 1,
                                ),
                              ]);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
            Row(
              children: [
                const Header('Count:'),
                // if (countUpdated) const UpdatedChip(),
              ],
            ),
            Paragraph(widget.event["Count"].toString()),
            VisibilityDetector(
              key: const Key("unique key"),
              onVisibilityChanged: (VisibilityInfo info) {
                if (info.visibleFraction == 1) {
                  // if this is on the screen
                  userNotified = true;
                }
              },
              child: ElevatedButton(
                  onPressed: () async {
                    if (widget.event["Spots"] ==
                            widget.event["Participants"].length &&
                        !originallySignedUp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No spots left')));
                      return;
                    }
                    !signedUp
                        ? await participate(widget.event["id"],
                            VolunteerEvent.firebaseDeSerialize(widget.event))
                        : await quitEvent(widget.event["id"],
                            VolunteerEvent.firebaseDeSerialize(widget.event));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(!signedUp
                            ? 'Signed up successfully!'
                            : 'Quit successfully!')));
                    setState(() {
                      signedUp = !signedUp;
                    });
                  },
                  child: Text(widget.event["Spots"] ==
                              widget.event["Participants"].length &&
                          !originallySignedUp
                      ? 'no spots left'
                      : (!signedUp)
                          ? 'Sign up'
                          : 'Quit event')),
            ),
            if (widget.event["CreatorUid"] == supabase.auth.currentUser!.id)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => volunteerForm(
                        event: widget.event,
                      ),
                    ),
                  );
                }, ///////////
                child: const Text('Edit'),
              ),
            // if (widget.event["CreatorUid"] == supabase.auth.currentUser!.id)
            //   ElevatedButton(
            //       onPressed: () async {
            //         final plugin = DeviceInfoPlugin();
            //         final android = await plugin.androidInfo;

            //         final storageStatus = android.version.sdkInt < 33
            //             ? await Permission.storage.request()
            //             : PermissionStatus.granted;
            //         if (storageStatus == PermissionStatus.granted) {
            //           try {
            //             final response = await http.post(
            //                 Uri.parse("http://44.221.194.95:5000/generate_pdf"),
            //                 headers: {'Content-Type': "application/json"},
            //                 body: '{"docId": "${widget.event["id"]}"}');

            //             if (response.statusCode == 200) {
            //               final directory = await FileStorage._localPath;
            //               final filePath =
            //                   "$directory/${widget.event["id"]}_report.pdf";
            //               final file = File(filePath);
            //               await file.writeAsBytes(response.bodyBytes);
            //               await Share.shareXFiles([XFile(filePath)],
            //                   text:
            //                       "Activity report saved! Share it to other apps?");
            //             } else {
            //               print(response.statusCode);
            //               print(response.body);
            //             }
            //           } catch (e) {
            //             print(e);
            //           }
            //         } else {
            //           print("no storage permission");
            //         }
            //       },
            //       child: const Text("Save activity report")),
          ],
        ),
      ),
    );
  }
}

// class FileStorage {
//   static Future<String> getExternalDocumentPath() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//     Directory _directory = Directory("dir");
//     if (Platform.isAndroid) {
//       _directory = Directory("/storage/emulated/0/Download/CampusConnect");
//     } else {
//       _directory = await getApplicationDocumentsDirectory();
//     }

//     final exPath = _directory.path;
//     await Directory(exPath).create(recursive: true);
//     return exPath;
//   }

//   static Future<String> get _localPath async {
//     final String directory = await getExternalDocumentPath();
//     return directory;
//   }
// }

// class UpdatedChip extends StatelessWidget {
//   const UpdatedChip({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.circular(1000),
//       ),
//       child: const Text(
//         'Updated!',
//         style: TextStyle(color: Colors.white, fontSize: 15),
//       ),
//     );
//   }
// }
