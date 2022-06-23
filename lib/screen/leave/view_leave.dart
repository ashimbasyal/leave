import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewLeaveScreen extends StatefulWidget {
  ViewLeaveScreen({Key? key}) : super(key: key);

  @override
  State<ViewLeaveScreen> createState() => _ViewLeaveScreenState();
}

class _ViewLeaveScreenState extends State<ViewLeaveScreen> {
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCred();
  }

  void _getCred() async {
    //yesma aagi ko token sharedpref bata
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("tokenString")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View User Leave")),
    );
  }
}
