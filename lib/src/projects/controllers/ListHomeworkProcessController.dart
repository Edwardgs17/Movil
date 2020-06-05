import 'package:colfunding/src/projects/providiers/ListHomeworkProcessProvider.dart';
import 'package:colfunding/utils/Alerts.dart';

class ListHomeworkProcessController{
  
  ListHomeworkProcessProvider listHomeworkProcessProvider;
  Alert alert;

  ListHomeworkProcessController() {
    listHomeworkProcessProvider = new ListHomeworkProcessProvider();
    alert = new Alert();
  }
 

  Future<List<dynamic>> getListHomeworkProcessOne(context,id) async {
    return await listHomeworkProcessProvider.getListHomeworkProcessOne(context,id);
  }

  Future<List<dynamic>> getListHomeworkProcessTwo(context,id) async {
    return await listHomeworkProcessProvider.getListHomeworkProcessTwo(context,id);
  }

  Future<List<dynamic>> getListHomeworkProcessThird(context,id) async {
    return await listHomeworkProcessProvider.getListHomeworkProcessThird(context, id);
  }

  Future<Map<String, dynamic>> updateHomeworkToEdition(id, body) async {
    return await listHomeworkProcessProvider.updateHomeworkToEdition(id, body);
  }
  
  Future<Map<String, dynamic>> updateHomeworkToRevision(id, body) async {
    return await listHomeworkProcessProvider.updateHomeworkToRevision(id, body);
  }

  Future<Map<String, dynamic>> updateHomeworkToAproved(id, body) async {
    return await listHomeworkProcessProvider.updateHomeworkToAproved(id, body);
  }

  Future<Map<String, dynamic>> updateHomeworkQualification(id, body) async {
    return await listHomeworkProcessProvider.updateHomeworkQualification(id, body);
  }
}