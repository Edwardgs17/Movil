import 'dart:convert';

import 'package:colfunding/utils/HttpClient.dart';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:http/http.dart';
class DeliveriesProvider{
    List<dynamic> homeworkData = [];
    HttpClient http;
    String uri;
    Session session;

  DeliveriesProvider(){
     uri = ConfigUri().getUri();
    http = HttpClient();
    session = Session();
  }
  Future<Map> createDeliveries(data) async{
    Map res;
   try {
     Response response = await http.post('$uri/projects/deliveries', data);
     res = jsonDecode(response.body);
     return res;
   } catch (e) {

     return null;
   }
  }
    Future<Map> saveImagesDeliveries(data) async{
    Map res;
   try {
     Response response = await http.post('$uri/projects/deliveries/image', data);
     res = jsonDecode(response.body);
     return res;
   } catch (e) {

     return null;
   }
  }

    Future<List<dynamic>> getListDeliverieProcessOne(homeworkId) async {
    
    Response response = await http.get('$uri/projects/$homeworkId/homeworks/deliveries/1');
    try {
      homeworkData = json.decode(response.body);
      return homeworkData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return homeworkData;
    }
  }

    Future<List<dynamic>> getListDeliverieProcessTwo(homeworkId) async {
    
    Response response = await http.get('$uri/projects/$homeworkId/homeworks/deliveries/2');
    try {
      homeworkData = json.decode(response.body);
      return homeworkData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return homeworkData;
    }
  }

  Future<List<dynamic>> getListDeliverieProcessThird(homeworkId) async {
    
    Response response = await http.get('$uri/projects/$homeworkId/homeworks/deliveries/3');
    try {
      homeworkData = json.decode(response.body);
      return homeworkData;
    } catch (e) {
      print("renovate");
      await session.renovate();
      return homeworkData;
    }
  }
  
  Future<Map<String, dynamic>> updateDeliverieToEdition(id, body) async {
    Response response = await http.put('$uri/projects/deliverie/edition/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> updateDeliverieToRevision(id, body) async {
    Response response = await http.put('$uri/projects/deliverie/revision/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> updateDeliverieToAproved(id, body) async {
    Response response = await http.put('$uri/projects/deliverie/aproved/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> updateDeliverieToCancel(id, body) async {
    Response response = await http.put('$uri/projects/deliverie/cancel/$id', body);
    try {
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }

  Future<Map<String, dynamic>> updateDeliverieQualification(id, body) async {
    try {
      Response response = await http.put('$uri/projects/deliverie/qualification/$id', body);
      Map data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e.toString());
    }
    return {};
  }
}