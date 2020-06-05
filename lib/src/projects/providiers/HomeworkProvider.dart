import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class HomeworkProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
 List<dynamic> homeworkData = [];


  HomeworkProvider() {
    http = HttpClient();
  }

  Future<String> deleteHomework(id) async {

    Map response;

    try {
      Response res = await http.delete('$_url/homeworkImage/image/$id');
      response = jsonDecode(res.body);

      return response['message'];

    } catch (err) {
      print(err);

      return '¡Ha occurrido un problema!';
    }
  }

  Future<List<dynamic>> getHomeworksByIdProject(id) async {

    List<dynamic> response;

    try {
      Response res = await http.get('$_url/projects/$id/homework');
      response = jsonDecode(res.body);

      return response;

    } catch (err) {
      print(err);

      return [];
    }
  }

  Future<List> getHomeworkDetails(idProject) async {
    try {
      Response response = await http
          .get('$_url/projects/homework/$idProject');

        homeworkData = json.decode(response.body);
      return homeworkData;
    } catch (err) {
      return null;
    }
  }
}
