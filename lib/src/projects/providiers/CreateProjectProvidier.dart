import 'dart:convert';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:colfunding/src/projects/models/target_models.dart';
import 'package:colfunding/utils/HttpClient.dart';

class CreateProjectProvidier {
  HttpClient http;
  String uri;

  CreateProjectProvidier() {
    uri = ConfigUri().getUri();
    http = HttpClient();
  }

  Future<Map> createProject(data) async {
    Map project;

    try {
      Response res = await http.post('$uri/projects', data);
      project = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }

    return project;
  }

  Future<Map> saveImage(data) async {
    Map dataImage;

    try {
      Response res = await http.post('$uri/projects/image', data);
      dataImage = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }

    return dataImage;
  }

  Future<List<TargetAudiences>> loadTargetAudience(BuildContext context) async {
    var targetAudience = List<bool>();

    Response res = await http.get('$uri/targetAudience');
    try {
      var data = json.decode(res.body);
      List<TargetAudiences> targets = [];

      for (var u in data) {
        TargetAudiences target = TargetAudiences(u["id"], u["name"]);
        targets.add(target);
        targetAudience.add(false);
      }

      return targets;
    } catch (e) {}
    return [];
  }
}
