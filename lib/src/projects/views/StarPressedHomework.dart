import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/HomeworkQualificationController.dart';
import 'package:colfunding/src/projects/controllers/ProjectQualificationController.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class QuizOptionsDialogHomework extends StatefulWidget {
  final double rating;
  final Map homeworkDetailData;
  final List<dynamic> homeworkQualificationData;
  final int idHomeworkQualification;
  final String total;

  QuizOptionsDialogHomework(
      {this.rating,
      this.homeworkDetailData,
      this.homeworkQualificationData,
      this.idHomeworkQualification,
      this.total});

  @override
  _QuizOptionsDialogHomeworkState createState() =>
      _QuizOptionsDialogHomeworkState(
          rating: this.rating,
          homeworkDetailData: this.homeworkDetailData,
          homeworkQualificationData: this.homeworkQualificationData,
          idHomeworkQualification: this.idHomeworkQualification,
          totalProm: this.total);
}

class _QuizOptionsDialogHomeworkState extends State<QuizOptionsDialogHomework> {
  bool processing;
  double rating;
  Map homeworkDetailData;
  List<dynamic> homeworkQualificationData;
  Session session;
  Map user = {};
  HomeworkQualificationController homeworkQualificationController;
  int idHomeworkQualification;
  HomeworkController homeworkController;
  String totalProm;

  _QuizOptionsDialogHomeworkState(
      {this.rating,
      this.homeworkDetailData,
      this.homeworkQualificationData,
      this.idHomeworkQualification,
      this.totalProm}) {
    print(totalProm);

    session = new Session();
    homeworkController = new HomeworkController();
  }

  ProjectQualificationController projectQualificationController;

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
                    Navigator.popAndPushNamed(context, 'StarsHomeworks');
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

                      print(rating);
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
              homeworkQualificationController =
                  new HomeworkQualificationController();

              user = await session.getInformation();

              if (homeworkQualificationData.length < 1) {
                homeworkQualificationController
                    .createHomeworkQualification(context, {
                  'idUser': user["id"],
                  'idHomework': homeworkDetailData['homeworks']['id'],
                  'stars': rating
                });

                Navigator.popAndPushNamed(context, 'StarsHomeworks');
              } else {
                homeworkQualificationController
                    .updateHomeworkQualification(idHomeworkQualification, {
                  'idUser': user["id"],
                  'idHomework': homeworkDetailData['homeworks']['id'],
                  'stars': rating
                }).then((res) {
                  Navigator.popAndPushNamed(context, 'StarsHomeworks');
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
