import 'package:colfunding/src/projects/controllers/DeliveriesController.dart';
import 'package:colfunding/src/projects/controllers/DeliveriesQualificationController.dart';
import 'package:colfunding/src/projects/views/StarsContentDeliveries.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Map deliveriesDetail;
Session session = new Session();
DeliveriesQualificationController deliveriesQualificationController =
    new DeliveriesQualificationController();
Map user;
List<dynamic> deliveriesQualificationData = new List();
List<dynamic> deliveriesQualificationByIdDeliveriesData = new List();
Token token = new Token();
DeliveriesController deliveriesController;
int idHomework;
double rating = 0.0;
int idDeliveriesQualification;
bool isUser;

Future _information() async {
  user = await session.getInformation();
  deliveriesDetail = await session.getMap('DeliveriesData');
  isUser = await token.getBool('isUser');
  idHomework = await token.getNumber('idHomework');

  deliveriesQualificationData = await deliveriesQualificationController
      .getDeliveriesQualification(user["id"], deliveriesDetail["id"]);

  for (var data in deliveriesQualificationData) {
    int result = data["stars"];
    idDeliveriesQualification = data["id"];
    rating = result.toDouble();
  }

  deliveriesQualificationByIdDeliveriesData =
      await deliveriesQualificationController
          .getDeliveriesQualificationByIdDeliveries(deliveriesDetail["id"]);
}

class StarsDeliveries extends StatelessWidget {
  DeliveriesController deliveriesController = new DeliveriesController();

  @override
  Widget build(BuildContext context) {
    rating = 0.0;
    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text(
                "Calificación de entregas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
                overflow: TextOverflow.fade,
              ),
              elevation: 0.0,
              leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    deliveriesController.getDeliveriesDatails(
                        context, idHomework, isUser);
                  }),
            ),
            body: FutureBuilder(
              future: _information(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return StarContent(
                    deliveriesQualificationData: deliveriesQualificationData,
                    deliveriesQualificationByIdDeliveriesData:
                        deliveriesQualificationByIdDeliveriesData,
                    rating: rating,
                    idDeliveriesQualification: idDeliveriesQualification,
                    deliveriesDetail: deliveriesDetail,
                  );
                } else {
                  return Center(
                      child: SpinKitFadingCube(
                    color: Colors.green,
                    size: 50.0,
                  ));
                }
              },
            )));
  }
}

// import 'package:colfunding/src/projects/controllers/DeliveriesController.dart';
// import 'package:colfunding/src/projects/controllers/DeliveriesQualificationController.dart';
// import 'package:colfunding/src/projects/views/StartsContentDelivierie.dart';
// import 'package:colfunding/utils/Session.dart';
// import 'package:colfunding/utils/Token.dart';
// import 'package:flutter/material.dart';

// class StarsDeliveries extends StatefulWidget {
//   @override
//   _StarsDeliveriesState createState() => _StarsDeliveriesState();
// }

// class _StarsDeliveriesState extends State<StarsDeliveries> {

//   Map deliveriesDetail;
//   Session session;
//   DeliveriesQualificationController deliveriesQualificationController;
//   Map user;
//   List<dynamic> deliveriesQualificationData = new List();
//   List<dynamic> deliveriesQualificationByIdDeliveriesData = new List();
//   var prom = [];
//   Token token;
//   DeliveriesController deliveriesController;
//   int idHomework;
//   bool isUser;

//   _StarsDeliveriesState() {
//     session = new Session();
//     deliveriesQualificationController = new DeliveriesQualificationController();
//     token = new Token();
//     deliveriesController = new DeliveriesController();
//   }

//   Future _information() async {
//     user = await session.getInformation();
//     deliveriesDetail = await session.getMap('DeliveriesData');
//     idHomework = await token.getNumber('idHomework');
//     isUser = await token.getBool('isUser');

//     deliveriesQualificationData =
//         await deliveriesQualificationController.getDeliveriesQualification(
//             context, user["id"], deliveriesDetail["id"]);

//     deliveriesQualificationByIdDeliveriesData =
//         await deliveriesQualificationController
//             .getDeliveriesQualificationByIdDeliveries(
//                 context, deliveriesDetail["id"]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.green,
//               title: Text(
//                 "Calificación de entregas",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 25,
//                   fontWeight: FontWeight.w300,
//                 ),
//                 overflow: TextOverflow.fade,
//               ),
//               elevation: 0.0,
//             ),
//             body: FutureBuilder(
//               future: _information(),
//               builder: (BuildContext context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return StarContent(deliveriesQualificationData,
//                       deliveriesQualificationByIdDeliveriesData);
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             )));
//   }
// }
