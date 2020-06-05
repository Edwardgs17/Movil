import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:http/http.dart' as http;

import '../../../utils/HttpClient.dart';
import 'dart:convert';

class MyProjectsProvidier {

  List<dynamic> projectsData = [];
  HttpClient client;
  String uri;
  Session session;


  MyProjectsProvidier(){
   client = new HttpClient();
   uri = ConfigUri().getUri();
   session = Session();
  }

  Future<List<dynamic>> getImageByIdProjects(context, id) async {
    client = new HttpClient();
    http.Response response = await client.get('$uri/projects/users/$id');
    try {
      projectsData = json.decode(response.body);
      return projectsData;
    } catch (e) {
      print("Ok");
    }
    return [];
  }

  Future<Map<String, dynamic>> updateProcessProject(id, body) async {
    client = new HttpClient();
    http.Response response = await client.put('$uri/projects/process/project/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> aprovedProject(id, body) async {
    client = new HttpClient();
    http.Response response = await client.put('$uri/projects/process/aproved/project/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> editedProject(id, body) async {
    client = new HttpClient();
    http.Response response = await client.put('$uri/projects/process/edition/project/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }
}