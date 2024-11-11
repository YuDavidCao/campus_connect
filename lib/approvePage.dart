import 'package:flutter/material.dart';
import 'package:campus_connect/db.dart';

class approvePage extends StatefulWidget {
  final Map<String,dynamic> data;
  const approvePage({super.key, required this.data});

  @override
  State<approvePage> createState() => _approvePageState();
}

class _approvePageState extends State<approvePage> {
  late final List<bool> approved;

  @override
  void initState() {
    approved = List.generate(
        widget.data['Participants'].length, (index) => false);
    for (int i = 0; i < widget.data["Participants"].length; i++) {
      if (widget.data["Completed"]
          .contains(widget.data["Participants"][i])) {
        approved[i] = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            bool confirmQuit = false;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Are you sure you want to quit?'),
                    content: const Text('Changes will not be saved.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          confirmQuit = true;
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                });
            if (confirmQuit && context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Approve students'),
      ),
      body: ListView(children: [
        if (widget.data['Participants'].isEmpty)
          const Center(child: Text('No participants')),
        for (int i = 0; i < widget.data['Participants'].length; i++)
          StudentCard(
            uid: widget.data['Participants'][i],
            approved: approved,
            index: i,
          ),
        if (widget.data['Participants'].isNotEmpty)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            onPressed: () {
              recordApproveStudent(
                  approved,
                  widget.data["Participants"],
                  widget.data["id"]);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
      ]),
    );
  }
}

class StudentCard extends StatefulWidget {
  final int index;
  final List<bool> approved;
  final String uid;
  const StudentCard(
      {super.key,
      required this.uid,
      required this.approved,
      required this.index});

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map?>(
      future: getStudentInfo(widget.uid),
      builder:
          (BuildContext context, AsyncSnapshot<Map?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          //////////////does not safisfy/////////////////////////////////////////////////
          return Card(
            child: CheckboxListTile(
              title: Text(snapshot.data!["username"]),
              subtitle: Text(snapshot.data!["email"]),
              checkColor: Colors.white,
              value: widget.approved[widget.index],
              onChanged: (bool? value) {
                setState(() {
                  widget.approved[widget.index] = value ?? false;
                });
              },
            ),
          );
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
    );
  }
}
