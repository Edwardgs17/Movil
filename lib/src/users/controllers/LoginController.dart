import 'package:colfunding/src/Notifications/Providers/ConfigurePushNotificationsProvider.dart';
import 'package:colfunding/src/Notifications/Providers/NotificationsProvider.dart';
import 'package:colfunding/src/users/providiers/LoginProvidier.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginController{

  LoginProvidier loginProvidier;
  NotificationsProvider notificationsProvider;
  PushNotificationProvider pushNotificationProvider;
  Alert alert;
  Session session;
  Token token;
  LoginController(){ 
    alert=Alert();
    loginProvidier = LoginProvidier();
    pushNotificationProvider = PushNotificationProvider();
    notificationsProvider = NotificationsProvider();
    session = new Session(); 
    token = Token();
  }

  void login(BuildContext context, data, cellPhoneToken) {
    loginProvidier.login(data).then((res){
      print('##########################');
      if(res!=null){
        print('##########################');
        notificationsProvider.updateDeviceToken(res['id'], {'deviceToken':cellPhoneToken});
        print(res['id']);
        res['password'] = data['password'];
        session.start(res);
        Navigator.pushReplacementNamed(context, 'SideBarLayout');
      }else{
        alert.showSuccesAlert(context, '¡Verificar!', 'Correo y/o contraseña incorrecta', Icons.info, Colors.blue);
      }
      
    }).catchError((err)
    {
      print(err);
    });
  }
  
}