import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

class BookMarkApi {
  Future<BookMarkApiResponse> addedbookmark(Map<String, dynamic> param) async {
    var url = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}/Bookmarks/index_post');
    print(param);

    var response = await http.post(url, body: param);

    final data = jsonDecode(response.body);
    return BookMarkApiResponse(
        status: data['status'], message: data['message']);
  }

  Future<FeedbackResponse> addfeedback(Map<String, dynamic> param) async {
    var url =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}/feedback');
    print(param);

    var response = await http.post(url, body: param);

    final data = jsonDecode(response.body);
    return FeedbackResponse(status: data['status'], message: data['message']);
  }
}

class BookMarkApiResponse {
  final String? status;
  final String? message;
  BookMarkApiResponse({this.status, this.message});
}

class FeedbackResponse {
  final String? status;
  final String? message;
  FeedbackResponse({this.status, this.message});
}
