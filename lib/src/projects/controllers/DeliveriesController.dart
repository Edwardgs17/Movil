import 'package:colfunding/src/projects/providiers/DeliveriesProvider.dart';
import 'package:colfunding/src/projects/views/DeliveriesProcess.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:flutter/material.dart';

class DeliveriesController {

  DeliveriesProvider deliveriesProvider;
  Alert alert;

  DeliveriesController(){
    deliveriesProvider = DeliveriesProvider();
    alert = Alert();
  }
  Future<Map> createDeliveries(BuildContext context, data) async {
    return await deliveriesProvider.createDeliveries(data);
  }
    showAlert(context, String title, String message, IconData icon, Color color) {
    alert.showAlert(context, title, message, icon, color);
  }


  Future<bool> saveImagesDeliveries(BuildContext context, data) async{
    print(data);
     Map  res;
     try {
       res = await deliveriesProvider.saveImagesDeliveries(data);
       
       return true;
     } catch (e) {
      return false;
     }
  }

  void getDeliveriesDatails(BuildContext context, homeworkId, isUser) async{
    

    final rs = await deliveriesProvider.getListDeliverieProcessOne(homeworkId);
    final res = await deliveriesProvider.getListDeliverieProcessTwo(homeworkId);
    final resp = await deliveriesProvider.getListDeliverieProcessThird(homeworkId);

      final route = MaterialPageRoute(builder: (context) {
        return Deliveries(
          homeworkDetailData  : rs,
          homeworkDetailData2 : res,
          homeworkDetailData3 : resp,
          isUser: isUser,
          idHomework: homeworkId,
        );
      });
      Navigator.push(context, route);
   }
}