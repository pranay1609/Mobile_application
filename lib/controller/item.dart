import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Items {
  Dio dio = Dio();

  Future<List> get_trending(int is_active) async {
    String? userid = '0';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userid = prefs.getString('user_id');
    String BASE_URL =
        "${GlobalConfiguration().getValue('api_base_url')}/item/0/$userid/$is_active";
    try {
      var response = await dio.get(BASE_URL);
      return response.data['data'];
    } on DioError {
      //print(e);
      return Future.error("No  recent");
    }
  }

  Future<List> get_departmentwise(int is_active, String? searchkey) async {
    String? userid = '0';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userid = prefs.getString('user_id');
    String BASE_URL =
        "${GlobalConfiguration().getValue('api_base_url')}/departmentitem/0/$userid/$is_active/$searchkey";
    try {
      var response = await dio.get(BASE_URL);
      return response.data['data'];
    } on DioError {
      //print(e);
      return Future.error("No  recent");
    }
  }

  Future<List> get_featured() async {
    String BASEURL = "${GlobalConfiguration().getValue('api_base_url')}/item";

    try {
      var response = await dio.get(BASEURL);
      return response.data['data'];
    } on DioError {
      //print(e);
      return Future.error("No  recent");
    }
  }
}

class Itemdetails {
  final String? name;
  Itemdetails(this.name);
}
