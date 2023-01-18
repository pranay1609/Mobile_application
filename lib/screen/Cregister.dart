import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hy_application/mastercolor.dart';
import 'package:hy_application/screen/Cloginpage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../controller/login.dart';
import 'RegisterPage.dart';

class Cregister extends StatefulWidget {
  const Cregister({super.key});

  @override
  State<Cregister> createState() => _CregisterState();
}

class _CregisterState extends State<Cregister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//  TextEditingController emailconroller = TextEditingController();
  final emailconroller = TextEditingController();
  final fullname = TextEditingController();
  final repassword = TextEditingController();
  final usertype = TextEditingController();
  final passwordcontroller = TextEditingController();

  String? designationvallue;
  String? designationid;
  Map<String, int> someMap = {
    "a": 1,
    "b": 2,
  };
  callLoginApi() async {
    final service = LoginApi();
    // final preference = PrefService();
    // final prefs = await SharedPreferences.getInstance();

    if (formkey.currentState!.validate()) {
      if (isconfirmotp == true) {
      } else {
        service.apiCallOtpSend({"email": emailconroller.text}).then((value) {
          print(value.error);
          if (value.status == '1') {
            setState(() {
              sendotp = int.parse(value.error.toString());
            });
            showModalBottomSheet<void>(
              elevation: 10,
              isDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Enter OTP send on email id "),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: OTPTextField(
                          controller: otp_controller,
                          length: 4,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 40,
                          style: TextStyle(fontSize: 17),
                          textFieldAlignment: MainAxisAlignment.spaceEvenly,
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 5,
                          onCompleted: (pin) {
                            if (pin != sendotp.toString()) {
                              Fluttertoast.showToast(
                                  msg: "Enter valid Otp",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              service.apiCallregister(
                                {
                                  "email": emailconroller.text,
                                  "password": passwordcontroller.text,
                                  "name": fullname.text,
                                  "re_password": repassword.text,
                                  'user_type': designationid
                                },
                              ).then((value) {
                                if (value.status == '0') {
                                  var errormessage = value.error!;
                                  Fluttertoast.showToast(
                                      msg: value.error.toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  // setState(() {
                                  //   isvaliduser = true;
                                  // });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Register Successfully ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/login',
                                      (Route<dynamic> route) => false);
                                }
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          color: defaultcolor,
                          child: TextButton(
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            Fluttertoast.showToast(
                msg: value.error.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'BOOK',
                        style: TextStyle(
                            color: homeheadercolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Text(
                        'Lab',
                        style: TextStyle(
                            color: defaultcolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ],
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: fullname,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: false,
                  controller: emailconroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email ',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordcontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: repassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Re Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(gapPadding: 1)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: designationvallue,
                        hint: Text("Select Designation"),
                        items: <String>['Student', 'Professor']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (ValueKey) {
                          if (ValueKey == 'Student') {
                            setState(() {
                              designationvallue = 'Student';
                              designationid = '0';
                            });
                            print(0);
                          } else if (ValueKey == 'Professor') {
                            setState(() {
                              designationvallue = 'Professor';
                              designationid = '1';
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: Text(
                  'Forgot Password',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: defaultcolor,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      callLoginApi();
                    },
                  )),
              Row(
                children: <Widget>[
                  const Text('Already have account?'),
                  TextButton(
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Clogin()),
                      );
                      //signup screen
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ));
  }
}
