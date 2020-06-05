import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class HomeworkQualificationProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
  List<dynamic> homeworkQualificationData = [];
  List<dynamic> homeworkQualificationByHomeworkData = [];

  HomeworkQualificationProvider() {
    http = HttpClient();
  }

  Future<List> createHomeworkQualification(data) async {
    List res;
    try {
      Response response =
          await http.post('$_url/projects/homeworkQualification', data);
      res = jsonDecode(response.body);
      return res;
    } catch (e) {
      return null;
    }
  }

  Future<List> getHomeworkQualification(idUser, idHomework) async {
    try {
      Response response = await http.get(
          '$_url/projects/homeworkQualification/user/$idUser/homework/$idHomework');

      homeworkQualificationData = json.decode(response.body);
      return homeworkQualificationData;
    } catch (err) {
      return null;
    }
  }

  Future<List> updateHomeworkQualification(id, data) async {
    List res;

    try {
      Response response =
          await http.put('$_url/projects/homeworkQualification/$id', data);
      res = jsonDecode(response.body);

      return res;
    } catch (err) {
      return null;
    }
  }

  Future<List> getHomeworkQualificationByHomework(idHomework) async {
    try {
      Response response = await http
          .get('$_url/projects/homeworkQualification/homework/$idHomework');

      homeworkQualificationByHomeworkData = json.decode(response.body);
      return homeworkQualificationByHomeworkData;
    } catch (err) {
      return null;
    }
  }
}
