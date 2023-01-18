import 'dart:convert';
import 'dart:io';
import 'package:getwidget/getwidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http_parser/http_parser.dart';
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

class UserProfile extends StatefulWidget {
  String user_id;
  UserProfile(this.user_id);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();

    getuserid();
  }

  String? username;

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
    String BASE_URL =
        "${GlobalConfiguration().getValue('api_base_url')}/users/${widget.user_id}";
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
            title == 'Social'
                ? InkWell(
                    onTap: () async {
                      String url = userdata['linkedin'];
                      if (await launch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset("images/linkedinicon.png"))
                : Text(value),
          ],
        ),
      ),
    );
  }

  Widget makeCardforlist(
      String title, String created_at, String pdfdata, Map data) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTile(title, created_at, pdfdata, data),
      ),
    );
  }

  Widget makeListTile(String title, String description, pdfdata, Map data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(data)),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Image.network(
          "${GlobalConfiguration().getValue('upload_image') + data['front_image']}",
          height: 150,
          width: 60,
        ),
        title: Text(
          title,
          style: TextStyle(color: defaultcolor, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Text(description),
      ),
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
              length: 3,
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
                              Text("Basic Info")
                            ]),
                          ),
                          Tab(
                            child: Column(children: <Widget>[
                              Icon(Icons.bookmark),
                              Text("About Me")
                            ]),
                          ),
                          Tab(
                            child: Column(children: <Widget>[
                              Icon(Icons.upload),
                              Text("My POst")
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
                            makecard("Social", Icons.social_distance,
                                userdata['email']),
                          ]),
                        )),
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
                                    "About Me",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(userdata['aboutme']),
                            )
                          ]),
                        )),

                        mylikes == null
                            ? Text("No likes item found")
                            : ListView.builder(
                                itemCount: mylikes.length,
                                itemBuilder: (context, i) {
                                  return makeCardforlist(
                                      mylikes[i]["title"],
                                      mylikes[i]["Description"]
                                          .substring(1, 40),
                                      mylikes[i]["upload_pdf"],
                                      mylikes[i]);
                                },
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
