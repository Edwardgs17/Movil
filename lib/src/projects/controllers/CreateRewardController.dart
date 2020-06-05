import 'package:colfunding/src/projects/providiers/CreateRewardProvidier.dart';

class CreateRewardController {
  CreateRewardProvidier createRewardProvidier;

  CreateRewardController(){
    createRewardProvidier = CreateRewardProvidier();
  }
  Future<Map> createReward(data) async{
    Map res;
    try {
     res = await createRewardProvidier.createReward(data);
      return res;
    } catch (e) {
      return res;
    }
  }

    Future<bool> createImageReward(data) async{
    print(data);
    Map res;
    try {
      
     res = await createRewardProvidier.createImageReward(data);
      return true;
    } catch (e) {
      return false;
    }
  }

}