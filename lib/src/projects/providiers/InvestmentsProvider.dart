import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class InvestmentsProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
  List<dynamic> investmentsData = [];
  List<dynamic> rewardsData = [];

  InvestmentsProvider() {
    http = HttpClient();
  }

  Future<List> getInvestmentsDetails(idProject) async {
    try {
      Response response = await http.get('$_url/investments/investments/project/$idProject');

      investmentsData = json.decode(response.body);
      return investmentsData;
    } catch (err) {
      return null;
    }
  }

  Future<List<dynamic>> getInvestmentsByIdUser(context, id) async {
    try {
      Response response = await http.get('$_url/investments/investments/user/$id');

      investmentsData = json.decode(response.body);
      return investmentsData;
    } catch (e) {
      print("Ok");
    }
    return [];
  }


}
