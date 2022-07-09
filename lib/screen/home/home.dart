import 'package:flutter/material.dart';
import 'package:leave_flutter/screen/leave/approve.dart';
import 'package:leave_flutter/screen/leave/post_leave.dart';
import 'package:leave_flutter/screen/leave/view_leave.dart';
import 'package:leave_flutter/screen/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveScreen extends StatefulWidget {
  LeaveScreen({Key? key}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  String token = "";
  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    //yesma aagi ko token sharedpref bata
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("tokenString")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Form"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                  radius: MediaQuery.of(context).size.width * .20,
                  backgroundColor: Colors.white,
                  child: Image.network(
                    "https://www.jeancoutu.com/globalassets/revamp/photo/conseils-photo/20160302-01-reseaux-sociaux-profil/photo-profil_301783868.jpg",
                    fit: BoxFit.fitHeight,
                  )),
              const Text(
                'Full Name: Rajesh Maharjan',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email : rajesh@gmail.com',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Phone : 9881233182',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Status : approved',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () => {},
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Attendance',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () => {},
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'QR attend',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApprovedScreen()))
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Approve Leave',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LeavePost()));
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Request Leave',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewLeaveScreen()))
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'View Leave',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Spacer(
                      flex: 2,
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
