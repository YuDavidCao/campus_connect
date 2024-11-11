import 'dart:ui';

import 'package:campus_connect/db.dart';
import 'package:campus_connect/editProfilePage.dart';
import 'package:campus_connect/messagePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:campus_connect/myEventsPage.dart';
import 'package:campus_connect/settingsPage.dart';
import 'package:campus_connect/userProvider.dart';
import 'package:campus_connect/globalAppBar.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/homescreen.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String email = "";
  String uid = "";
  String username = "";
  String chineseName = "";
  String imageUrl = "";
  double csHours = 0;
  int studentNumber = 0;

  String image = "";

  Future<void> grabUserData() async {
    getUserInfo().then((info) {
      if (info == null) {
        return;
      }
      email = info["email"];
      username = info["username"];
      chineseName = info["chineseName"];
      csHours = info["CsHours"].toDouble();
      studentNumber = info["studentNumber"];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    grabUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  "$username $chineseName ${studentNumber.toString()}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  email,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ))
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            ////////alignment: Alignment.centerRight,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const editProfilePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 15,
              runSpacing: 20,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const myEventsPage(
                                    tabIndex: 2,
                                  )));
                    },
                    icon: const Column(
                      children: <Widget>[
                        Icon(Icons.star),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Starred'),
                      ],
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const messagePage(),
                        ),
                      );
                    },
                    icon: const Column(
                      children: <Widget>[
                        Icon(Icons.message),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Message'),
                      ],
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const homescreen(),
                        ),
                      );
                    },
                    icon: const Column(
                      children: <Widget>[
                        Icon(Icons.handshake),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Volunteers'),
                      ],
                    )),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const settingsPage(),
                      ),
                    );
                  },
                  icon: const Column(
                    children: <Widget>[
                      Icon(Icons.settings),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Settings'),
                    ],
                  ),
                ),
                Provider.of<UserProvider>(context, listen: false).isAdmin
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => myEventsPage(
                                        tabIndex: 3,
                                      )));
                        },
                        icon: const Column(
                          children: <Widget>[
                            Icon(Icons.construction),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Created'),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GlobalAppBar(pageName: "profile"),
    );
  }
}
