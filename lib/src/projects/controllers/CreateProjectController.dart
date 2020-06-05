import 'package:colfunding/src/projects/models/target_models.dart';
import 'package:colfunding/src/projects/providiers/createProjectProvidier.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:flutter/cupertino.dart';

class CreateProjectController {
  CreateProjectProvidier createProjectProvidier;
  Alert alert;
  int id;

  CreateProjectController() {
    alert = Alert();
    createProjectProvidier = CreateProjectProvidier();
  }

  Future<Map> createProject(BuildContext context, data) async {
    return await createProjectProvidier.createProject(data);
  }

  showAlert(context, String title, String message, IconData icon, Color color) {
    alert.showAlert(context, title, message, icon, color);
  }

  Future<bool> saveImage(BuildContext context, data) async{
    print(data);
     Map  res;
     try {
       res = await createProjectProvidier.saveImage(data);
       
       return true;
     } catch (e) {
      return false;
     }
  }

  Future<List<TargetAudiences>> listTargetAudience(BuildContext context) async {
    List<TargetAudiences> targetAudiences = await createProjectProvidier.loadTargetAudience(context);
    return targetAudiences;
  }
}
