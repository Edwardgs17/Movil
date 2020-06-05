import 'dart:convert';
import 'dart:async';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/HttpClient.dart';

class SigninProvidier {

   HttpClient http;
   Alert alert;
   String uri;


  SigninProvidier(){
    uri = ConfigUri().getUri();
    http = HttpClient();
    alert = Alert();
  }
  
  Future<List> signin(data) async {
    List users;
    try {
      Response res = await http.post('$uri/users/signin', data);
      Map user = jsonDecode(res.body);
      users = [user];
    } catch (err) {
      print(err);
    }  
    return users;
  }

}