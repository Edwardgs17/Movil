import 'package:colfunding/src/projects/providiers/ProjectQualificationProvider.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:flutter/cupertino.dart';

class ProjectQualificationController {
  ProjectQualificationProvider projectQualificationController;
  Alert alert;
  int id;

  ProjectQualificationController() {
    alert = Alert();
    projectQualificationController = ProjectQualificationProvider();
  }

  Future<List> createProjectQualification(BuildContext context, data) async {
    return await projectQualificationController
        .createProjectQualification(data);
  }

  Future<List<dynamic>> getProjectQualification(
      BuildContext contex, idUser, idProject) async {
    return await projectQualificationController.getProjectQualification(
        contex, idUser, idProject);
  }

  Future<List<dynamic>> updateProjectQualification(id, data) async {
    return await projectQualificationController.updateProjectQualification(
        id, data);
  }

  Future<List<dynamic>> getProjectQualificationByProject(
      BuildContext contex, idProject) async {
    return await projectQualificationController
        .getProjectQualificationByProject(contex, idProject);
  }
}
