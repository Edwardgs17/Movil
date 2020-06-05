import 'dart:convert';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/HttpClient.dart';
import 'package:http/http.dart';

class RecoverPasswordProvidier {
  HttpClient http;
  String uri;
  
  RecoverPasswordProvidier() {
   
    uri = ConfigUri().getUri();
    http = HttpClient();
  }

  Future<Map> recoverPassword(email,data) async {
    try {
      Response response = await http.put('$uri/users/recoverPass/$email',data);
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
  }

}