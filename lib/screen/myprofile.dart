import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http_parser/http_parser.dart';
import 'package:hy_application/screen/myupload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/login.dart';
import '../mastercolor.dart';
import 'details/details_screen.dart';
import 'widgets/customtextfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();

    getuserid();
  }

  String? username;
  String? user_id;
  var userdata;
  late List<dynamic> mybookmark;
  late List<dynamic> mylikes;

  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final mobile_controller = TextEditingController();
  final home_towwcontroller = TextEditingController();
  final occupation_controller = TextEditingController();
  final intrest_in_controller = TextEditingController();
  final University_controller = TextEditingController();
  final Linkedin_controller = TextEditingController();
  final aboutmr_controller = TextEditingController();

  File? uploadimage;

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String qid = prefs.getString('password').toString();
    var is_login = prefs.getString('user_name');
    setState(() {
      username = is_login;
      user_id = prefs.getString('user_id');
    });
    String BASE_URL =
        "${GlobalConfiguration().getValue('api_base_url')}/users/$user_id";
    Dio dio = Dio();
    try {
      var response = await dio.get(BASE_URL);

      setState(() {
        userdata = response.data["data"];
        mybookmark = response.data["bookmarks"];
        name_controller.text = userdata['name'];
        mobile_controller.text = userdata['mobile_number'];
        occupation_controller.text = userdata['occupation'];
        University_controller.text = userdata['university'];
        intrest_in_controller.text = userdata['interest'];
        Linkedin_controller.text = userdata['linkedin'];
        aboutmr_controller.text = userdata['aboutme'];
        email_controller.text = userdata["email"];

        mylikes = response.data["likes"];
      });
    } on DioError {
      //print(e);
      print("No  recent");
    }
  }

  updatemyprofile() async {
    final service = LoginApi();
    Map<String, dynamic> param = {
      "id": user_id,
      "name": name_controller.text,
      "email": email_controller.text,
      "mobile_number": mobile_controller.text,
      "occupation": occupation_controller.text,
      "university": University_controller.text,
      "interest": intrest_in_controller.text,
      "linkedin": Linkedin_controller.text,
      "aboutme": aboutmr_controller.text,
    };
    service.changemyprofile(param).then((value) {
      if (value.status == '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green[200],
              content: Text(" suceessfully updated")),
        );
        getuserid();
      }
    });
  }

  Future<dynamic> updateprofile(File image) async {
    var uri = Uri.parse(
        "${GlobalConfiguration().getValue('api_base_url')}/UserProfile");
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', uri);

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    imageUploadRequest.fields.addAll({
      "user_id": user_id.toString(),
    });

    // add headers if needed
    //imageUploadRequest.headers.addAll(<some-headers>);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        getuserid();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green[100],
              content: Text(" suceessfully uploaded")),
        );
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void chooseImage() async {
    uploadimage = File(await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile!.path));
    setState(() {
      uploadimage = uploadimage as File?;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Preview Profile Image"),
        content: Container(
            child: Image.file(
          uploadimage!,
          width: 300.0,
          height: 2000.0,
          fit: BoxFit.fitHeight,
        )),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      updateprofile(uploadimage!);
                    },
                    child: Text("Update profile"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget circavtar() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(userdata["profile_imge"] != ""
                ? "${GlobalConfiguration().getValue('user_profile') + userdata['profile_imge']}"
                : "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
          ),
          Positioned(
              bottom: -5,
              right: -35,
              child: RawMaterialButton(
                onPressed: () {
                  chooseImage();
                },
                elevation: 2.0,
                fillColor: Color(0xFFF5F6F9),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.blue,
                ),
                padding: EdgeInsets.all(8.0),
                shape: CircleBorder(),
              )),
        ],
      ),
    );
  }

  Widget makecard(String title, IconData Iconsfor, String value) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.3, color: Colors.white)),
      height: 45,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Iconsfor),
            Text(
              title + " :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(value),
          ],
        ),
      ),
    );
  }

  Widget makeCardforlist(String title, String created_at, String pdfdata,
      Map data, String cardfor) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTile(title, created_at, pdfdata, data, cardfor),
      ),
    );
  }

  Widget makeListTile(
      String title, String created_at, pdfdata, Map data, String cardfor) {
    return InkWell(
      onDoubleTap: data["created_by"] == user_id
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyUpload(data['id'].toString())),
              );
            }
          : () {},
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(data)),
        );
      },
      child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: IconButton(
              onPressed: () async {
                String url =
                    'https://graduateresearchproject.com/upload/${pdfdata}';
                if (await launch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              icon: Icon(Icons.download, color: Colors.black),

              //
            ),
          ),
          title: Text(
            title,
            style: TextStyle(color: defaultcolor, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Icon(Icons.linear_scale, color: defaultcolor),
              Text(created_at, style: TextStyle(color: Colors.black))
            ],
          ),
          trailing: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Are you sure want to delete ?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          Dio dio = Dio();
                          String BASE_URL = cardfor == 'upload'
                              ? "${GlobalConfiguration().getValue('api_base_url')}/deleteitem/${data['id']}"
                              : "${GlobalConfiguration().getValue('api_base_url')}/deleteitem/${data['id']}/$user_id";

                          try {
                            var response = await dio.get(BASE_URL);
                            final dataresponse = response.data;
                            print(BASE_URL);

                            if (dataresponse['status'] == '1') {
                              getuserid();
                              Navigator.of(ctx).pop();
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.green[100],
                                    content: Text(" suceessfully Deleted")),
                              );
                            }
                          } on DioError {
                            //print(e);
                            print(Future.error("No  recent"));
                          }
                        },
                        child: Container(
                          color: homeheadercolor,
                          padding: const EdgeInsets.all(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Text("Yes",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.all(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(Icons.delete, color: Colors.black, size: 30.0))),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: userdata == null
          ? Center(
              child: CircularProgressIndicator(
              color: defaultcolor,
            ))
          : DefaultTabController(
              length: 4,
              child: Column(
                children: <Widget>[
                  // construct the profile details widget here

                  // the tab bar with two items
                  SizedBox(
                    height: 220,
                    child: AppBar(
                      toolbarHeight: 220,
                      title: Center(
                        child: Column(
                          children: [
                            circavtar(),
                            Text(
                              userdata['name']!,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                      backgroundColor: defaultcolor,
                      bottom: TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.yellow,
                        indicatorWeight: 5.0,
                        tabs: [
                          Tab(
                            child: Column(children: <Widget>[
                              Icon(Icons.account_box_rounded),
                              Text("Account")
                            ]),
                          ),
                          Tab(
                            child: Column(children: <Widget>[
                              Icon(Icons.bookmark),
                              Text("My Bookmark")
                            ]),
                          ),
                          Tab(
                            child: Column(children: <Widget>[
                              Icon(Icons.upload),
                              Text("My Upload")
                            ]),
                          ),
                          Tab(
                            child: Column(children: <Widget>[
                              Icon(Icons.account_box_rounded),
                              Text("Account Details")
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // create widgets for each tab bar here
                  Expanded(
                    child: TabBarView(
                      children: [
                        // first tab bar view widget

                        // second tab bar viiew widget
                        Card(
                            child: Container(
                          child: Column(children: [
                            Container(
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: const Offset(
                                          1.0,
                                          1.0,
                                        ),
                                        blurRadius: 2.0,
                                      ),
                                    ],
                                    color: Colors.grey[100],
                                    border: Border.all(
                                        width: 0.3, color: Colors.blueGrey)),
                                height: 35,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    " Basic Info",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            makecard("Hometown", Icons.location_city_outlined,
                                userdata['home_town']),
                            makecard("Ocupation", Icons.cast_for_education,
                                userdata['occupation']),
                            makecard("University", Icons.school,
                                userdata['university']),
                            makecard("Intrest In", Icons.interests,
                                userdata['interest']),
                            makecard("Email", Icons.email, userdata['email']),
                          ]),
                        )),
                        mybookmark == null
                            ? Text(" No bookmarks ")
                            : ListView.builder(
                                itemCount: mybookmark.length,
                                itemBuilder: (context, i) {
                                  return makeCardforlist(
                                      mybookmark[i]["title"],
                                      mybookmark[i]["created_at"],
                                      mybookmark[i]["upload_pdf"],
                                      mybookmark[i],
                                      'bookmarl');
                                },
                              ),
                        mylikes == null
                            ? Text("No likes item found")
                            : ListView.builder(
                                itemCount: mylikes.length,
                                itemBuilder: (context, i) {
                                  return makeCardforlist(
                                      mylikes[i]["title"],
                                      mylikes[i]["created_at"],
                                      mylikes[i]["upload_pdf"],
                                      mylikes[i],
                                      'upload');
                                },
                              ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: ListView(
                            children: [
                              CustomTextField(name_controller, "User Name"),
                              CustomTextField(mobile_controller, "User Mobile"),
                              CustomTextField(email_controller, "Email "),
                              CustomTextField(
                                  occupation_controller, "Occupation"),
                              CustomTextField(
                                  University_controller, "University"),
                              CustomTextField(
                                  intrest_in_controller, "Interest In "),
                              CustomTextField(
                                  Linkedin_controller, "Linkedin Id"),
                              CustomTextField(
                                aboutmr_controller,
                                "About Me",
                                maxliness: 5,
                              ),
                              Container(
                                color: defaultcolor,
                                child: TextButton(
                                    onPressed: () {
                                      updatemyprofile();
                                    },
                                    child: Text(
                                      " Save Changes",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
