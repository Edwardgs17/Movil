import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/HomeworkQualificationController.dart';
import 'package:colfunding/src/projects/views/StarsContentHomework.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

HomeworkQualificationController homeworkQualificationController =
    new HomeworkQualificationController();
Map homeworkDetail;
Session session = new Session();
Map user = {};
List<dynamic> homeworkQualificationData = new List();
List<dynamic> homeworkQualificationByHomeworkData = new List();
int idHomeworkQualification;
HomeworkController homeworkController = new HomeworkController();
int idProject;
Token token = new Token();
bool isUser;
double ratingStars = 0.0;

Future _information() async {
  user = await session.getInformation();
  idProject = await token.getNumber('idProject');
  isUser = await token.getBool('isUser');
  homeworkDetail = await session.getMap('homeworkDetail');

  homeworkQualificationData = await homeworkQualificationController
      .getHomeworkQualification(user["id"], homeworkDetail["homeworks"]["id"]);

  print(homeworkQualificationData);
  if (homeworkQualificationData.length > 0) {
    for (var data in homeworkQualificationData) {
      int result = data["stars"];
      idHomeworkQualification = data["id"];
      ratingStars = result.toDouble();
      print("perraaaaaaaaaaaaaaaaaaaaaaaa");
      print(ratingStars);
    }
  }

  homeworkQualificationByHomeworkData = await homeworkQualificationController
      .getHomeworkQualificationByHomework(homeworkDetail["homeworks"]["id"]);
}

class StarsHomework extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ratingStars =0.0;
    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text(
                "Calificación de tarea",
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
                    homeworkController.getHomeworkDatails(
                        context, idProject, isUser);
                  }),
            ),
            body: FutureBuilder(
              future: _information(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return StarsContentHomework(
                    homeworkQualificationData: homeworkQualificationData,
                    homeworkQualificationByHomeworkData:
                        homeworkQualificationByHomeworkData,
                    homeworkDetail: homeworkDetail,
                    rating: ratingStars,
                    idHomeworkQualification:idHomeworkQualification,
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

// class StarsHomework extends StatefulWidget {
//   final Map homeworkDetail;

//   StarsHomework({this.homeworkDetail});
//   @override
//   _StarsHomeworkState createState() =>
//       _StarsHomeworkState(homeworkDetail: this.homeworkDetail);
// }

// class _StarsHomeworkState extends State<StarsHomework> {

//   _StarsHomeworkState({this.homeworkDetail}) {
//     session = new Session();
//     listHomeworkProcessController = ListHomeworkProcessController();

//     homeworkQualificationController = new HomeworkQualificationController();
//   }

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//         getHomeworkQualification();
//         getHomeworkQualificationByHomework();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//
//   }

// }
