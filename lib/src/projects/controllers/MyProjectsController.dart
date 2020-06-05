import '../providiers/myProjectsProvidier.dart';

class MyProjectsController {
  MyProjectsProvidier myProjectsProvidier;

  MyProjectsController() {
    myProjectsProvidier = new MyProjectsProvidier();
  }

  Future<List<dynamic>> getImageByIdProjects(contex, id) async {
    return await myProjectsProvidier.getImageByIdProjects(contex, id);
  }

  Future<Map<String, dynamic>> updateProcessProject(id, body) async {
    return await myProjectsProvidier.updateProcessProject(id, body);
  }

  Future<Map<String, dynamic>> aprovedProject(id, body) async {
    return await myProjectsProvidier.aprovedProject(id, body);
  }

  Future<Map<String, dynamic>> editedProject(id, body) async {
    return await myProjectsProvidier.editedProject(id, body);
  }
}
