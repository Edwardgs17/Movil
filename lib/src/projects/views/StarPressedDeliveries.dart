import 'package:colfunding/src/projects/controllers/DeliveriesController.dart';
import 'package:colfunding/src/projects/controllers/DeliveriesQualificationController.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class QuizOptionsDialogDeliveries extends StatefulWidget {
  final double rating;
  final Map deliveriesDetail;
  final List<dynamic> deliveriesQualificationData;
  final int idDeliveriesQualification;

  QuizOptionsDialogDeliveries(
      {this.rating,
      this.deliveriesDetail,
      this.deliveriesQualificationData,
      this.idDeliveriesQualification});

  @override
  _QuizOptionsDialogDeliveriesState createState() =>
      _QuizOptionsDialogDeliveriesState(
        rating: this.rating,
        deliveriesDetail: this.deliveriesDetail,
        deliveriesQualificationData: this.deliveriesQualificationData,
        idDeliveriesQualification: this.idDeliveriesQualification,
      );
}

class _QuizOptionsDialogDeliveriesState
    extends State<QuizOptionsDialogDeliveries> {
  double rating;
  Map deliveriesDetail;
  List<dynamic> deliveriesQualificationData;
  int idDeliveriesQualification;
  Session session;
  DeliveriesQualificationController deliveriesQualificationController;
  Map user;
  DeliveriesController deliveriesController;
  Token token;
  _QuizOptionsDialogDeliveriesState(
      {this.rating,
      this.deliveriesDetail,
      this.deliveriesQualificationData,
      this.idDeliveriesQualification}) {
    session = new Session();
    deliveriesQualificationController = new DeliveriesQualificationController();
    deliveriesController = new DeliveriesController();
    token = new Token();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5.0),
              color: Colors.grey.shade200,
              child: ListTile(
                contentPadding: EdgeInsets.only(right: 5.0),
                title: Text("Haz Tu Calificación",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    )),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, 'StarsDeliveries');
                  },
                ),
              )),
          SizedBox(height: 20.0),
          Text("¿Esta seguro que quieres calificarla de esta manera?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          SizedBox(height: 17.0),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SmoothStarRating(
                  rating: rating,
                  size: 35,
                  borderColor: Colors.grey[600],
                  color: Colors.yellow[800],
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: false,
                  spacing: 30.0,
                  onRatingChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          RaisedButton(
            child: Text("Confirmar"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.green,
            textColor: Colors.white,
            onPressed: () async {
              user = await session.getInformation();

              if (deliveriesQualificationData.length < 1) {
                deliveriesQualificationController.createDeliveriesQualification(
                    context, {
                  'idUser': user["id"],
                  'idDeliverie': deliveriesDetail['id'],
                  'stars': rating
                });
                Navigator.popAndPushNamed(context, 'StarsDeliveries');
              } else {
                deliveriesQualificationController.updateDeliveriesQualification(
                    idDeliveriesQualification, {'stars': rating}).then((url) {
                  Navigator.popAndPushNamed(context, 'StarsDeliveries');
                });
              }
            },
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
