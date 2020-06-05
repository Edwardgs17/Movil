import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/InvestmentsController.dart';
import 'package:colfunding/src/projects/controllers/ProjectQualificationController.dart';
import 'package:colfunding/src/projects/controllers/RewardsController.dart';
import 'package:colfunding/src/projects/controllers/UpdateProjectController.dart';
import 'package:colfunding/src/projects/controllers/deleteProjectController.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/src/projects/views/Chart.dart';
import 'package:colfunding/src/projects/views/UpdateProject.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/src/projects/views/StarPressedProject.dart';
import 'package:colfunding/utils/PhotoView.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SeeProject extends StatefulWidget {
  final Map projectDetail;
  final bool isUser;
  SeeProject({this.projectDetail, this.isUser});

  @override
  _SeeProjectState createState() =>
      _SeeProjectState(projectDetail: this.projectDetail, isUser: this.isUser);
}

class _SeeProjectState extends State<SeeProject> {
  int _selectedIndex = 0;
  Map projectDetail;
  String firstHalfDescription;
  String secondHalfDescription;
  String firstHalfObjectives;
  String secondHalfObjectives;
  bool flagDescription = true;
  bool flagObjectives = true;
  Map user = {};
  Session session;
  final bool isUser;
  HomeworkController homeworkController;
  RewardsController rewardsController;
  InvestmentsController investmentsController;
  UpdateProjectController updateProjectController;
  DeleteProjectController deleteProjectController;
  SeeProjectController seeProjectController;
  Alert alert;

  Token token;

  ProjectQualificationController projectQualificationController;
  double rating = 0.00;
  int sumRatingFive = 0;
  int sumRatingFour = 0;
  int sumRatingThree = 0;
  int sumRatingTwo = 0;
  int sumRatingOne = 0;
  var prom = [];

  List<dynamic> projectQualificationData = new List();
  List<dynamic> projectQualificationByProjectData = new List();

  int idProjectQualification;
  _SeeProjectState({this.projectDetail, this.isUser}) {
    alert = Alert();
    session = new Session();
    token = new Token();
    homeworkController = HomeworkController();
    rewardsController = RewardsController();
    seeProjectController = SeeProjectController();
    investmentsController = InvestmentsController();
    updateProjectController = UpdateProjectController();
    deleteProjectController = DeleteProjectController();
    token.setNumber('idUserProject', projectDetail['idUser']);
    token.setString('process', projectDetail['process']);
    token.setBool('financing', projectDetail['financing']);
    token.setNumber('optimal_cost', projectDetail['optimal_cost']);
    token.setNumber('minimal_cost', projectDetail['minimal_cost']);
    token.setBool('isUser', isUser);
    if (projectDetail["description"].length > 50) {
      firstHalfDescription = projectDetail["description"].substring(0, 50);
      secondHalfDescription = projectDetail["description"]
          .substring(50, projectDetail["description"].length);
    } else {
      firstHalfDescription = projectDetail["description"];
      secondHalfDescription = "";
    }
    if (projectDetail["objectives"].length > 50) {
      firstHalfObjectives = projectDetail["objectives"].substring(0, 50);
      secondHalfObjectives = projectDetail["objectives"]
          .substring(50, projectDetail["objectives"].length);
    } else {
      firstHalfObjectives = projectDetail["objectives"];
      secondHalfObjectives = "";
    }
  }

  Future getProjectQualification() async {
    user = await session.getInformation();
    projectQualificationController = new ProjectQualificationController();
    projectQualificationData = await projectQualificationController
        .getProjectQualification(context, user["id"], projectDetail["id"]);
    for (var projectQualification in projectQualificationData) {
      int result = projectQualification["stars"];
      idProjectQualification = projectQualification["id"];
      rating = result.toDouble();
    }

    setState(() {});
    return projectQualificationData;
  }

  Future getProjectQualificationByProject() async {
    projectQualificationController = new ProjectQualificationController();
    projectQualificationByProjectData = await projectQualificationController
        .getProjectQualificationByProject(context, projectDetail["id"]);

    for (var data in projectQualificationByProjectData) {
      _rating(data["stars"]);
      prom.add(data["stars"]);
    }
    setState(() {});
    return projectQualificationByProjectData;
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
  void initState() {
    super.initState();

    setState(() {
      getProjectQualification();
      getProjectQualificationByProject();
    });
  }

  @override
  Widget build(BuildContext context) {
    int suma = sumRatingOne +
        sumRatingTwo +
        sumRatingThree +
        sumRatingFour +
        sumRatingFive;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          _createBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              _content(context),
              SizedBox(
                height: 20.0,
              ),
              _star(),
              Divider(),
              _homework(),
              Divider(
                color: Colors.black26,
              ),
              _rewards(),
              Divider(
                color: Colors.black26,
              ),
              _investments(),
              Divider(
                color: Colors.black26,
              ),
              _statistics(),
              Divider(
                color: Colors.black26,
              ),
              SizedBox(
                height: 10.0,
              ),
              _totalStars(),
              Divider(
                color: Colors.black26,
              ),
              SizedBox(
                height: 20.0,
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
              SizedBox(
                height: 20.0,
              ),
            ]),
          )
        ],
      ),
      bottomNavigationBar: isUser && projectDetail['process'] == 'Edición'
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.yellow[600],
                  ),
                  title: Text(
                    'Editar Proyecto',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Eliminar Proyecto',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                ),
              ],
              currentIndex: _selectedIndex,
              elevation: 8.0,
              onTap: (int index) {
                print(index);
                setState(() {
                  _selectedIndex = index;
                  if (index == 0) {
                    print(projectDetail);

                    final route = MaterialPageRoute(builder: (context) {
                      return UpdateProject(projectDetail: projectDetail);
                    });
                    Navigator.push(context, route);
                  } else {
                    if (index == 1) {
                      deleteProjectController
                          .deleteUserInformation(projectDetail["id"]);
                      deleteProjectController.showAlert(
                          context,
                          "Exito!",
                          "Proyecto Eliminado Con exito",
                          Icons.check_circle,
                          Colors.green);
                    }
                  }
                });
              },
            )
          : null,
    );
  }

  Widget _star() {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
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
                            "Valora este proyecto",
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
                                print(rating);
                              });
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ])))));
  }

  Widget _createCarousel(List<dynamic> images) {
    return Swiper(
      containerHeight: 500,
      itemCount: images == null ? 0 : images.length,
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          child: GestureDetector(
            onTap: () {
              final route = MaterialPageRoute(builder: (context) {
                return PhotoViewPage(images: images, tittle: 'Imagenes proyecto',);
              });
              Navigator.push(context, route);
            },
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image: images[index].toString(),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      control: SwiperControl( color: Colors.white),
      pagination: SwiperPagination(
        builder:  DotSwiperPaginationBuilder(
          color: Colors.grey.shade600,
          activeColor: Colors.white,
          size: 10.0,
          activeSize: 12.0
        )
      )
    );
  }

  Widget _createBar() {
    return Container(
      child: SliverAppBar(
          expandedHeight: 350.0,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.green,
          leading: new IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.popAndPushNamed(context, 'SideBarLayout');
            },
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: _createCarousel(projectDetail["imagesProject"]),
          ),
          actions: <Widget>[
            this.isUser
                ? InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(Icons.photo_camera),
                    ),
                    onTap: () async {
                      List<String> list = [];
                      for (var value in projectDetail["imagesProject"]) {
                        list.add(value);
                        print(value);
                      }
                      token.setNumber('idProject', projectDetail['id']);
                      token.setList('imagesProject', list);
                      Navigator.pushReplacementNamed(context, 'Gallery');
                    },
                  )
                : Container()
          ]),
    );
  }

  Widget _content(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(),
        child: Container(
            color: Colors.grey[200],
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _location(),
                          SizedBox(
                            height: 7.0,
                          ),
                          _title(),
                          SizedBox(
                            height: 15.0,
                          ),
                          _description(),
                          SizedBox(
                            height: 15.0,
                          ),
                          _descriptionDetail(),
                          SizedBox(
                            height: 20.0,
                          ),
                          objectives(),
                          SizedBox(
                            height: 15.0,
                          ),
                          _objectivesDetail(),
                          SizedBox(
                            height: 27.0,
                          ),
                          _targetAudience(),
                          SizedBox(
                            height: 27.0,
                          ),
                        ])))));
  }

  Widget _location() {
    return Container(
        child: Row(
      children: <Widget>[
        Icon(
          Icons.pin_drop,
          color: Colors.grey[400],
        ),
        SizedBox(
          width: 3.0,
        ),
        Text(
          "${projectDetail["location"]}",
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    ));
  }

  Widget _title() {
    return Container(
        child: Column(children: <Widget>[
      Text(
        "${projectDetail["title"]}",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w400,
        ),
      )
    ]));
  }

  Widget _description() {
    return Container(
        child: Row(children: <Widget>[
      SizedBox(
        height: 11,
      ),
      Text("Descripción",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
    ]));
  }

  Widget _descriptionDetail() {
    return Container(
        child: Column(children: <Widget>[
      secondHalfDescription.isEmpty
          ? Text(
              "${projectDetail["description"]}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            )
          : new Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: new Text(
                      flagDescription
                          ? (firstHalfDescription + "...")
                          : (firstHalfDescription + secondHalfDescription),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: new InkWell(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          flagDescription ? "Ver más" : "Ver menos",
                          style: new TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        flagDescription = !flagDescription;
                      });
                    },
                  ),
                )
              ],
            )
    ]));
  }

  Widget _homework() {
    return GestureDetector(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.rate_review,
            ),
          ),
          title: Text("Tareas",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
          ),
        ),
        onTap: () {
          homeworkController.getHomeworkDatails(
              context, projectDetail["id"], isUser);
        });
  }

  Widget _rewards() {
    return GestureDetector(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.monetization_on,
            ),
          ),
          title: Text("Recompensas",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
          ),
        ),
        onTap: () {
          rewardsController.getRewardsDatails(
              context, projectDetail["id"], isUser);
        });
  }

  Widget _investments() {
    return GestureDetector(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.person,
            ),
          ),
          title: Text("Inversores",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
          ),
        ),
        onTap: () {
          investmentsController.getInvestmentsDetails(
              context, projectDetail["id"]);
        });
  }

  Widget _statistics() {
    return GestureDetector(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.insert_chart,
            ),
          ),
          title: Text("Estadistica",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
          ),
        ),
        onTap: () {
          token.setNumber('optimal_cost', projectDetail["optimal_cost"]);
          final route = MaterialPageRoute(builder: (context) {
            return HomePage(idProject: projectDetail["id"]);
          });
          Navigator.push(context, route);
        });
  }

  Widget objectives() {
    return Container(
        child: Row(children: <Widget>[
      SizedBox(
        height: 11,
      ),
      Text("Objetivos",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
    ]));
  }

  Widget _objectivesDetail() {
    return Container(
        child: Column(children: <Widget>[
      secondHalfObjectives.isEmpty
          ? Text(
              "${projectDetail["objectives"]}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            )
          : new Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 79.0),
                    child: new Text(
                      flagObjectives
                          ? (firstHalfObjectives + "...")
                          : (firstHalfObjectives + secondHalfObjectives),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: new InkWell(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          flagObjectives ? "Ver más" : "Ver menos",
                          style: new TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        flagObjectives = !flagObjectives;
                      });
                    },
                  ),
                )
              ],
            )
    ]));
  }

  Widget _targetAudience() {
    return Container(
        child: Row(
      children: <Widget>[
        Icon(
          Icons.local_offer,
          color: Colors.grey[400],
        ),
        SizedBox(
          width: 3.0,
        ),
        Text(
          "${projectDetail["targetAudience"]}",
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    ));
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

  String totalProm = '0.0';
  double promQualification = 0.0;

  Widget _totalStars() {
    int sum = 0;

    for (var i = 0; i < prom.length; i++) {
      sum = sum + prom[i];
    }
    double p = sum / prom.length;

    if (p.toString() == 'NaN') {
      p = 0;
    }

    totalProm = p.toStringAsFixed(1);

    String actualProm = projectDetail["qualification"].toString();

    double dd = double.parse(actualProm);

    setState(() {
      if (p != 0.0) {
        if (p != dd) {
          promQualification = p;

          seeProjectController.updateProjectQualification(
              projectDetail['id'], {'qualification': p});
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

  _categoryPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialogProject(
            rating: rating,
            projectDetail: projectDetail,
            isUser: isUser,
            projectQualificationData: projectQualificationData,
            idProjectQualification: idProjectQualification,
            total: promQualification),
        onClosing: () {},
      ),
    );
  }
}
