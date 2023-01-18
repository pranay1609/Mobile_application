import 'package:flutter/material.dart';
import 'package:hy_application/screen/Cloginpage.dart';
import 'package:hy_application/screen/flashs_screen.dart';
import 'package:hy_application/screen/loginpage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hy_application/screen/myprofile.dart';
import 'package:hy_application/screen/myupload.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/homescreen.dart';
import 'screen/select_topic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await GlobalConfiguration().loadFromAsset("configurations");
  var checklogin = prefs.getString('user_id');
  runApp(MyApp(checklogin));
}

class MyApp extends StatelessWidget {
  final String? is_login;
  MyApp(this.is_login);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the HomeScreen widget.
        '/': (context) => FlashScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => Clogin(),
        '/select-topic': (context) => SelectTopic(),
        '/home': (context) => HomeScreen(),
        '/myprofile': (context) => MyProfile(),
        '/upload': (context) => MyUpload(''),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    );
  }
}
