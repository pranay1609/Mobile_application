import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hy_application/screen/loginpage.dart';
import '../controller/login.dart';
import '../mastercolor.dart';
import 'widgets/customtextfield.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
final emailconroller = TextEditingController();
final fullname = TextEditingController();
final repassword = TextEditingController();
final usertype = TextEditingController();
final passwordcontroller = TextEditingController();
int? sendotp;
OtpFieldController otp_controller = OtpFieldController();
bool? isconfirmotp = false;

class RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
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
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/login',
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

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shadowColor: defaultcolor,
                elevation: 5,
                child: Form(
                  key: formkey,
                  child: ListView(
                    children: [
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
                            "Register  ",
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
                      CustomTextField(fullname, "Enter Full Name"),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(emailconroller, "Enter Email"),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(passwordcontroller, "Enter password"),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(repassword, "Enter re Password"),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(usertype, "User Type"),
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
                                " Register",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have account ? "),
                          InkWell(
                              splashColor: defaultcolor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                "Login",
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
