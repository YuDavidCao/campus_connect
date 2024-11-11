import 'package:campus_connect/approvePage.dart';
import 'package:flutter/material.dart';
import 'package:campus_connect/db.dart';
import 'package:campus_connect/homescreen.dart';
import 'package:campus_connect/userProvider.dart';
import 'package:campus_connect/globalAppBar.dart';
import 'package:provider/provider.dart';
import 'widgets.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'volunteerInfoScreen.dart';

class myEventsPage extends StatefulWidget {
  final tabIndex;
  const myEventsPage({super.key, this.tabIndex = 0});

  @override
  State<myEventsPage> createState() => _myEventsPageState();
}

class _myEventsPageState extends State<myEventsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // programmatically move the tab to widget.tabIndex in the beginning

  // late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length:
            Provider.of<UserProvider>(context, listen: false).isAdmin ? 4 : 3,
        vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goToSpecificTab(widget.tabIndex);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToSpecificTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Events'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(
                icon: const Icon(Icons.upcoming),
                text: 'Upcoming',
              ),
              const Tab(
                icon: Icon(Icons.history),
                text: 'Past',
              ),
              const Tab(
                icon: Icon(Icons.star),
                text: 'Starred',
              ),
              const Tab(
                icon: Icon(Icons.construction),
                text: 'Created',
              ),
            ].sublist(
              0,
              Provider.of<UserProvider>(context, listen: false).isAdmin ? 4 : 3,
            ),
          )),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder(
            stream: supabase.from("Volunteer").stream(primaryKey: ['id']).gt(
                "Time", DateTime.now().toIso8601String()),
            initialData: const [],
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text('Error');
              }
              if (!snapshot.hasData) {
                return const Text('No data');
              }
              return ListView(
                children: [
                  for (Map<String, dynamic> querySnapshot in snapshot.data)
                    if (querySnapshot["Participants"]
                        .contains(supabase.auth.currentUser!.id))
                      VolunteerListTitle(querySnapshot: querySnapshot),
                ],
              );
            },
          ),
          StreamBuilder(
            stream: supabase.from("Volunteer").stream(primaryKey: ['id']).lt(
                "Time", DateTime.now().toIso8601String()),
            initialData: const [],
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text('Error');
              }
              if (!snapshot.hasData) {
                return const Text('No data');
              }
              return ListView(
                children: [
                  for (Map<String, dynamic> querySnapshot in snapshot.data)
                    if (querySnapshot["Completed"]
                        .contains(supabase.auth.currentUser!.id))
                      VolunteerListTitle(querySnapshot: querySnapshot),
                ],
              );
            },
          ),
          StreamBuilder(
            stream: supabase
                .from('SCIE-Students')
                .stream(
                  primaryKey: ['id'],
                )
                .eq("id", supabase.auth.currentUser!.id)
                .map((event) => event.isNotEmpty ? event.first : {}),
            initialData: const {},
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return const Text('No data');
              }
              final starredList =
                  snapshot.data['starred'] as List<dynamic>? ?? [];
              return ListView(
                children: [
                  for (String docId in starredList)
                    StarredCard(
                      docId: docId,
                      key: UniqueKey(),
                    ),
                ],
              );
            },
          ),
          StreamBuilder(
            stream: supabase
                .from('Volunteer')
                .stream(
                  primaryKey: ['id'],
                )
                .eq("CreatorUid", supabase.auth.currentUser!.id)
                .map((event) => event.isNotEmpty ? event : []),
            initialData: const [],
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text('Error');
              }
              if (!snapshot.hasData) {
                return const Text('No data');
              }
              return ListView(
                children: [
                  for (Map<String, dynamic> querySnapshot in snapshot.data)
                    CreatedCard(data: querySnapshot),
                ],
              );
            },
          ),
        ].sublist(
          0,
          Provider.of<UserProvider>(context, listen: false).isAdmin ? 4 : 3,
        ),
      ),
      bottomNavigationBar: const GlobalAppBar(pageName: "event"),
    );
  }
}

class CreatedCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const CreatedCard({super.key, required this.data});

  @override
  State<CreatedCard> createState() => _CreatedCardState();
}

class _CreatedCardState extends State<CreatedCard> {
  final ValueNotifier<bool> starred = ValueNotifier(false);

  @override
  void initState() {
    initStar();
    super.initState();
  }

  void initStar() async {
    starred.value = await ifStarred(widget.data["id"]);
  }

  @override
  Widget build(BuildContext context) {
    bool afterNow = DateTime.parse(widget.data['Time'])
        .isAfter(DateTime.now()); //////////modified, isNotAfterNow
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => volunteerInfoScreen(
              event: widget.data,
              starredNotifier: starred,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color.fromARGB(255, 219, 241, 221), // Border color
            width: 1.5, // Border width
          ),
          borderRadius: BorderRadius.circular(25.0), // Optional: border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(widget.data['EventName']),
              Paragraph(widget.data["CsHours"].toString() +
                  " cs hours, " +
                  DateFormat("MM/dd hh:mm")
                      .format(DateTime.parse(widget.data["Time"]))
                      .toString() +
                  ", " +
                  widget.data["Kind"].toString()),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: afterNow
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Colors.grey,
                          ),
                          onPressed: () {
                            if (afterNow) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => approvePage(
                                      data: widget.data,
                                    ),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "The event hasn't finished yet")));
                            }
                          },
                          child: afterNow
                              ? const Text("Approve Students")
                              : const Text(
                                  "Not yet finished",
                                  style: TextStyle(color: Colors.black),
                                )))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StarredCard extends StatefulWidget {
  final String docId;
  const StarredCard({super.key, required this.docId});

  @override
  State<StarredCard> createState() => _StarredCardState();
}

class _StarredCardState extends State<StarredCard> {
  Map<String, dynamic>? event;

  @override
  void initState() {
    super.initState();
    getEvent();
  }

  Future<void> getEvent() async {
    event = await getVolunteerEvent(widget.docId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return event == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : VolunteerListTitle(
            icon: Icons.delete,
            querySnapshot: event!,
          );
  }
}
