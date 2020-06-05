import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class ProjectQualificationProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
  List<dynamic> projectQualificationData = [];
  List<dynamic> projectQualificationByProjectData = [];


  ProjectQualificationProvider() {
    http = HttpClient();
  }

  Future<List> getProjectQualification(context,idUser, idProject) async {
    try {
      Response response = await http
          .get('$_url/projects/projectQualification/user/$idUser/project/$idProject');

      projectQualificationData = json.decode(response.body);
      return projectQualificationData;
    } catch (err) {
      return null;
    }
  }

  Future<List> createProjectQualification(data) async {
    List res;
    try {
      Response response = await http.post('$_url/projects/projectQualification', data);
      res = jsonDecode(response.body);
      return res;
    } catch (e) {
      return null;
    }
  }

  
  Future<List> updateProjectQualification(id, data) async {
    List res;

    try {
      Response response = await http.put('$_url/projects/projectQualification/$id', data);
      res = jsonDecode(response.body);

      return res;
    } catch (err) {
      return null;
    }

  }

    Future<List> getProjectQualificationByProject(context,idProject) async {
    try {
      Response response = await http
          .get('$_url/projects/projectQualification/project/$idProject');

      projectQualificationByProjectData = json.decode(response.body);
      return projectQualificationByProjectData;
    } catch (err) {
      return null;
    }
  }
}
