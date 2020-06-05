import 'package:colfunding/src/projects/providiers/HomeworkProvider.dart';
import 'package:colfunding/src/projects/providiers/ListHomeworkProcessProvider.dart';
import 'package:colfunding/src/projects/views/ListHomeworkProcess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/utils/Alerts.dart';

class HomeworkController {
  HomeworkProvider homeworkProvider;
  ListHomeworkProcessProvider listHomeworkProcessProvider;
  Alert alert;

  HomeworkController() {
    alert = Alert();
    homeworkProvider = HomeworkProvider();
    listHomeworkProcessProvider = ListHomeworkProcessProvider();
  }

  showAlert(context, String title, String message, IconData icon, Color color) {
    alert.showAlert(context, title, message, icon, color);
  }

  Future<List<dynamic>> getHomeworksByIdProject(int id) async {
    return await homeworkProvider.getHomeworksByIdProject(id);
  }

  Future<String> deleteHomework(int id) async {
    return await homeworkProvider.deleteHomework(id);
  }

  void getHomeworkDatails(BuildContext context, idProject, isUser) async{
    

    final rs = await listHomeworkProcessProvider.getListHomeworkProcessOne(context, idProject);
    final res = await listHomeworkProcessProvider.getListHomeworkProcessTwo(context, idProject);
    final resp = await listHomeworkProcessProvider.getListHomeworkProcessThird(context, idProject);

      final route = MaterialPageRoute(builder: (context) {
        return MyProcess(
          homeworkDetailData  : rs,
          homeworkDetailData2 : res,
          homeworkDetailData3 : resp,
          isUser: isUser,
          idProject: idProject,
        );
      });
      
      Navigator.pushAndRemoveUntil(context, route, (Route<dynamic> route) {
        print(route);
        return route.isFirst;
      });
      // Navigator.push(context, route);
   }
}
