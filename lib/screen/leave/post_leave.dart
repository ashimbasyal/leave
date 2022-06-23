import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leave_flutter/model/leave_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    //yesma aagi ko token sharedpref bata
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
    stream.cast();

    var length = await image!.length();
    var uri = Uri.parse(
      "http://api.ssgroupm.com/Api/Leave/RequestLeave",
    );

    var request = http.MultipartRequest("POST", (uri));

    request.fields['LeaveDate'];

    var multiport = http.MultipartFile('Signature', stream, length);

    request.files.add(multiport);

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

  late Leave _leave;

  TextEditingController LeaveDate = TextEditingController();
  TextEditingController LeaveFor = TextEditingController();
  TextEditingController Signature = TextEditingController();

  //FOR SEND DATA

  Future<Leave> post(
      String LeaveDate, String LeaveFor, String Signature) async {
    var response = await http.post(
        Uri.parse('http://api.ssgroupm.com/Api/Leave/RequestLeave'),
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
        body: {
          "LeaveDate": LeaveDate,
          "LeaveFor": LeaveFor,
          "Signature": Signature
        });

    var data = response.body;
    print('data');

    if (response.statusCode == 200) {
      String responsestring = response.body;
      leaveFromJson(responsestring);
    }
    return Leave(
        leaveDate: LeaveDate, leaveFor: LeaveFor, signature: Signature);
  }

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
                        TextFormField(
                          controller: LeaveDate,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Leave Date",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: LeaveFor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Leave For",
                              enabledBorder: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                              child: image == null
                                  ? Center(
                                      child: Text("Picked Image"),
                                    )
                                  : Container(
                                      child: Center(
                                          child: Image.file(
                                        File(image!.path).absolute,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )),
                                    )),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              uploadImage();
                            },
                            child: Text("uploadimage"))
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      String ldate = LeaveDate.text;
                      String lfor = LeaveFor.text;
                      String lsign = Signature.text;

                      Leave data = await post(ldate, lfor, lsign);

                      setState(() {
                        _leave = data;
                      });
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
