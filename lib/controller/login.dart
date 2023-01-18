import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

class LoginApi {
  Future<LoginApiResponse> apiCallLogin(Map<String, dynamic> param) async {
    var url = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}/users/login');
    print(param);

    var response = await http.post(url, body: param);

    final data = jsonDecode(response.body);
    return LoginApiResponse(
      token: data['data'].isEmpty ? '' : data['data']["user_id"].toString(),
      status: data["status"].toString(),
      Name: data['data'].isEmpty ? '' : data['data']['user_name'].toString(),
      email: data['data'].isEmpty ? '' : data['data']['user_email'],
      message: data['data'].isEmpty ? '' : data['message'].toString(),
      usermobile: data['data'].isEmpty ? '' : data['data']['user_mobile'],
    );
  }

  Future<Changeprofileresponse> changemyprofile(
      Map<String, dynamic> param) async {
    var url = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}/Changeprofile');

    var response = await http.post(url, body: param);

    final data = jsonDecode(response.body);
    print(data);
    return Changeprofileresponse(
        message: data['message'], status: data['status']);
  }

  Future<RegisterResponse> apiCallregister(Map<String, dynamic> param) async {
    var url = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}/users/index_post');
    print(param);

    var response = await http.post(url, body: param);

    final data = jsonDecode(response.body);
    return RegisterResponse(status: data['status'], error: data['error']);
  }

  Future<RegisterResponse> apiCallpasswordrest(
      Map<String, dynamic> param) async {
    var url = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}/resetpassword');
    print(param);

    var response = await http.post(url, body: param);

    final data = jsonDecode(response.body);
    return RegisterResponse(
        status: data['status'], error: data['error'].toString());
  }

  Future<RegisterResponse> apiCallOtpSend(Map<String, dynamic> param) async {
    var url =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}/otpsend/');

    var response = await http.post(url, body: param);

    final data = jsonDecode(response.body);

    return RegisterResponse(status: data['status'], error: data['error']);
  }
}

class LoginApiResponse {
  final String? token;
  final String? status;
  final String? Name;
  final String? email;
  final String? message;
  final String? usermobile;

  LoginApiResponse(
      {this.token,
      this.status,
      this.Name,
      this.email,
      this.message,
      this.usermobile});
}

class RegisterResponse {
  final String status;
  final String? error;
  RegisterResponse({required this.status, this.error});
}

class Changeprofileresponse {
  final String? message;
  final String? status;
  Changeprofileresponse({this.message, this.status});
}
