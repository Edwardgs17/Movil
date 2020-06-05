
import 'dart:convert';
import 'package:colfunding/utils/Token.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  Token token;
  HttpClient(){
    token= new Token();
  }
  Future<http.Response> get(uri) async{
   
    String token =  await this.token.getToken();
    return  http.get(uri, headers: {"token":token});
  }

  Future<http.Response> post(uri,body)  async{
    body = json.encode(body);
     String token =  await this.token.getToken();
    return  http.post( uri,headers: {"Content-Type": "application/json","token":token}, body:body );
  }

  Future<http.Response> put(uri, body) async{
    body = json.encode(body);
    String token =  await this.token.getToken();
    return  http.put( uri,headers: {"Content-Type": "application/json", "token": token}, body:body );
  }

  Future<http.Response> delete(uri)async {
     String token =  await this.token.getToken();
    return  http.delete(uri,headers: {"token":token},);
  }

}  