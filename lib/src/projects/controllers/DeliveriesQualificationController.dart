import 'package:colfunding/src/projects/providiers/DeliveriesQualificationProvider.dart';
import 'package:flutter/cupertino.dart';

class DeliveriesQualificationController {
  DeliveriesQualificationProvider deliveriesQualificationProvider;

  DeliveriesQualificationController() {
    deliveriesQualificationProvider = DeliveriesQualificationProvider();
  }

  Future<List> createDeliveriesQualification(BuildContext context, data) async {
    return await deliveriesQualificationProvider
        .createDeliveriesQualification(data);
  }

  Future<List<dynamic>> getDeliveriesQualification(
     idUser, idDeliveries) async {
    return await deliveriesQualificationProvider.getDeliveriesQualification(
       idUser, idDeliveries);
  }

  Future<List<dynamic>> updateDeliveriesQualification(id, data) async {
    return await deliveriesQualificationProvider.updateDeliveriesQualification(
        id, data);
  }

  Future<List<dynamic>> getDeliveriesQualificationByIdDeliveries(
       idDeliveries) async {
    return await deliveriesQualificationProvider
        .getDeliveriesQualificationByIdDeliveries( idDeliveries);
  }
}
