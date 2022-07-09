import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leave_flutter/model/leave_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewLeaveScreen extends StatefulWidget {
  ViewLeaveScreen({Key? key}) : super(key: key);

  @override
  State<ViewLeaveScreen> createState() => _ViewLeaveScreenState();
}

class _ViewLeaveScreenState extends State<ViewLeaveScreen> {
  String token = "";
  @override
  void initState() {
    super.initState();
    _getCred();
    futuredata = fetchData();
  }

  void _getCred() async {
    //yesma aagi ko token sharedpref bata
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("tokenString")!;
    });
  }

  Future<List<LeaveModel>>? futuredata;
  Future<List<LeaveModel>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://api.ssgroupm.com/Api/Leave/GetLeave'), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse[1]['description']);

      return jsonResponse.map((data) => LeaveModel.fromJson(data)).toList();
      // List<dynamic> parsed =
      //     json.decode(response.body).cast<Map<String, dynamic>>();

      // list = parsed.map((json) => LeaveModel.fromJson(json)).toList();
      // print(parsed);
      // return list;
    } else {
      throw Exception('failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("View User Leave")),
        body: SafeArea(
            child: Container(
                child: FutureBuilder<List<LeaveModel>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? DataTable(
                              columns:const [
                                DataColumn(label: Text(' Leave Date')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Description')),
                              ],
                              rows: List.generate(snapshot.data!.length, (i) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                        snapshot.data![i].leaveDate ?? "")),
                                    DataCell(
                                        Text(snapshot.data?[i].status ?? "")),
                                    DataCell(Text(
                                        snapshot.data?[i].description ?? "")),
                                  ],
                                );
                              }),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            );
                    }))));
  }
}
