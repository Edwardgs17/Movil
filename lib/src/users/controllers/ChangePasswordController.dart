import 'package:colfunding/src/users/providiers/ChangePasswordProvider.dart';
import 'package:colfunding/utils/Alerts.dart';

import 'package:flutter/material.dart';

class ChangePasswordController {

  Alert alert;
  ChangePasswordProvider changePasswordProvider;

  ChangePasswordController() {
    alert = Alert();
    changePasswordProvider = new ChangePasswordProvider();
  }

  showAlert(context, String title, String message, IconData icon, Color color) {
    alert.showAlert(context, title, message, icon, color);
  }

  Future<Map<String, dynamic>> changePassword (email, body) async {
    return await changePasswordProvider.changePassword(email, body);
  }
}