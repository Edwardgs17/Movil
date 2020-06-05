import 'package:colfunding/src/projects/providiers/DeliveriesProvider.dart';
import 'package:colfunding/utils/Alerts.dart';

class DeliveriesOneController{
  
  DeliveriesProvider deliveriesProvider;
  Alert alert;

  DeliveriesOneController() {
    deliveriesProvider = new DeliveriesProvider();
    alert = new Alert();
  }
 

  Future<List<dynamic>> getListDeliveriesProcessOne(id) async {
    return await deliveriesProvider.getListDeliverieProcessOne(id);
  }

  Future<List<dynamic>> getListDeliveriesProcessTwo(id) async {
    return await deliveriesProvider.getListDeliverieProcessTwo(id);
  }

  Future<List<dynamic>> getListDeliveriesProcessThird(id) async {
    return await deliveriesProvider.getListDeliverieProcessThird(id);
  }

  Future<Map<String, dynamic>> updateDeliverieToEdition(id, body) async {
    return await deliveriesProvider.updateDeliverieToEdition(id, body);
  }
  
  Future<Map<String, dynamic>> updateDeliverieToRevision(id, body) async {
    return await deliveriesProvider.updateDeliverieToRevision(id, body);
  }

  Future<Map<String, dynamic>> updateDeliverieToAproved(id, body) async {
    return await deliveriesProvider.updateDeliverieToAproved(id, body);
  }

  Future<Map<String, dynamic>> updateDeliverieToCancel(id, body) async {
    return await deliveriesProvider.updateDeliverieToCancel(id, body);
  }

  Future<Map<String, dynamic>> updateDeliverieQualification(id, body) async {
    return await deliveriesProvider.updateDeliverieQualification(id, body);
  }
}