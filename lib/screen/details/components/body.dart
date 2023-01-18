import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:custom_dialouge/custom_dialouge.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hy_application/mastercolor.dart';
import 'package:hy_application/screen/widgets/customtextfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import '../../../controller/bookmarkcontroller.dart';
import 'color_and_size.dart';
import 'counter_with_fav_btn.dart';
import 'description.dart';
import 'product_title_with_image.dart';

class Body extends StatefulWidget {
  final Map data;
  Body(this.data);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? userid;
  @override
  void initState() {
    super.initState();

    getuserid();
  }

  List<dynamic> myfeedbacks = [];

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String qid = prefs.getString('password').toString();
    var is_login = prefs.getString('user_id');
    setState(() {
      userid = is_login;
    });
    String BASE_URL =
        "${GlobalConfiguration().getValue('api_base_url')}/feedback/${widget.data["id"]}";
    Dio dio = Dio();
    try {
      var response = await dio.get(BASE_URL);

      setState(() {
        myfeedbacks = response.data["data"];
      });
    } on DioError {
      //print(e);
      print("No  recent");
    }
  }

  final bookmarkservice = BookMarkApi();
  Widget build(BuildContext context) {
    Map product;
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    final _feedback = TextEditingController();
    String? ratingpoint;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.2),
                  padding: EdgeInsets.only(
                    top: size.height * 0.10,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      ColorAndSize(widget.data),
                      SizedBox(height: kDefaultPaddin / 2),
                      Description(widget.data),
                      SizedBox(height: kDefaultPaddin / 2),
                      CounterWithFavBtn(widget.data),
                      SizedBox(height: kDefaultPaddin / 2),
                    ],
                  ),
                ),
                ProductTitleWithImage(widget.data)
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Wrap(
              // direction: Axis.vertical,
              alignment: WrapAlignment.spaceAround,
              spacing: 20.0,
              runAlignment: WrapAlignment.start,
              // runSpacing: 8.0,
              crossAxisAlignment: WrapCrossAlignment.start,
              // textDirection: TextDirection.rtl,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      bookmarkservice.addedbookmark({
                        "ebook_id": widget.data["id"],
                        "type_id": '2',
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
                      });
                    },
                    icon: Icon(
                      Icons.bookmark_add,
                      color: Colors.black,
                    ),
                    label: Text(" Add to Bookmark")),
                TextButton.icon(
                    onPressed: () async {
                      String url =
                          "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fgraduateresearchproject.com%2Fbook-details%2F${widget.data['id']}";

                      if (await launch(url))
                        await launchUrl(Uri.parse(url));
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    label: Text(" share"))
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: widget.data['is_verify'] == '1'
                    ? Colors.green[100]
                    : defaultcolor,
                shape: BoxShape.rectangle,

                // BoxShape.circle or BoxShape.retangle
                //color: const Color(0xFF66BB6A),
                boxShadow: [
                  BoxShadow(
                    color: widget.data['is_verify'] == '1'
                        ? Colors.green
                        : defaultcolor,
                    blurRadius: 5.0,
                  ),
                ]),
            height: 50,
            width: double.infinity,
            child: Center(
              child: widget.data['is_verify'] == '1'
                  ? Text(
                      "Verify",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "Unverify",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: 500,
            child: ContainedTabBarView(
              tabBarProperties: TabBarProperties(indicatorColor: defaultcolor),
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Text(
                  'Rating',
                  style: TextStyle(color: Colors.black),
                ),
              ],
              views: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(widget.data['Description']),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: myfeedbacks.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                trailing: Icon(Icons.star),
                                leading: Icon(Icons.supervised_user_circle),
                                subtitle:
                                    Text(myfeedbacks[index]["created_at"]),
                                title: Text(myfeedbacks[index]["comments"]),
                              );
                            }),
                      ),
                      TextButton(
                          onPressed: () async {
                            await CustomPackageAlertBox.showCustomAlertBox(
                              context: context,
                              willDisplayWidget: Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    RatingBar.builder(
                                      glowRadius: 1,
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, _) => Icon(
                                        size: 10.0,
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          ratingpoint = rating.toString();
                                        });
                                      },
                                    ),
                                    CustomTextField(
                                        _feedback, " Enter Feedback"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                            child: Text('Submit'),
                                            onPressed: () {
                                              bookmarkservice.addfeedback({
                                                "ebook_id": widget.data["id"],
                                                "rating_point":
                                                    ratingpoint.toString(),
                                                "user_id": userid.toString(),
                                                "comments": _feedback.text,
                                              }).then((value) {
                                                setState(() {
                                                  _feedback.text = '';
                                                });
                                                Fluttertoast.showToast(
                                                    msg: value.message
                                                        .toString(),
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              });

                                              Navigator.pop(context);
                                              print('Pressed');
                                            }),
                                        ElevatedButton(
                                            // ignore: prefer_const_constructors
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.red)),
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text("Add rating"))
                    ],
                  ),
                )
              ],
              onChange: (index) => print(index),
            ),
          ),
        ],
      ),
    );
  }
}
