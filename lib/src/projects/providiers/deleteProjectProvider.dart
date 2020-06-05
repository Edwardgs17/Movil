import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/HttpClient.dart';
import 'package:http/http.dart';

class DeleteProjectProvidier {
  HttpClient http;
  String uri;
  
  DeleteProjectProvidier() {
    uri = ConfigUri().getUri();
    http = HttpClient();
  }

   Future<Map> deleteProjectById(id) async {
    try {
      Response response = await http.delete('$uri/projects/$id');
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
  }
}