import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:http/http.dart';
import 'package:colfunding/utils/HttpClient.dart';

class RewardsProvider {
  HttpClient http;
  String _url = ConfigUri().getUri();
  List<dynamic> rewardsData = [];

  RewardsProvider() {
    http = HttpClient();
  }

  Future<List> getRewardsDetails(idProject) async {
    try {
      Response response = await http.get('$_url/projects/rewards/$idProject');

      rewardsData = json.decode(response.body);
      return rewardsData;
    } catch (err) {
      return null;
    }
  }
}
