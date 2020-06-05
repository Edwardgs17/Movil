import 'package:colfunding/src/projects/controllers/ProjectQualificationController.dart';
import 'package:colfunding/src/projects/views/SeeProject.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';

class QuizOptionsDialogProject extends StatefulWidget {
  final double rating;
  final Map projectDetail;
  final bool isUser;
  final List projectQualificationData;
  final int idProjectQualification;
  final double total;

  QuizOptionsDialogProject(
      {this.rating,
      this.projectDetail,
      this.isUser,
      this.projectQualificationData,
      this.idProjectQualification,
      this.total});

  @override
  _QuizOptionsDialogProjectState createState() =>
      _QuizOptionsDialogProjectState(
          rating: this.rating,
          projectDetail: this.projectDetail,
          isUser: this.isUser,
          projectQualificationData: this.projectQualificationData,
          idProjectQualification: this.idProjectQualification,
          totalProm: this.total);
}

class _QuizOptionsDialogProjectState extends State<QuizOptionsDialogProject> {
  bool processing;
  double rating;
  Map projectDetail;
  bool isUser;
  List projectQualificationData;
  SeeProjectController seeProjectController;
  Session session;
  Map user = {};
  int id;
  int idProjectQualification;
  double totalProm;

  _QuizOptionsDialogProjectState(
      {this.rating,
      this.projectDetail,
      this.isUser,
      this.projectQualificationData,
      this.idProjectQualification,
      this.totalProm}) {
    session = new Session();
    seeProjectController = new SeeProjectController();

    // print(idProjectQualification);
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
                    final route = MaterialPageRoute(builder: (context) {
                      return SeeProject(
                        projectDetail: projectDetail,
                        isUser: isUser,
                      );
                    });
                    Navigator.pushAndRemoveUntil(
                      context,
                      route,
                      ModalRoute.withName('SideBarLayout'),
                    );
                  },
                ),
              )),
          SizedBox(height: 20.0),
          Text("¿Esta seguro que quieres calificarlo de esta manera?",
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
              projectQualificationController =
                  new ProjectQualificationController();
              user = await session.getInformation();

              if (projectQualificationData.length < 1) {
                projectQualificationController.createProjectQualification(
                    context, {
                  'idUser': user["id"],
                  'idProject': projectDetail['id'],
                  'stars': rating
                });
                final route = MaterialPageRoute(builder: (context) {
                  return SeeProject(
                    projectDetail: projectDetail,
                    isUser: isUser,
                  );
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  route,
                  ModalRoute.withName('SideBarLayout'),
                );
              } else {
                projectQualificationController.updateProjectQualification(
                    idProjectQualification, {
                  'idUser': user["id"],
                  'idProject': projectDetail['id'],
                  'stars': rating
                });
                final route = MaterialPageRoute(builder: (context) {
                  return SeeProject(
                    projectDetail: projectDetail,
                    isUser: isUser,
                  );
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  route,
                  ModalRoute.withName('SideBarLayout'),
                );
              }
            },
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
