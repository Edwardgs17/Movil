import 'dart:convert';

import 'package:colfunding/utils/HttpClient.dart';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';

class CreateRewardProvidier{
   HttpClient http;
    String uri;

  CreateRewardProvidier(){
     uri = ConfigUri().getUri();
    http = HttpClient();
  }

  Future<Map> createReward(data) async{
    Map res;
   try {
     Response response = await http.post('$uri/projects/reward', data);
     res = jsonDecode(response.body);
     return res;
   } catch (e) {

     return null;
   }
  }
    Future<Map> createImageReward(data) async{
    Map res;
   try {
     Response response = await http.post('$uri/projects/reward/image', data);
     res = jsonDecode(response.body);
     return res;
   } catch (e) {

     return null;
   }
  }
}