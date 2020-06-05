import 'package:colfunding/src/projects/models/typeHomeworkModel.dart';
import 'package:colfunding/src/projects/providiers/EditHomeworkProvider.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:flutter/cupertino.dart';

class EditHomeworkController {
  EditHomeworkProvider editHomeworkProvider;
  Alert alert;
  int id;

  EditHomeworkController() {
    alert = Alert();
    editHomeworkProvider = EditHomeworkProvider();
  }

  showAlert(context, String title, String message, IconData icon, Color color) {
    alert.showAlert(context, title, message, icon, color);
  }

  Future<List<dynamic>> updateHomework(int id, dynamic data) async {
    return await editHomeworkProvider.updateHomework(id, data);
  }

  Future<String> updateImageHomework(int id, dynamic data) async {
    return await editHomeworkProvider.updateImageHomework(id, data);
  }

  Future<List<TypeHomework>> getTypeHomeworkDropdown(BuildContext context) async {
    List<TypeHomework> typeHomeworks = await editHomeworkProvider.loadTypeHomeworkDropdown(context);
    return typeHomeworks;
  }
}
