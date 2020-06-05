import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class SeeProjectProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
  List<dynamic> projectData = [];


  SeeProjectProvider() {
    http = HttpClient();
  }

  Future getProjectDetails(idProject) async {

    try {
      Response response = await http.get('$_url/projects/$idProject');
      print('hola');
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProjectQualification(id, body) async {
    
    try {
      Response response = await http.put('$_url/projects/qualificationAverage/$id', body);
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }
}