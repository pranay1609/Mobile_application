import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hy_application/controller/item.dart';
import 'package:hy_application/screen/widgets/bottomnavigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/bookmarkcontroller.dart';
import '../mastercolor.dart';
import 'customsearch.dart';
import 'departmenwiseproject.dart';
import 'details/details_screen.dart';
import 'myupload.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final homeservice = Items();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final bookmarkservice = BookMarkApi();
  final TextEditingController serach_controller = TextEditingController();

  int is_active = 1;
  String? userid;
  @override
  void initState() {
    super.initState();

    getuserid();
  }

  addbookmarksandlike(
    String ebbok_id,
    String type_id,
  ) {
    bookmarkservice.addedbookmark({
      "ebook_id": ebbok_id,
      "type_id": type_id,
      "user_id": userid,
    }).then((value) {
      Fluttertoast.showToast(
          msg: value.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {});
    });
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String qid = prefs.getString('password').toString();
    var is_login = prefs.getString('user_id');
    setState(() {
      userid = is_login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationCustom(),
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 3,
        backgroundColor: homeheadercolor,
        child: ListView(
          children: [
            new SizedBox(
              height: 120.0,
              child: new DrawerHeader(
                  child: Center(
                    child: CircleAvatar(
                      radius: 20,
                    ),
                  ),
                  decoration: new BoxDecoration(color: defaultcolor),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero),
            ),
            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: defaultcolor,
                  ),
                  title: Text(
                    " Home ",
                    style: TextStyle(
                        color: defaultcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyUpload("")),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.upload,
                    color: defaultcolor,
                  ),
                  title: Text(
                    " Upload ",
                    style: TextStyle(
                        color: defaultcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              child: ListTile(
                leading: Icon(
                  Icons.contact_phone,
                  color: defaultcolor,
                ),
                title: Text(
                  " Contact us ",
                  style: TextStyle(
                      color: defaultcolor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/myprofile',
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.supervised_user_circle_rounded,
                    color: defaultcolor,
                  ),
                  title: Text(
                    " My Profile ",
                    style: TextStyle(
                        color: defaultcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              child: InkWell(
                onTap: userid == null
                    ? () {
                        Timer(
                            Duration(seconds: 2),
                            () => Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false));
                      }
                    : () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('user_id');
                        prefs.remove('user_name');
                        prefs.remove('user_email');
                        Fluttertoast.showToast(
                            msg: "Logout SuccessFully ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        Timer(
                            Duration(seconds: 2),
                            () => Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false));
                      },
                child: ListTile(
                  title: Text(
                    userid == null ? " Login " : "Logout",
                    style: TextStyle(
                        color: defaultcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  leading: userid == null
                      ? Icon(
                          Icons.login,
                          color: defaultcolor,
                        )
                      : Icon(
                          Icons.logout_outlined,
                          color: defaultcolor,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: homeheadercolor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 40,
                  color: defaultcolor,
                  icon: const Icon(Icons.menu_open),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),
              ],
            ),
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: serach_controller,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: " Search report here",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Departmentwiseproject(
                                  0, serach_controller.text)),
                        );
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: defaultcolor,
                            border: Border.all(color: defaultcolor)),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 40,
              color: defaultcolor,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          is_active = 1;
                        });
                      },
                      child: Text(
                        "RECENT PROJECT ",
                        style: TextStyle(
                            fontSize: 15,
                            color: is_active == 1 ? activecolor : Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(" |"),
                    InkWell(
                      onTap: () {
                        setState(() {
                          is_active = 2;
                        });
                      },
                      child: Text(
                        "POPULAR PROJECT",
                        style: TextStyle(
                            fontSize: 15,
                            color: is_active == 2 ? activecolor : Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.99,
              child: FutureBuilder<List>(
                  future: homeservice.get_trending(is_active),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map data = snapshot.data![index];
                            return Card(
                                elevation: 4.0,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(data['title']),
                                      subtitle: Text(data['user_name']),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsScreen(data)),
                                        );
                                      },
                                      child: Container(
                                        height: 200.0,
                                        child: Ink.image(
                                          image: NetworkImage(
                                              "${GlobalConfiguration().getValue('upload_image') + data['front_image']}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(16.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(data['Description']
                                          .substring(1, 100)),
                                    ),
                                    ButtonBar(
                                      children: [
                                        IconButton(
                                          color: Colors.grey,
                                          iconSize: 22,
                                          icon: Icon(Icons.share),
                                          onPressed: () async {
                                            String url =
                                                "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fgraduateresearchproject.com%2Fbook-details%2F${data['id']}";

                                            if (await launch(url))
                                              await launchUrl(Uri.parse(url));
                                            else
                                              // can't launch url, there is some error
                                              throw "Could not launch $url";
                                          },
                                        ),
                                        IconButton(
                                          color: data['is_bookmrk'] != '0'
                                              ? Colors.red
                                              : Colors.grey,
                                          iconSize: 22,
                                          icon: Icon(Icons.bookmark),
                                          onPressed: () {
                                            addbookmarksandlike(
                                                data["id"], "2");
                                          },
                                        ),
                                        IconButton(
                                          color: data['is_like'] != '0'
                                              ? Colors.red
                                              : Colors.grey,
                                          iconSize: 22,
                                          icon: Icon(Icons.favorite),
                                          onPressed: () {
                                            addbookmarksandlike(
                                                data["id"], "1");
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ));
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}
