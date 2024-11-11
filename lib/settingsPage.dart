import 'package:flutter/material.dart';
import 'package:campus_connect/RegisterPage.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/userProvider.dart';
import 'package:campus_connect/themeProvider.dart';
import 'db.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({super.key});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark mode'),
              trailing: Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                          .themeMode ==
                      ThemeMode.dark,
                  onChanged: (val) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(val);
                  }),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title:
                              const Text("Are you sure you want to log out?"),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text(
                                "Confirm",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const RegisterPage()));
                              },
                            ),
                            ElevatedButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ]);
                    });
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete account'),
              onTap: () async {
                bool confirm = false;
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text(
                              "Are you sure you want to delete your account?"),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text(
                                "Confirm",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                confirm = true;
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ]);
                    });
                if (confirm) {
                  bool success = await deleteAccount();
                  if (context.mounted) {
                    if (success) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Failed to delete account')));
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
