import 'package:colfunding/src/users/views/Login.dart';
import 'package:colfunding/src/users/providiers/RecoverPasswordProvidier.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecoverPasswordController {
  RecoverPasswordProvidier recoverPasswordProvidier;
  Alert alert;

  RecoverPasswordController() {
    recoverPasswordProvidier = RecoverPasswordProvidier();
    alert = Alert();
  }

  Future<Map> recoverPassword(email, data) async {
    return await recoverPasswordProvidier.recoverPassword(email, data);
  }

  checkEmail(context, data) async {
    if (data != null) {
      alert.emailAlert(context, 'Enviando Correo...');
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pop();

      alert.confirmEmailAlert(context, 'Correo Enviado Exitosamente');
      await Future.delayed(Duration(seconds: 2));

      final route = MaterialPageRoute(builder: (context) {
        return Login();
      });
      Navigator.push(context, route);
    } else {
      alert.simpleAlert(context, 'No se pudo enviar correo');
      Navigator.of(context).pop();
    }
  }
}
