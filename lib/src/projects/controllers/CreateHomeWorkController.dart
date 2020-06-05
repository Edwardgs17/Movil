import 'package:colfunding/src/projects/providiers/CreateHomeWorkProvidiers.dart';

class CreateHomeWorkController {
  CreateHomeWorkProvidiers createHomeWorkProvidiers;
  CreateHomeWorkController(){
    createHomeWorkProvidiers = CreateHomeWorkProvidiers();
  }
  Future<Map> createHomework(data) async{
    Map res;
    try {
     res = await createHomeWorkProvidiers.createHomeWork(data);
      return res;
    } catch (e) {
      return res;
    }
  }

    Future<bool> createImageHomework(data) async{
    print(data);
    Map res;
    try {
     res = await createHomeWorkProvidiers.createImageHomeWork(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}