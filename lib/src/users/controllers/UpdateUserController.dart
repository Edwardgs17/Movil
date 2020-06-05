import 'package:colfunding/src/users/providiers/UpdateUserProvidier.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Sidebar_Layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateUserController{
  UpdateUserProvidier updateUserProvidier;
  Alert alert;
  UpdateUserController(){
    updateUserProvidier = UpdateUserProvidier();
    alert = Alert();
  }

  Future<Map> getUserInformation(email)async{
    return await updateUserProvidier.getUserInformation(email);
  }

  Future<Map> updateUser(email,data) async {
    return await updateUserProvidier.updateUser(email, data);
  }
  showAlertOne(context, String title, String message, IconData icon, Color color) {
    alert.showAlert(context, title, message, icon, color);
  }


  showAlert(context,String message){
    alert.simpleAlert(context, message);
  }
  
  checkUpdate(context,data){
    if (data!=null) {
      alert.showSuccesAlert(
        context,
        'Éxito', 'Has actualizado tus datos personales',
        Icons.check_circle, Colors.green
      );

      Future.delayed(Duration(seconds: 2)).then((value) {
        Navigator.of(context).pop();
      });
      // Navigator.of(context).pop();
      // final route = MaterialPageRoute(builder: (context) {
        
      //   return SideBarLayout();
        
      // });
      
      // Navigator.push(context, route);

    } else {
      alert.showSuccesAlert(context, 'Éxito', 'No se pudo actualizar el usuario', Icons.highlight_off, Colors.red);
      Navigator.of(context).pop();
    }
  }
}