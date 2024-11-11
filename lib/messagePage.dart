import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/messageProvider.dart';
import 'package:intl/intl.dart';
import 'package:campus_connect/volunteerInfoScreen.dart';
import "db.dart";

class messagePage extends StatefulWidget {
  const messagePage({super.key});

  @override
  State<messagePage> createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Messages"),
      ),
      body: Consumer<MessageProvider>(
        builder: (context, MessageProvider messageProvider, child) {
          return messageProvider.messages.isEmpty
              ? Center(
                  child: Text("No messages"),
                )
              : ListView.builder(
                  itemCount: messageProvider.messages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () async {
                          Map<String, dynamic>? event = await getVolunteerEvent(
                              messageProvider.messages[index]["docId"]);
                          if (event == null) return;
                          bool value = await ifStarred(event["id"]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => volunteerInfoScreen(
                                        event: event,
                                        starredNotifier: ValueNotifier(value),
                                      )));
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              messageProvider.messages[index]["text"],
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                                DateFormat("MM/dd hh:mm")
                                    .format(DateTime.parse(messageProvider
                                        .messages[index]["time"]))
                                    .toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ));
                  },
                );
        },
      ),
    );
  }
}
