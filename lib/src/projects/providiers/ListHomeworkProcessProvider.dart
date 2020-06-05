import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/Session.dart';

import '../../../utils/HttpClient.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ListHomeworkProcessProvider {
  List<dynamic> homeworkData = [];
  HttpClient client;
  String uri;
  Session session;

  ListHomeworkProcessProvider() {
    client = new HttpClient();
    uri = ConfigUri().getUri();
    session = Session();
  }

  Future<List<dynamic>> getListHomeworkProcessOne(context, id) async {
    
    http.Response response = await client.get('$uri/projects/$id/homeworks');
    try {
      homeworkData = json.decode(response.body);
      return homeworkData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return homeworkData;
    }
  }

    Future<List<dynamic>>  getListHomeworkProcessTwo(context,id) async {
    
    http.Response response = await client.get('$uri/projects/$id/homeworkss');
    try {
      homeworkData = json.decode(response.body);
      return homeworkData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return homeworkData;
    }
  }
  
  Future<List<dynamic>>  getListHomeworkProcessThird(context,id) async {
    
    http.Response response = await client.get('$uri/projects/$id/homeworksss');
    try {
      homeworkData = json.decode(response.body);
      return homeworkData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return homeworkData;
    }
  }

  Future<Map<String, dynamic>> updateHomeworkToEdition(id, body) async {
    client = new HttpClient();
    http.Response response = await client.put('$uri/projects/homework/edition/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> updateHomeworkToRevision(id, body) async {
    client = new HttpClient();
    http.Response response = await client.put('$uri/projects/homework/revision/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> updateHomeworkToAproved(id, body) async {
    client = new HttpClient();
    http.Response response = await client.put('$uri/projects/homework/aproved/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> updateHomeworkQualification(id, body) async {
    
    try {
      http.Response response = await client.put('$uri/projects/homework/qualification/$id', body);
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }
}
