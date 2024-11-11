import 'package:campus_connect/homescreen.dart';
import 'package:campus_connect/myEventsPage.dart';
import 'package:campus_connect/profilePage.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget {
  final String pageName;
  const GlobalAppBar({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.inversePrimary,
      height: 84,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
              onPressed: () {
                if (pageName != "home") {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const homescreen(),
                          transitionDuration: const Duration(milliseconds: 400),
                          reverseTransitionDuration:
                              const Duration(milliseconds: 400)));
                }
              },
              label: const SizedBox.shrink(),
              icon: Column(
                children: [
                  Icon(
                    Icons.home,
                    size: pageName == "home" ? 23 : 20,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(fontSize: pageName == "home" ? 15 : 13),
                  ),
                ],
              )),
          TextButton.icon(
              onPressed: () {
                if (pageName != "event") {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const myEventsPage(),
                          transitionDuration: const Duration(milliseconds: 400),
                          reverseTransitionDuration:
                              const Duration(milliseconds: 400)));
                }
              },
              label: const SizedBox.shrink(),
              icon: Column(
                children: [
                  Icon(
                    Icons.event,
                    size: pageName == "event" ? 23 : 20,
                  ),
                  Text(
                    "Events",
                    style: TextStyle(fontSize: pageName == "event" ? 15 : 13),
                  ),
                ],
              )),
          TextButton.icon(
              onPressed: () {
                if (pageName != "profile") {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const profilePage(),
                          transitionDuration: const Duration(milliseconds: 400),
                          reverseTransitionDuration:
                              const Duration(milliseconds: 400)));
                }
              },
              label: const SizedBox.shrink(),
              icon: Column(
                children: [
                  Icon(
                    Icons.person,
                    size: pageName == "profile" ? 23 : 20,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: pageName == "profile" ? 15 : 13),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
