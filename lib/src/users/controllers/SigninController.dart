import 'package:colfunding/src/users/providiers/SigninProvidier.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninController {
  SigninProvidier signinProvidier;
  Alert alert;

  SigninController() {
    alert = Alert();
    signinProvidier = SigninProvidier();
  }

  Future<List> signin(BuildContext context, data)async {

    List registerPerson;

    // print(data['email']);
    // print(data['password']);
    await signinProvidier.signin(data).then((res) {

      registerPerson = res;
      print(registerPerson);
      if(res != null){
        alert.showSuccesAlert(
          context, 'Éxito',
          'Registro exitoso',
          Icons.check_circle,
          Colors.green
        );
        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.pushReplacementNamed(context, 'Login');
        });
      }
    })
    .catchError((err) {
      print(err);
      alert.showSuccesAlert(
        context, 'Error',
        '${err.toString()}',
        Icons.android,
        Colors.green
      );
    });

    return registerPerson;
  }
}
