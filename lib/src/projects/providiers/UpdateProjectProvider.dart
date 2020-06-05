import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/src/projects/models/target_models.dart';
import 'package:colfunding/utils/HttpClient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProjectProvidier {
  HttpClient http;
  String uri;
  
  UpdateProjectProvidier() {
    uri = ConfigUri().getUri();
    http = HttpClient();
  }

  Future<Map> getProjectInformation(id) async {
    try {
      Response response = await http.get('$uri/projects/$id');
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
  }

  Future<Map> updateProject(id,data) async {
    try {
      Response response = await http.put('$uri/projects/$id', data);
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
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