import 'package:colfunding/src/projects/providiers/MyInvestmentsProvidier.dart';


class MyInvestmentsController{

  MyInvestmentsProvidier myInvestmentsProvidier;

  MyInvestmentsController(){
    
    myInvestmentsProvidier = new MyInvestmentsProvidier();
  }

  Future<List<dynamic>> getInvestmentsByIdUser(context, id) async {
    return await myInvestmentsProvidier.getInvestmentsByIdUser(context, id);
  }
}