import 'package:campus_connect/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/userProvider.dart';
import 'package:campus_connect/homescreen.dart';
import 'package:campus_connect/messageProvider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              obscureText: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
              onChanged: (String newEntry) {
                print("Email is changed $newEntry");
                email = newEntry;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              onChanged: (String newEntry) {
                print("Password is changed $newEntry");
                password = newEntry;
              },
            ),
            TextButton(
              child: const Text("Forgot password?"),
              onPressed: () async {
                //TODO
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (!emailRegex.hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter a valid email address")));
                  return;
                }
                bool authenticated = await Provider.of<UserProvider>(context,
                        listen: false)
                    .signIn(email: email, password: password, context: context);
                if (authenticated != true) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Your email or password is invalid!"),
                            actions: <Widget>[
                              TextButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ]);
                      });
                } else {
                  Provider.of<MessageProvider>(context, listen: false)
                      .startListening();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const homescreen(),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
