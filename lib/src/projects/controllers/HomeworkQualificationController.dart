import 'package:colfunding/src/projects/providiers/HomeworkQualificationProvider.dart';
import 'package:flutter/cupertino.dart';

class HomeworkQualificationController {
  HomeworkQualificationProvider homeworkQualificationController;

  HomeworkQualificationController() {
    homeworkQualificationController = HomeworkQualificationProvider();
  }

  Future<List> createHomeworkQualification(BuildContext context, data) async {
    return await homeworkQualificationController
        .createHomeworkQualification(data);
  }

  Future<List<dynamic>> getHomeworkQualification(idUser, idHomework) async {
    return await homeworkQualificationController.getHomeworkQualification(
        idUser, idHomework);
  }

  Future<List<dynamic>> updateHomeworkQualification(id, data) async {
    return await homeworkQualificationController.updateHomeworkQualification(
        id, data);
  }

  Future<List<dynamic>> getHomeworkQualificationByHomework(idHomework) async {
    return await homeworkQualificationController
        .getHomeworkQualificationByHomework(idHomework);
  }
}
