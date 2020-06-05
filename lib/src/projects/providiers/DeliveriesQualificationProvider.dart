import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class DeliveriesQualificationProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
  List<dynamic> deliveriesQualificationData = [];
  List<dynamic> deliveriesQualificationByIdDeliveriesData = [];

  DeliveriesQualificationProvider() {
    http = HttpClient();
  }

  Future<List> createDeliveriesQualification(data) async {
    List res;
    try {
      Response response =
          await http.post('$_url/projects/deliveriesQualification', data);
      res = jsonDecode(response.body);
      return res;
    } catch (e) {
      return null;
    }
  }

  Future<List> getDeliveriesQualification(idUser, idDeliveries) async {
    try {
      Response response = await http.get(
          '$_url/projects/deliveriesQualification/user/$idUser/deliveries/$idDeliveries');

      deliveriesQualificationData = json.decode(response.body);
      return deliveriesQualificationData;
    } catch (err) {
      return null;
    }
  }

  Future<List> updateDeliveriesQualification(id, data) async {
    List res;

    try {
      Response response =
          await http.put('$_url/projects/deliveriesQualification/$id', data);
      res = jsonDecode(response.body);

      return res;
    } catch (err) {
      return null;
    }
  }

  Future<List> getDeliveriesQualificationByIdDeliveries(idDeliveries) async {
    try {
      Response response = await http
          .get('$_url/projects/deliveriesQualification/deliveries/$idDeliveries');

      deliveriesQualificationByIdDeliveriesData = json.decode(response.body);
      return deliveriesQualificationByIdDeliveriesData;
    } catch (err) {
      return null;
    }
  }
}