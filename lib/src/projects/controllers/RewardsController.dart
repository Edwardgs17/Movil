import 'package:colfunding/src/projects/providiers/RewardsProvider.dart';
import 'package:colfunding/src/projects/views/Rewards.dart';
import 'package:colfunding/src/projects/views/Investments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RewardsController {

  RewardsProvider rewardsProvider;
  RewardsController() {
    rewardsProvider = RewardsProvider();
  }

  void getRewardsDatails(BuildContext context, idProject, isUser) {
    
    rewardsProvider.getRewardsDetails(idProject).then((res) {
      final route = MaterialPageRoute(builder: (context) {
        print(res);
        return Rewards(rewardsDetailData: res, isUser: isUser, idProject: idProject);
      });
      
      Navigator.pushAndRemoveUntil(context, route, (Route<dynamic> route) {
        print(route);
        return route.isFirst;
      });
      //(context, route);
    });
  }

  void getRewardsDatailsForInvest(BuildContext context, idProject) {
    rewardsProvider.getRewardsDetails(idProject).then((res) {
      print('REWARDS: >>>$res');
      final route = MaterialPageRoute(builder: (context) {
        return Investments(rewardsData: res);
      });
      Navigator.push(context, route);
    });
  }

  Future<List<dynamic>> getRewardsByIdProjects(idProject) async {
    return await rewardsProvider.getRewardsDetails(idProject);
  }
}
