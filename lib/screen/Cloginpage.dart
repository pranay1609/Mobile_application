import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hy_application/mastercolor.dart';
import 'package:hy_application/screen/Cregister.dart';
import 'package:hy_application/screen/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/login.dart';
import 'RegisterPage.dart';
import 'widgets/customtextfield.dart';

class Clogin extends StatefulWidget {
  const Clogin({super.key});

  @override
  State<Clogin> createState() => _CloginState();
}

class _CloginState extends State<Clogin> {
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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isforget = false;
  final service = LoginApi();
  bool is_otpsend = false;
  passwordreset() async {
    service.apiCallpasswordrest(
      {
        "email": nameController.text,
        "password": passwordController.text,
        "re_password": repasswordController.text,
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

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
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
          "email": nameController.text,
          "password": passwordController.text,
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
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == '') {
                      return 'User email field is required';
                    } else {
                      return null;
                    }
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator: (value) {
                    if (value == '') {
                      return "password field is required";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Set new password",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: defaultcolor),
                                ),
                              ),
                              CustomTextField(nameController, "Enter Email"),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                  passwordController, "Enter password"),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                  repasswordController, "Enter re Password"),
                              SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                  onPressed: () {
                                    passwordreset();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    color: defaultcolor,
                                    child: Center(
                                        child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    )),
                                  ))
                            ],
                          )));
                },
                child: const Text(
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
                      'Login',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      callLoginApi();
                    },
                  )),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cregister()),
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
