import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/HttpClient.dart';

class LoginProvidier{
    HttpClient http;
    Alert alert;
    String uri;


  LoginProvidier(){
    uri = ConfigUri().getUri();
    http = HttpClient();
    alert = Alert();
  }
  
  Future<Map> login(data)async{
    Map users;
    try {
      Response res = await http.post('$uri/users/login', data);
      users =jsonDecode(res.body);
    } catch (err) {
      print(err);
    }  
    return users;
  }
}