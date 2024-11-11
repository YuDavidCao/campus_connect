import 'package:campus_connect/volunteerForm.dart';
import 'package:flutter/material.dart';
import 'package:campus_connect/volunteerInfoScreen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/userProvider.dart';
import 'package:campus_connect/volunteerEventProvider.dart';
import 'package:campus_connect/globalAppBar.dart';

import 'db.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Consumer<UserProvider>(
            builder: (context, UserProvider userProvider, child) {
          return userProvider.isAdmin
              ? const Text("Home (Admin)")
              : const Text("Home");
        }),
      ),
      body: Consumer<VolunteerEventProvider>(
        builder:
            (context, VolunteerEventProvider volunteerEventProvider, child) {
          return ListView.builder(
              itemCount: volunteerEventProvider.volunteerEvents.length,
              itemBuilder: (context, index) {
                return VolunteerListTitle(
                    querySnapshot:
                        volunteerEventProvider.volunteerEvents[index]);
              });
        },
      ),
      floatingActionButton: Consumer<UserProvider>(
        builder: (context, UserProvider userProvider, child) {
          return !userProvider.isAdmin
              ? FloatingActionButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const volunteerForm(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : const SizedBox();
        },
      ),
      bottomNavigationBar: const GlobalAppBar(pageName: "home"),
    );
  }
}

class VolunteerListTitle extends StatefulWidget {
  final Map<String, dynamic> querySnapshot;
  final IconData icon;
  const VolunteerListTitle(
      {super.key, required this.querySnapshot, this.icon = Icons.star});

  @override
  State<VolunteerListTitle> createState() => _VolunteerListTitleState();
}

class _VolunteerListTitleState extends State<VolunteerListTitle> {
  ValueNotifier<bool> starred = ValueNotifier(false);

  @override
  void initState() {
    initStar();
    super.initState();
  }

  void initStar() async {
    starred.value = await ifStarred(widget.querySnapshot["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromARGB(255, 219, 241, 221), // Border color
          width: 1.5, // Border width
        ),
        borderRadius: BorderRadius.circular(25.0), // Optional: border radius
      ),
      child: ListTile(
        title: Text(
          widget.querySnapshot["EventName"],
          style: const TextStyle(fontSize: 25),
        ),
        subtitle: Text(widget.querySnapshot["CsHours"].toString() +
            " cs hours, " +
            DateFormat("MM/dd hh:mm")
                .format(DateTime.parse(widget.querySnapshot["Time"]))
                .toString() +
            ", " +
            widget.querySnapshot["Kind"].toString()),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              starred.value = !starred.value;
            });
            if (!starred.value) {
              unStarVolunteerEventOnFirebase(widget.querySnapshot["id"]);
            } else {
              starVolunteerEventOnFirebase(widget.querySnapshot["id"]);
            }
          },
          // this widget will listen to the starred valueNotifier and
          // when the starred valueNotifer's value changes, the builder
          // will rebuild
          icon: ValueListenableBuilder(
            valueListenable: starred,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Icon(starred.value ? widget.icon : Icons.star_border);
            },
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => volunteerInfoScreen(
                event: widget.querySnapshot,
                starredNotifier: starred,
              ),
            ),
          );
        },
      ),
    );
  }
}
