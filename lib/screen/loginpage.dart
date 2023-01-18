import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hy_application/screen/RegisterPage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/login.dart';
import '../mastercolor.dart';
import 'widgets/customtextfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
final emailconroller = TextEditingController();
final passwordcontroller = TextEditingController();
bool isforget = false;
final service = LoginApi();
bool is_otpsend = false;

calllogin(email, password) {
  print("email:" + email + ' passwprd:' + password);
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    passwordreset() async {
      service.apiCallpasswordrest(
        {
          "email": emailconroller.text,
          "password": passwordcontroller.text,
          "re_password": repassword.text,
        },
      ).then((value) {
        if (value.status == '0') {
          var errormessage = value.error!;
          Fluttertoast.showToast(
              msg: errormessage = value.error!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          // setState(() {
          //   isvaliduser = true;
          // });
          setState(() {
            isforget = true;
          });
        } else {
          Fluttertoast.showToast(
              msg: " Password Reset Successfully ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        }
      });
    }

    callLoginApi() async {
      final service = LoginApi();

      // final preference = PrefService();
      final prefs = await SharedPreferences.getInstance();

      if (formkey.currentState!.validate()) {
        service.apiCallLogin(
          {
            "email": emailconroller.text,
            "password": passwordcontroller.text,
          },
        ).then((value) async {
          if (value.status == '0') {
            var errormessage = value.message!;
            Fluttertoast.showToast(
                msg: "Invalid credential ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            // setState(() {
            //   isvaliduser = true;
            // });
            setState(() {
              isforget = true;
            });
          } else {
            Fluttertoast.showToast(
                msg: "Login Success Fully ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            await prefs.setString('user_name', '${value.Name}');
            await prefs.setString('user_id', '${value.token}');
            await prefs.setString('user_email', '${value.email}');
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          }
        });
      } else {}
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                shadowColor: defaultcolor,
                elevation: 5,
                child: Form(
                  key: formkey,
                  child: ListView(
                    children: [
                      Row(
                        children: [Text('skip')],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("BOOK",
                              style: TextStyle(
                                  color: defaultcolor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Text("LAB",
                              style: TextStyle(
                                  color: homeheadercolor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Form",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(emailconroller, "Enter Email"),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(passwordcontroller, "Enter password"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: homeheadercolor,
                            ),
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                // Navigator.of(context)
                                //     .pushNamedAndRemoveUntil(
                                //         '/select-topic',
                                //         (Route<dynamic> route) => false);
                                // calllogin(emailconroller.text,passwordcontroller.text);
                                callLoginApi();
                              },
                              child: Text(
                                " Login",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isforget == true
                          ? TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.75,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(25.0),
                                            topRight:
                                                const Radius.circular(25.0),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Set new password",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: defaultcolor),
                                              ),
                                            ),
                                            CustomTextField(
                                                emailconroller, "Enter Email"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            CustomTextField(passwordcontroller,
                                                "Enter password"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            CustomTextField(repassword,
                                                "Enter re Password"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  passwordreset();
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: double.infinity,
                                                  color: defaultcolor,
                                                  child: Center(
                                                      child: Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0),
                                                  )),
                                                ))
                                          ],
                                        )));
                              },
                              child: Text("Forget Password"))
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Not register at ?"),
                          InkWell(
                              splashColor: defaultcolor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()),
                                );
                              },
                              child: Text(
                                "Create an Account",
                                style: TextStyle(color: Colors.blue),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
