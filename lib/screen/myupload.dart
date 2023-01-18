import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hy_application/mastercolor.dart';
import 'package:hy_application/screen/widgets/customtextfield.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/departmentmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MyUpload extends StatefulWidget {
  String pid = '81';
  MyUpload(this.pid);

  @override
  State<MyUpload> createState() => _MyUploadState();
}

class _MyUploadState extends State<MyUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyCustomForm(widget.pid.toString()),
      appBar: AppBar(
        backgroundColor: defaultcolor,
        title: Text(widget.pid == '' ? " Upload" : "Update"),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  String prid;
  MyCustomForm(this.prid);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(prid);
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  String ppid;
  MyCustomFormState(this.ppid);

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final university_controller = TextEditingController();
  final title_controller = TextEditingController();
  final graduation_controller = TextEditingController();
  final professor_controller = TextEditingController();
  final pro_email_controller = TextEditingController();
  final pro_url_controller = TextEditingController();
  final description_controller = TextEditingController();

  File? uploadimage;
  File? uploapdf;
  var projectdata;

  bool is_success = true;
  String snackbarmsg = 'Processing Data';
  String? userid;
  String? user_name;
  String? user_email;

  String? selectdistrict;
  void initState() {
    super.initState();
    fetchdistrict();
    getuserid();
    getdatabyid();

    // getallslider();
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String qid = prefs.getString('password').toString();
    var is_login = prefs.getString('user_id');
    setState(() {
      userid = is_login;
      user_name = prefs.getString('user_name');
      user_email = prefs.getString('user_email');
    });
  }

  getdatabyid() async {
    Dio dio = Dio();
    if (ppid != '') {
      print(ppid);
      String BASE_URL =
          "${GlobalConfiguration().getValue('api_base_url')}/item/$ppid";

      try {
        var response = await dio.get(BASE_URL);

        setState(() {
          projectdata = response.data['data'];
          title_controller.text = projectdata['title'];
          university_controller.text = projectdata['university'];
          description_controller.text = projectdata['Description'];
          graduation_controller.text = projectdata['graduation'];
          professor_controller.text = projectdata['professor'];
          pro_email_controller.text = projectdata['professor_email'];
          pro_url_controller.text = projectdata['professor_url'];
          selectdistrict = projectdata['topic_id'];
        });
      } on DioError {
        //print(e);
        print("No  recent");
      }
    }
  }

  fetchdistrict() async {
    String geturl =
        '${GlobalConfiguration().getValue('api_base_url')}/Department';

    var response = await http.get(Uri.parse(geturl));
    var responsedata = jsonDecode(response.body);

    var districtliscountrydata = responsedata['data'];

    if (districtliscountrydata.isNotEmpty) {
      districtliscountrydata.forEach((d) {
        DepartmentModel dtl =
            DepartmentModel(districtname: "${d['title']}", districtid: d['id']);

        setState(() {
          _districtlist.add(dtl);
        });
      });
    } else {
      setState(() {
        _districtlist.clear();
      });

      print(" data not found");
    }
  }

  List<DepartmentModel> _districtlist = [];
  Widget Districtdropdown(String title, var selectcurr) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(title),
                value: selectdistrict,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    selectdistrict = newValue;
                  });
                },
                items: _districtlist.map((var value) {
                  return DropdownMenuItem<String>(
                    value: value.districtid.toString(),
                    child: Text(value.districtname),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> multipartImageUpload() async {
    File? image = uploadimage;
    dynamic mimeTypeData;
    dynamic file;
    dynamic filepdf;
    var uri =
        Uri.parse("${GlobalConfiguration().getValue('api_base_url')}/item");
    if (image != null) {
      mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');
    }

    // Intilize the multipart request

    final imageUploadRequest = http.MultipartRequest('POST', uri);

    // Attach the file in the request
    if (image != null) {
      file = await http.MultipartFile.fromPath('image', image.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }
    if (uploapdf != null) {
      filepdf = await http.MultipartFile.fromPath('upload_pdf', uploapdf!.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }
    if (image != null) {
      imageUploadRequest.files.add(file);
    }
    if (uploapdf != null) {
      imageUploadRequest.files.add(filepdf);
    }

    imageUploadRequest.fields.addAll({
      'id': widget.prid != '' ? widget.prid : "",
      "university": university_controller.text,
      "title": title_controller.text,
      "Description": description_controller.text,
      "user_name": user_name.toString(),
      "graduation": graduation_controller.text,
      "professor": professor_controller.text,
      "user_email": user_email.toString(),
      "professor_url": pro_url_controller.text,
      "topic_id": selectdistrict.toString(),
      "professor_email": pro_email_controller.text,
      "created_by": userid.toString()
    });

    // add headers if needed
    //imageUploadRequest.headers.addAll(<some-headers>);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var data = json.decode(response.body);
          print(data);
        }
        setState(() {
          _formKey.currentState?.reset();
          uploadimage = null;
          university_controller.text = "";
          description_controller.text = "";
          title_controller.text = "";
          graduation_controller.text = "";
          pro_email_controller.text = "";
          pro_url_controller.text = "";
          professor_controller.text = "";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green[100],
              content: Text(" suceessfully uploaded")),
        );
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void chooseImage() async {
    uploadimage = File(await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile!.path));
    setState(() {
      uploadimage = uploadimage as File?;
    });
  }

  void choosePdf() async {
    // uploadimage = File(await ImagePicker()
    //     .getImage(source: ImageSource.gallery)
    //     .then((pickedFile) => pickedFile!.path));
    // setState(() {
    //   uploapdf = uploadimage as File?;
    // });
    FilePickerResult? uploapdfss = await FilePicker.platform.pickFiles();

    if (uploapdfss != null) {
      setState(() {
        uploapdf = File(uploapdfss.files.single.path ?? 'file.pdf');
      });
      print(uploapdf);
    } else {
      // User canceled the picker
      print(" cancke file picker");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return widget.prid != '' && projectdata == null
        ? Center(
            child: CircularProgressIndicator(
              color: homeheadercolor,
              backgroundColor: defaultcolor,
            ),
          )
        : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Districtdropdown('Select Department', _districtlist),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(university_controller, "University"),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(title_controller, "Title"),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(graduation_controller, "Graduation"),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(professor_controller, "Professor"),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(pro_email_controller, "Professor Email"),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(pro_url_controller, "Professor Url"),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          chooseImage(); // call choose image function
                        },
                        icon: Icon(Icons.folder_open),
                        label: Row(
                          children: [
                            Text("CHOOSE IMAGE"),
                            Container(
                                child: uploadimage != null
                                    ? Image.file(
                                        uploadimage!,
                                        width: 100.0,
                                        height: 50.0,
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Container(
                                        child: widget.prid != '' &&
                                                projectdata != null
                                            ? Image.network(
                                                "${GlobalConfiguration().getValue('upload_image') + projectdata['front_image']}",
                                                width: 100,
                                                height: 50,
                                                fit: BoxFit.fitHeight,
                                              )
                                            : Container(),
                                      )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          choosePdf(); // call choose image function
                        },
                        icon: Icon(Icons.folder_open),
                        label: Row(
                          children: [
                            Text("CHOOSE Pdf :"),
                            Container(
                                child: uploapdf != null
                                    ? Text(uploapdf.toString().substring(
                                        uploapdf.toString().length - 10))
                                    : Container(
                                        child: widget.prid != '' &&
                                                projectdata != null
                                            ? Text(projectdata['upload_pdf'])
                                            : Container(),
                                      )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      description_controller,
                      "Description",
                      maxliness: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.

                          if (_formKey.currentState!.validate()) {
                            multipartImageUpload();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(" Processing Data")),
                            );

                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

                          }
                        },
                        child: Text(widget.prid == '' ? 'Upload' : 'Update'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
