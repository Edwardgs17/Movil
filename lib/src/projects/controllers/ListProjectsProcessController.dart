import 'package:colfunding/src/projects/providiers/ListProjectsProcessProvider.dart';
import 'package:colfunding/utils/Alerts.dart';

class ListProjectsProcessController{
  
  ListProjectsProcessProvider listProjectsProcessProvider;
  Alert alert;

  ListProjectsProcessController() {
    listProjectsProcessProvider = new ListProjectsProcessProvider();
    alert = new Alert();
  }
 

  Future<List<dynamic>> getListProjectsProcess(context) async {
    return await listProjectsProcessProvider.getListProjectsProcess(context);
  }

  Future<List<dynamic>> getListProjectsProcessTwo(context) async {
    return await listProjectsProcessProvider.getListProjectsProcessTwo(context);
  }
}