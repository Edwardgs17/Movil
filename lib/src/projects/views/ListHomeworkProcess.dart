import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/src/projects/providiers/ListHomeworkProcessProvider.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import './ListHomeworkOne.dart' as first;
import './ListHomeworkTwo.dart' as second;
import './ListHomeworkThird.dart' as third;

class MyProcess extends StatefulWidget {
  final List homeworkDetailData;
  final List homeworkDetailData2;
  final List homeworkDetailData3;
  final int idProject;
  final bool isUser;

  MyProcess(
      {this.homeworkDetailData,
      this.isUser,
      this.homeworkDetailData2,
      this.homeworkDetailData3,
      this.idProject});

  @override
  MyTabsState createState() => new MyTabsState(
      homeworkDetailData: this.homeworkDetailData,
      isUser: this.isUser,
      idProject: this.idProject,
      homeworkDetailData2: this.homeworkDetailData2,
      homeworkDetailData3: this.homeworkDetailData3);
}

class MyTabsState extends State<MyProcess> with SingleTickerProviderStateMixin {
  HomeworkController homeworkController;
  List homeworkDetailData;
  List homeworkDetailData2;
  List homeworkDetailData3;
  int idProject;
  ListHomeworkProcessProvider listHomeworkProcessProvider;
  SeeProjectController seeProjectController;

  final bool isUser;
  TabController controller;
  Token token;

  MyTabsState(
      {this.homeworkDetailData,
      this.isUser,
      this.homeworkDetailData2,
      this.homeworkDetailData3,
      this.idProject}) {
    homeworkController = HomeworkController();
    seeProjectController = new SeeProjectController();
    print(idProject);
    print('$homeworkDetailData');
  }
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: isUser ? 3 : 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: new AppBar(
              centerTitle: true,
              title: new Text(
                "Tareas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    seeProjectController.getProjectDatails(
                        context, idProject, isUser);
                  }),
              actions: <Widget>[
                isUser
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FlatButton.icon(
                          color: Colors.green[400],
                          textColor: Colors.white,
                          splashColor: Colors.green[300],
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          label: Text(
                            'Crear',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                          icon: Icon(Icons.add),
                          onPressed: () =>
                              Navigator.pushNamed(context, 'CreateHomeWork'),
                        ),
                      )
                    : Container()
              ],
              backgroundColor: Colors.green,
              bottom: new TabBar(
                  controller: controller,
                  indicatorColor: Colors.white,
                  tabs: isUser
                      ? <Tab>[
                          new Tab(
                              icon: new Text(
                            'Aprobadas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                          new Tab(
                              icon: new Text(
                            'En Revisión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                          new Tab(
                              icon: new Text(
                            'En Edición',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                        ]
                      : <Tab>[
                          new Tab(
                              icon: new Text(
                            'Aprobadas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                          new Tab(
                              icon: new Text(
                            'En Revisión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                        ])),
          body: new TabBarView(
              controller: controller,
              children: isUser
                  ? <Widget>[
                      new third.ListHomeworkThird(
                        isUser: this.isUser,
                        homeworkDetailData3: [],
                        idProject: this.idProject
                      ),
                      new second.ListHomeworkTwo(
                        isUser: this.isUser,
                        homeworkDetailData2: [],
                        idProject: this.idProject
                      ),
                      new first.ListHomeworkOne(
                        isUser: this.isUser,
                        homeworkDetailData: [],
                        idProject: this.idProject
                      ),
                    ]
                  : <Widget>[
                      new third.ListHomeworkThird(
                        isUser: this.isUser,
                        homeworkDetailData3: [],
                        idProject: this.idProject
                      ),
                      new second.ListHomeworkTwo(
                        isUser: this.isUser,
                        homeworkDetailData2: [],
                        idProject: this.idProject
                      ),
                    ])),
    );
  }
}
