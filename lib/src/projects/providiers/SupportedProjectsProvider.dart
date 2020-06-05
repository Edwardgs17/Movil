import 'dart:convert';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class SupportedProjectsProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
  List<dynamic> dataProjects;

  SupportedProjectsProvider() {
    http = HttpClient();
  }

  Future<List<dynamic>> getSupportedProjects(idUser) async {
    try {
      Response response = await http
          .get('$_url/investments/user/$idUser/projects');
      dataProjects =json.decode(response.body);
      return dataProjects;
    } catch (err) {
      return null;
    }
  }
}