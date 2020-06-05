import 'dart:convert';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:colfunding/src/projects/models/typeHomeworkModel.dart';
import 'package:colfunding/utils/HttpClient.dart';

class EditHomeworkProvider {
  HttpClient http;
  String uri;

  EditHomeworkProvider() {
    uri = ConfigUri().getUri();
    http = HttpClient();
  }

  Future<String> updateImageHomework(id, data) async {
    List<dynamic> image = [];

    try {
      Response res = await http.put('$uri/projects/image/homework/$id', data);
      image = jsonDecode(res.body);

      if (image.length > 0) {
        return 'Imagen Actualizada'; 
      } else {
        return 'No se encuentra la imagen';
      }

    } catch (err) {
      print(err);
      return err.toString();
    }
  }

  Future<List<dynamic>> updateHomework(id, data) async {
    List homework = [];

    try {
      Response res = await http.put('$uri/projects/homework/$id', data);
      homework = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }

    return homework;
  }

  Future<List<TypeHomework>> loadTypeHomeworkDropdown(BuildContext context) async {
    var typeHomework = List<bool>();

    Response res = await http.get('$uri/typeHomeworks');
    try {
      var data = json.decode(res.body);
      List<TypeHomework> listTypeHomeworks = [];

      for (var u in data) {
        TypeHomework typeHomeworks = TypeHomework(u["id"], u["name"]);
        listTypeHomeworks.add(typeHomeworks);
        typeHomework.add(false);
      }

      return listTypeHomeworks;
    } catch (e) {}
    return [];
  }
}
