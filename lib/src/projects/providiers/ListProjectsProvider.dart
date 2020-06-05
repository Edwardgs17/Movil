import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/Session.dart';
import '../../../utils/HttpClient.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ListProjectsProvider {
  List<dynamic> projectsData = [];
  HttpClient client;
  String uri;
  Session session;

  ListProjectsProvider() {
    client = new HttpClient();
    uri = ConfigUri().getUri();
    session = Session();
  }

  Future<List<dynamic>> getListProjects(context) async {
    
    http.Response response = await client.get('$uri/projects/users/');
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
