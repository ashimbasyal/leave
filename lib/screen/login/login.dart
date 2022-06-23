import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leave_flutter/screen/leave/leave.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            const Text(
              "Login Form",
              style: TextStyle(fontSize: 70),
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Username",
                      enabledBorder: OutlineInputBorder()),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Password",
                      enabledBorder: OutlineInputBorder()),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: () {
                  login();
                },
                icon: const Icon(Icons.login),
                label: const Text("Login"))
          ],
        ),
      ),
    );
  }


  Future login() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse('http://api.ssgroupm.com/Api/Auth/Authenticate'),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          },
          body: jsonEncode({
            'username': usernameController.text,
            'password': passwordController.text
          }));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Login Token: " + body['tokenString']);
     
        //Hamle token sharedpreference ma store gardai xam

        //
        //
        pageRoute(body['tokenString']);

        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
              content: Text("Sucessful Login"), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Wrong Password"), backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Password")));
    }
  }

  void pageRoute(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("tokenString", token);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeaveScreen()));
  }
}
