import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leave_flutter/model/leave_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApprovedScreen extends StatefulWidget {
  ApprovedScreen({Key? key}) : super(key: key);

  @override
  State<ApprovedScreen> createState() => _ApprovedScreenState();
}

class _ApprovedScreenState extends State<ApprovedScreen> {
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

  //api ko lagi
  Future<List<LeaveModel>>? futuregetdata;
  Future<List<LeaveModel>> fetchData() async {
    final response = await http.get(
        Uri.parse('http://api.ssgroupm.com/Api/Leave/GetLeaveForAdmin'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse[1]['description']);

      return jsonResponse.map((data) => LeaveModel.fromJson(data)).toList();
    } else {
      throw Exception('failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("View User Leave")),
        body: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
              child: FutureBuilder<List<LeaveModel>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? DataTable(
                            columns: const [
                              DataColumn(label: Text(' Leave Date')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Accept')),
                              DataColumn(label: Text('Reject')),
                            ],
                            rows: List.generate(snapshot.data!.length, (i) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                      Text(snapshot.data![i].leaveDate ?? "")),
                                  DataCell(
                                      Text(snapshot.data?[i].status ?? "")),
                                  DataCell(Text(
                                      snapshot.data?[i].description ?? "")),
                                  DataCell(ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Accept'),
                                  )),
                                  DataCell(ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Reject'),
                                  ))
                                ],
                              );
                            }),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          );
                  })),
        )));
  }
}
