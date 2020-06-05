import 'dart:convert';

import 'package:colfunding/utils/HttpClient.dart';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
class CreateHomeWorkProvidiers{
   HttpClient http;
    String uri;
  CreateHomeWorkProvidiers(){
     uri = ConfigUri().getUri();
    http = HttpClient();
  }
  Future<Map> createHomeWork(data) async{
    Map res;
   try {
     Response response = await http.post('$uri/projects/homework', data);
     res = jsonDecode(response.body);
     return res;
   } catch (e) {

     return null;
   }
  }
    Future<Map> createImageHomeWork(data) async{
    Map res;
   try {
     Response response = await http.post('$uri/projects/homework/image', data);
     res = jsonDecode(response.body);
     return res;
   } catch (e) {

     return null;
   }
  }
}