import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/Session.dart';

import '../../../utils/HttpClient.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ListProjectsProcessProvider {
  List<dynamic> projectsData = [];
  HttpClient client;
  String uri;
  Session session;

  ListProjectsProcessProvider() {
    client = new HttpClient();
    uri = ConfigUri().getUri();
    session = Session();
  }

  Future<List<dynamic>> getListProjectsProcess(context) async {
    
    http.Response response = await client.get('$uri/projects/project');
    try {
      projectsData = json.decode(response.body);
      return projectsData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return projectsData;
    }
  }

    Future<List<dynamic>> getListProjectsProcessTwo(context) async {
    
    http.Response response = await client.get('$uri/projects/projectss');
    try {
      projectsData = json.decode(response.body);
      return projectsData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return projectsData;
    }
  }
}
