import 'package:animate_do/animate_do.dart';
import 'package:colfunding/src/projects/controllers/ListHomeworkProcessController.dart';
import 'package:colfunding/src/projects/views/StarPressedHomework.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class StarsContentHomework extends StatefulWidget {
  final List<dynamic> homeworkQualificationData;
  final List<dynamic> homeworkQualificationByHomeworkData;
  final Map homeworkDetail;
  final double rating;
  final int idHomeworkQualification;

  StarsContentHomework(
      {this.homeworkDetail,
      this.rating,
      this.homeworkQualificationData,
      this.homeworkQualificationByHomeworkData,
      this.idHomeworkQualification});

  @override
  _StarsContentHomeworkState createState() => _StarsContentHomeworkState(
      homeworkDetail: this.homeworkDetail,
      homeworkQualificationData: this.homeworkQualificationData,
      homeworkQualificationByHomeworkData:
          this.homeworkQualificationByHomeworkData,
      rating: this.rating,
      idHomeworkQualification: this.idHomeworkQualification);
}

class _StarsContentHomeworkState extends State<StarsContentHomework> {
  int sumRatingFive = 0;
  int sumRatingFour = 0;
  int sumRatingThree = 0;
  int sumRatingTwo = 0;
  int sumRatingOne = 0;
  List<dynamic> homeworkQualificationData;
  List<dynamic> homeworkQualificationByHomeworkData;
  Map homeworkDetail;
  double rating;
  int idHomeworkQualification;
  var prom = [];
  ListHomeworkProcessController listHomeworkProcessController;

  _StarsContentHomeworkState(
      {this.homeworkDetail,
      this.homeworkQualificationData,
      this.rating,
      this.homeworkQualificationByHomeworkData,
      this.idHomeworkQualification}) {
    listHomeworkProcessController = new ListHomeworkProcessController();
    for (var data in homeworkQualificationByHomeworkData) {
      _rating(data["stars"]);
      prom.add(data["stars"]);
    }
    print("por aca");
    print(rating);
  }

  _rating(int stars) {
    switch (stars) {
      case 1:
        sumRatingOne++;
        break;
      case 2:
        sumRatingTwo++;
        break;
      case 3:
        sumRatingThree++;
        break;
      case 4:
        sumRatingFour++;
        break;
      case 5:
        sumRatingFive++;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      delay: Duration(milliseconds: 150),
      child: Container(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    int suma = sumRatingOne +
        sumRatingTwo +
        sumRatingThree +
        sumRatingFour +
        sumRatingFive;
    return SingleChildScrollView(
        child: Container(
            child: Column(children: <Widget>[
      SizedBox(
        height: 25.0,
      ),
      _totalStars(),
      Divider(
        color: Colors.black26,
      ),
      _star(),
      SizedBox(
        height: 19.0,
      ),
      Divider(
        color: Colors.black26,
      ),
      ListTile(
        leading: Icon(
          Icons.group_add,
        ),
        title: Text("Total de calificaciones",
            style: TextStyle(
              fontWeight: FontWeight.w300,
            )),
        trailing: Text('$suma',
            style: TextStyle(
              fontWeight: FontWeight.w300,
            )),
      ),
      _progress(),
    ])));
  }

  String totalProm = '0.0';
  double promQualification = 0.0;

  Widget _totalStars() {
    int sum = 0;
    double p = 0;

    for (var i = 0; i < prom.length; i++) {
      sum = sum + prom[i];
    }

    p = sum / prom.length;

    if (p.toString() == 'NaN') {
      p = 0;
    }

    totalProm = p.toStringAsFixed(1);

    String actualProm = homeworkDetail["homeworks"]["qualification"].toString();
    int idHomework = homeworkDetail["homeworks"]["id"];

    double dd = double.parse(actualProm);

    setState(() {
      if (p != 0.0) {
        if (p != dd) {
          promQualification = p;
          listHomeworkProcessController
              .updateHomeworkQualification(idHomework, {'qualification': p});
        }
      }
    });

    return ListTile(
        leading: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Icon(
            Icons.star,
          ),
        ),
        title: Text("Calificación",
            style: TextStyle(
              fontWeight: FontWeight.w300,
            )),
        trailing: Column(children: <Widget>[
          Text(totalProm == 'NaN' ? '0.0' : totalProm,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0)),
          SmoothStarRating(
              size: 22,
              borderColor: Colors.grey[600],
              color: Colors.yellow[800],
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: false,
              rating: p),
        ]));
  }

  Widget _star() {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 27.0),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Valora esta tarea",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text("Da tu calificación para los demás",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 14)),
                          SizedBox(
                            height: 18.0,
                          ),
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
                                if (rating > 0) {
                                  _categoryPressed(context);
                                }
                              });
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ])))));
  }

  Widget _progress() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 14.0,
          ),
          Row(children: <Widget>[
            Text("5",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              width: 2.0,
            ),
            Icon(Icons.star, color: Colors.yellow[800]),
            SizedBox(
              width: 3.0,
            ),
            new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 110,
              animation: true,
              lineHeight: 14.0,
              animationDuration: 2500,
              percent: 0.1 / 64 * 2 * 2 * 2 * sumRatingFive.toDouble(),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
            Text('$sumRatingFive',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ))
          ]),
          SizedBox(
            height: 3.0,
          ),
          Row(children: <Widget>[
            Text("4",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              width: 2.0,
            ),
            Icon(Icons.star, color: Colors.yellow[800]),
            SizedBox(
              width: 3.0,
            ),
            new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 110,
              animation: true,
              lineHeight: 14.0,
              animationDuration: 2500,
              percent: 0.1 / 64 * 2 * 2 * 2 * sumRatingFour.toDouble(),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
            Text('$sumRatingFour',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ))
          ]),
          SizedBox(
            height: 3.0,
          ),
          Row(children: <Widget>[
            Text("3",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              width: 2.0,
            ),
            Icon(Icons.star, color: Colors.yellow[800]),
            SizedBox(
              width: 3.0,
            ),
            new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 110,
              animation: true,
              lineHeight: 14.0,
              animationDuration: 2500,
              percent: 0.1 / 64 * 2 * 2 * 2 * sumRatingThree.toDouble(),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
            Text('$sumRatingThree',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ))
          ]),
          SizedBox(
            height: 3.0,
          ),
          Row(children: <Widget>[
            Text("2",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              width: 2.0,
            ),
            Icon(Icons.star, color: Colors.yellow[800]),
            SizedBox(
              width: 3.0,
            ),
            new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 110,
              animation: true,
              lineHeight: 14.0,
              animationDuration: 2500,
              percent: 0.1 / 64 * 2 * 2 * 2 * sumRatingTwo.toDouble(),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
            Text('$sumRatingTwo',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ))
          ]),
          SizedBox(
            height: 3.0,
          ),
          Row(children: <Widget>[
            Text("1",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              width: 2.0,
            ),
            Icon(Icons.star, color: Colors.yellow[800]),
            SizedBox(
              width: 3.0,
            ),
            new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 110,
              animation: true,
              lineHeight: 14.0,
              animationDuration: 2500,
              percent: 0.1 / 64 * 2 * 2 * 2 * sumRatingOne.toDouble(),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
            Text('$sumRatingOne',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ))
          ]),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialogHomework(
            rating: rating,
            homeworkDetailData: homeworkDetail,
            homeworkQualificationData: homeworkQualificationData,
            idHomeworkQualification: idHomeworkQualification,
            total: totalProm),
        onClosing: () {},
      ),
    );
  }
}
