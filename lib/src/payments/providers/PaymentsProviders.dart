import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/HttpClient.dart';
import 'package:http/http.dart';

class PaymentsProviders{
  HttpClient http;
  ConfigUri configUri;
  String uri;
  PaymentsProviders(){
    http= new HttpClient();
    configUri = new ConfigUri();
    uri = configUri.getUri();
  } 
  Future<String> pay(payment)async{
   Response response = await http.post('$uri/payments', payment);
   try {
    final res= jsonDecode(response.body);
    return res['link'];
   } catch (e) {
     return "";
   }
  }
  Future<bool> success(payment) async{
   
    try { 
      Response response = await http.post('$uri/payments/success',payment);
       final res= jsonDecode(response.body);
       return res['success'];
    } catch (e) {
    }
    return false;
  }

  Future<bool> payout(payout) async{
    try { 
      Response response = await http.post('$uri/payments/payout',payout);
       final res= jsonDecode(response.body);
       return res['success'];
    } catch (e) {
    }
    return false;
  }
}