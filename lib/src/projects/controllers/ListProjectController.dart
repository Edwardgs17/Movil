import 'package:colfunding/utils/Alerts.dart';

import '../providiers/ListProjectsProvider.dart';

class ListProjectsController{
  
  ListProjectsProvider listProjectsProvider;
  Alert alert;

  ListProjectsController() {
    listProjectsProvider = new ListProjectsProvider();
    alert = new Alert();
  }
 

  Future<List<dynamic>> getListProjects(contex) async {
    return await listProjectsProvider.getListProjects(contex);
  }

}