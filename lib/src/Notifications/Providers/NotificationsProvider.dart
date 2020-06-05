import 'dart:convert';

import 'package:colfunding/utils/HttpClient.dart';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';


class NotificationsProvider{

   HttpClient http;
    String uri;

  NotificationsProvider(){

    uri = ConfigUri().getUri();
    http = HttpClient();
  }
  Future<List> createDeviceToken(data) async{
    List res;
   try {
     Response response = await http.post('$uri/notifications/device', data);
     res = jsonDecode(response.body);
     return res;
   } catch (e) {

     return null;
   }

  }

    Future<List<dynamic>> getTokenByIdUser(id) async {

    List<dynamic> response;

    try {
      Response res = await http.get('$uri/notifications/devices/$id');
      response = jsonDecode(res.body);

      return response;

    } catch (err) {
      print(err);

      return [];
    }
  }

  Future<Map> sendNotifications(data)async{

    Map response;

    try {
      Response res = await http.post('$uri/notifications/device/notify', data);
      response = jsonDecode(res.body);

      return response;

    } catch (err) {
      print(err);
    }

    return null;
  }
  Future<List<dynamic>> updateDeviceToken(id, data) async {
    List deviceToken = [];

    try {
      Response res = await http.put('$uri/notifications/device/$id', data);
      deviceToken = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }

    return deviceToken;
  }
}