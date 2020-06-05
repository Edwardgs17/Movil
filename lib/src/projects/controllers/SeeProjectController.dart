import 'package:colfunding/src/projects/providiers/SeeProjectProvider.dart';
import 'package:colfunding/src/projects/views/SeeProject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeeProjectController {
  SeeProjectProvider seeProjectProvider;

  SeeProjectController() {
    seeProjectProvider = SeeProjectProvider();
  }

  void getProjectDatails(BuildContext context, idProject, isUser) {
    seeProjectProvider.getProjectDetails(idProject).then((res) {
      print(res);
      final route = MaterialPageRoute(builder: (context) {
        return SeeProject(
          projectDetail: res,
          isUser: isUser,
        );
      });
      Navigator.pushAndRemoveUntil(context, route, (Route<dynamic> route) {
        print(route);
        return route.isFirst;
      });
    });
  }

  Future<Map<String, dynamic>> updateProjectQualification(id, body) async {
    return await seeProjectProvider.updateProjectQualification(id, body);
  }
}
