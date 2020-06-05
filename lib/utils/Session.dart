import 'dart:convert';
import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/HttpClient.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Session {
  String uri;
  HttpClient http;
  Token token;
  Session() {
    uri = ConfigUri().getUri();
    http = new HttpClient();
    token = new Token();
  }
  void start(body) {
    print('start session');
    token.setToken(body['token']);
    token.setString('id', body['id'].toString());
    token.setString('email', body['email']);
    token.setString('password', body['password']);
  }

  Future<Map> getInformation() async {
    final user = {
      'id': await token.getString('id'),
      'email': await token.getString('email'),
      'password': await token.getString('password'),
      'token': await token.getToken(),
    };
    return user;
  }

  Future<bool> renovate() async {
    final email = await token.getString('email');
    final password = await token.getString('password');
    //print({'email': email, 'password': password});
    if (email != '' && password != '') {
      Response response = await http
          .post('$uri/users/login', {'email': email, 'password': password});
      try {
        Map user = jsonDecode(response.body);
        user['password'] = password;
        this.start(user);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Future close(context) {
    print('close session');
    token.setToken('');
    token.setString('id', '');
    token.setString('email', '');
    token.setString('password', '');
    Token().setNumber('c', 0);
    return Navigator.pushReplacementNamed(context, 'Login');
  }

  void setMap(name, Map data) {
    String mapa = json.encode(data);
    token.setString(name, mapa);
  }

  Future<Map> getMap(name) async {
    String data = await token.getString(name);
    Map map = jsonDecode(data);
    return map;
  }
}
