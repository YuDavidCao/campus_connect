import 'package:flutter/material.dart';
import 'constants.dart';

import 'db.dart';

class editProfilePage extends StatefulWidget {
  const editProfilePage({super.key});

  @override
  State<editProfilePage> createState() => _editProfilePageState();
}

class _editProfilePageState extends State<editProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController chineseNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    initInfo();
    super.initState();
  }

  void initInfo() async {
    await getUserInfo().then((Map<String, dynamic>? data) {
      if (data != null) {
        setState(() {
          usernameController.text = data['username'];
          chineseNameController.text = data['chineseName'];
          emailController.text = data['email'];
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    chineseNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Edit profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///little camera button
            TextFormField(
              controller: usernameController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Real Name(English)',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: chineseNameController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Real Name(Chinese)',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (!emailRegex.hasMatch(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter a valid email")));
                  return;
                }
                await setUserInfo({
                  'email': emailController.text,
                  'username': usernameController.text,
                  'chineseName': chineseNameController.text,
                });
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
