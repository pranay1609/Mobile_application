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
import 'details/details_screen.dart';
import 'myupload.dart';

class Departmentwiseproject extends StatefulWidget {
  String departmentname;
  int department_id;
  Departmentwiseproject(this.department_id, this.departmentname);

  @override
  State<Departmentwiseproject> createState() => _DepartmentwiseprojectState();
}

class _DepartmentwiseprojectState extends State<Departmentwiseproject> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final homeservice = Items();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final bookmarkservice = BookMarkApi();

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
      appBar: AppBar(
        title: Text(widget.departmentname),
        backgroundColor: defaultcolor,
      ),
      bottomNavigationBar: BottomNavigationCustom(),
      key: _scaffoldKey,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.99,
              child: FutureBuilder<List>(
                  future: widget.department_id != 0
                      ? homeservice.get_departmentwise(widget.department_id, '')
                      : homeservice.get_departmentwise(
                          widget.department_id, widget.departmentname),
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
