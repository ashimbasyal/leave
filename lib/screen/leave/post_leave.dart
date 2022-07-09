import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class LeavePost extends StatefulWidget {
  LeavePost({Key? key}) : super(key: key);

  @override
  State<LeavePost> createState() => _LeavePostState();
}

class _LeavePostState extends State<LeavePost> {
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCred();
  }

  void _getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("tokenString")!;
    });
  }

  //image ko lagi

  File? image;
  final _picker = ImagePicker();
  bool showloading = false;

  //aaba pick garna ko lagi
  Future getImage() async {
    final PickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (PickedFile != null) {
      image = File(PickedFile.path);
      setState(() {});
    } else {
      print("No image selected");
    }
  }

  //upload image

  Future<void> uploadImage() async {
    setState(() {
      showloading = true;
    });

    var stream = http.ByteStream(image!.openRead());

    var length = await image!.length();
    var uri = Uri.parse('http://api.ssgroupm.com/Api/Leave/RequestLeave');

    var request = http.MultipartRequest("POST", (uri));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };

    request.fields['Id'] = id.text;
    request.fields['LeaveDate'] = leavedate.text;
    request.fields['LeaveFor'] = leavefor.text;
    request.fields['Description'] = description.text;
    request.fields['Status'] = status.text;
    request.fields['RequestedBy'] = requestedBy.text;
    request.fields['SignatureImagePath'] = signatureImagePath.text;

    var multiport = http.MultipartFile('Signature', stream, length,
        filename: basename(image!.path));

    request.files.add(multiport);
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        showloading = false;
      });
      print("Image uploaded");
    } else {
      setState(() {
        showloading = false;
      });
      print('Failed');
    }
  }

  TextEditingController id = TextEditingController();
  TextEditingController leavedate = TextEditingController();
  TextEditingController leavefor = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController requestedBy = TextEditingController();
  TextEditingController signatureImagePath = TextEditingController();
  TextEditingController signature = TextEditingController();

  DateTime date = DateTime(2022, 06, 24);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showloading,
      child: Scaffold(
        appBar: AppBar(title: const Text("Leave Form")),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Container(
                    child: Column(
                      children: [
                        TextField(
                          controller: leavedate,
                          decoration: const InputDecoration(
                              icon: Icon(
                                  Icons.calendar_month), 
                              ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickdate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2050));
                            if (pickdate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickdate);
                              print(
                                  formattedDate); 
                              setState(() {
                                leavedate.text =
                                    formattedDate; 
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000));

                            if (newDate == null) return;
                            setState(() {
                              date = newDate;
                            });
                          },
                          child: Text("Select Date"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: id,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Id",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: leavefor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Leave For",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: description,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Description",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: status,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Status",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: requestedBy,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Requested By",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: signatureImagePath,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Signature Path",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[100],
                          child: InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                                child: image == null
                                    ? Center(
                                        child: Text("Image of Signature"),
                                      )
                                    : Container(
                                        child: Center(
                                            child: Image.file(
                                          File(image!.path).absolute,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        )),
                                      )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      leavedate.text;
                      leavefor.text;
                      signature.toString();

                      uploadImage();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Sucessful Posted"),
                          backgroundColor: Colors.green));
                      Navigator.pop(context);
                    },
                    child: const Text("Post"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
