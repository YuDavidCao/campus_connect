import 'package:campus_connect/LoginPage.dart';
import 'package:campus_connect/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/userProvider.dart';
import 'package:flutter/material.dart';
import 'db.dart';
import 'constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String englishName = '';
  String chineseName = '';
  int studentNumber = 0;
  String email = '';
  String password = '';
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: const Text('Register page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Real Name(English)'),
              onChanged: (String newEntry) {
                englishName = newEntry;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Real Name(Chinese)'),
              onChanged: (String newEntry) {
                chineseName = newEntry;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Student number:'),
              onChanged: (String newEntry) {
                studentNumber = int.parse(newEntry);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
              onChanged: (String newEntry) {
                email = newEntry;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              onChanged: (String newEntry) {
                password = newEntry;
              },
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Re-input Password'),
              onChanged: (String newEntry) {
                password2 = newEntry;
              },
            ),
            TextButton(
              child: const Text("Already have an account?"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (studentNumber.toString().length != 5) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(
                                  "Student number has to be 5 digits"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                    return;
                  }
                  if (!emailRegex.hasMatch(email)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Please enter a valid email"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                    return;
                  }
                  if (password.length < 6 || password2.length < 6) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(
                                  "Password has to be more than 6 characters"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                    return;
                  }
                  bool studentNumberUnique =
                      await ifStudentNumberUnique(studentNumber.toString());
                  if (!studentNumberUnique && context.mounted) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title:
                                  const Text("Student number already exists"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                    return;
                  }
                  if (password != password2 && context.mounted) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Your password don't match!"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                    return;
                  }
                  bool succeeded =
                      await Provider.of<UserProvider>(context, listen: false)
                          .signUp(
                              email: email,
                              password: password,
                              englishName: englishName,
                              chineseName: chineseName,
                              studentNumber: studentNumber,
                              context: context);
                  if (succeeded) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homescreen()));
                  }
                },
                child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
