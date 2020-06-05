import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:http/http.dart' as http;

import '../../../utils/HttpClient.dart';
import 'dart:convert';

class MyInvestmentsProvidier {

  List<dynamic> projectsData = [];
  HttpClient client;
  String uri;
  Session session;


  MyInvestmentsProvidier(){
   client = new HttpClient();
   uri = ConfigUri().getUri();
   session = Session();
  }

  Future<List<dynamic>> getInvestmentsByIdUser(context, id) async {
    client = new HttpClient();
    http.Response response = await client.get('$uri/investments/investments/user/$id');
    try {
      projectsData = json.decode(response.body);
      return projectsData;
    } catch (e) {
      print("Ok");
    }
    return [];
  }

}