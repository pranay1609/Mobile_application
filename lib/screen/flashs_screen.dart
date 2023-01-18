import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hy_application/mastercolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashScreen extends StatefulWidget {
  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  String? userid;

  void initState() {
    super.initState();

    getuserid();
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String qid = prefs.getString('password').toString();
    var is_login = prefs.getString('user_id');
    setState(() {
      userid = is_login;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/flshgs.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Reading Is ",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Fascinating",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Worl best writer,works and write entertaining literature for you",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Lets Start",
              style: TextStyle(
                  color: Color.fromARGB(255, 193, 64, 13),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: defaultcolor,
                child: InkWell(
                  onTap: () {
                    CircularProgressIndicator();
                    Timer(
                        Duration(seconds: 2),
                        () => userid == null
                            ? Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false)
                            : Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false));
                  },
                  child: Icon(
                    Icons.trending_neutral_outlined,
                    size: 55,
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
