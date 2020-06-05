import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/providiers/ListHomeworkProcessProvider.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import './DeliveriesOne.dart' as first;
import './DeliveriesTwo.dart' as second;
import './DeliveriesThird.dart' as third;

class Deliveries extends StatefulWidget {
  final List homeworkDetailData;
  final List homeworkDetailData2;
  final List homeworkDetailData3;
  final bool isUser;
  final int idHomework;

  Deliveries(
      {this.homeworkDetailData,
      this.isUser,
      this.homeworkDetailData2,
      this.homeworkDetailData3,
      this.idHomework});

  @override
  MyTabsState createState() => new MyTabsState(
      homeworkDetailData: this.homeworkDetailData,
      isUser: this.isUser,
      homeworkDetailData2: this.homeworkDetailData2,
      homeworkDetailData3: this.homeworkDetailData3,
      idHomework: this.idHomework);
}

class MyTabsState extends State<Deliveries>
    with SingleTickerProviderStateMixin {
  HomeworkController homeworkController;
  Token token;
  Session session;
  List homeworkDetailData;
  List homeworkDetailData2;
  List homeworkDetailData3;
  int idHomework;
  ListHomeworkProcessProvider listHomeworkProcessProvider;
  int idProject;
  final bool isUser;
  TabController controller;

  MyTabsState(
      {this.homeworkDetailData,
      this.isUser,
      this.homeworkDetailData2,
      this.homeworkDetailData3,
      this.idHomework
      }) {
    homeworkController = HomeworkController();
    token = Token();
    session = Session();
    token.getNumber('idProject').then((id) {
      idProject = id;
      print("->>>>>>>>>>>>>>>>>$idProject");
    });
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
                "Entregas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  homeworkController.getHomeworkDatails(
                    context, idProject, isUser
                  );
                }
              ),
              actions: <Widget>[
                isUser ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton.icon(
                    color: Colors.green[400],
                    textColor: Colors.white,
                    splashColor: Colors.green[300],
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    
                    label: Text('Subir',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
                    ),
                    icon: Icon(Icons.file_upload),
                    onPressed: () => Navigator.pushNamed(context, 'CreateDeliverie'),
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
                       new third.DeliverieThird(
                          isUser: this.isUser,
                          homeworkDetailData3: [],
                          idHomework: this.idHomework,
                          ),
                      new second.DeliverieTwo(
                          isUser: this.isUser,
                          homeworkDetailData2: [],
                          idHomework: this.idHomework,
                          ),
                      new first.DeliverieOne(
                          isUser: this.isUser,
                          homeworkDetailData: [],
                          idHomework: this.idHomework,
                          ),
                    ]
                  : <Widget>[
                      new third.DeliverieThird(
                          isUser: this.isUser,
                          homeworkDetailData3:  [],
                          idHomework: this.idHomework,
                          ),
                      new second.DeliverieTwo(
                          isUser: this.isUser,
                          homeworkDetailData2:  [],
                          idHomework: this.idHomework,
           ),
        ])),
    );
  }
}
