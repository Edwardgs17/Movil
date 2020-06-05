import 'package:colfunding/src/projects/providiers/deleteProjectProvider.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:flutter/cupertino.dart';

class DeleteProjectController{
  DeleteProjectProvidier updateUserProvidier;
  Alert alert;
  DeleteProjectController(){
    updateUserProvidier = DeleteProjectProvidier();
    alert = Alert();
  }
  showAlert(context, String title, String message, IconData icon, Color color) {
    alert.showAlert(context, title, message, icon, color);
  }
  Future<Map> deleteUserInformation(id)async{
    return await updateUserProvidier.deleteProjectById(id);
  }
}