import 'package:colfunding/src/projects/providiers/SupportedProjectsProvider.dart';


class SupportedProjectsController {
  SupportedProjectsProvider supportedProjectsProvider;

  SupportedProjectsController() {
    supportedProjectsProvider = SupportedProjectsProvider();
   }
    
    Future<List<dynamic>> getSupportedProjects(idUser) async {
    return await supportedProjectsProvider.getSupportedProjects(idUser);
  }



    }
    
