import 'package:colfunding/src/projects/providiers/InvestmentsProvider.dart';
import 'package:colfunding/src/projects/providiers/RewardsProvider.dart';

import 'package:colfunding/src/projects/views/Investments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestmentsController {

  RewardsProvider rewardsProvider;
  InvestmentsProvider investmentsProvider;
  InvestmentsController() {
    investmentsProvider = InvestmentsProvider();
    rewardsProvider = RewardsProvider();
  }

  void getInvestmentsDetails(BuildContext context, idProject) {
    

    investmentsProvider.getInvestmentsDetails(idProject).then((res) {
      print('DATES: >>>$res');
      final route = MaterialPageRoute(builder: (context) {
        return Investments(investmentsDetailData: res);
      });
      Navigator.push(context, route);
    });

    
  }

  Future<List<dynamic>> getInvestmentsByIdUser(context, id) async {
    return await investmentsProvider.getInvestmentsByIdUser(context, id);
  }

}