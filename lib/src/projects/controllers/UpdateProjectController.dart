import 'package:colfunding/src/projects/models/target_models.dart';
import 'package:colfunding/src/projects/providiers/UpdateProjectProvider.dart';
import 'package:flutter/material.dart';


class UpdateProjectController{
  UpdateProjectProvidier updateProjectProvidier;
  UpdateProjectController(){
    updateProjectProvidier = UpdateProjectProvidier();
  }

  Future<Map> getProjectInformation(id)async{
    return await updateProjectProvidier.getProjectInformation(id);
  }

  Future<Map> updateProject(context,id,data) async {
    return await updateProjectProvidier.updateProject(id, data);
  }

  Future<List<TargetAudiences>> listTargetAudience(BuildContext context) async {
    List<TargetAudiences> targetAudiences = await updateProjectProvidier.loadTargetAudience(context);
    return targetAudiences;
  }
}