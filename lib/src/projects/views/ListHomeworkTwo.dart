import 'package:colfunding/utils/PhotoView.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:colfunding/src/projects/controllers/DeliveriesController.dart';
import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/ListHomeworkProcessController.dart';
import 'package:expandable/expandable.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListHomeworkTwo extends StatefulWidget {
  final List homeworkDetailData2;
  final int idProject;
  final bool isUser;
  ListHomeworkTwo({this.homeworkDetailData2, this.isUser, this.idProject});

  @override
  _HomeworkState createState() => _HomeworkState(
        homeworkDetailData: this.homeworkDetailData2,
        isUser: this.isUser,
        idProject: this.idProject,
      );
}

class _HomeworkState extends State<ListHomeworkTwo> {
  HomeworkController homeworkController;
  ListHomeworkProcessController listHomeworkProcessController;
  List homeworkDetailData;
  int idProject;
  final bool isUser;
  Session session;
  DateTime date, todayDate;
  DeliveriesController deliveriesController;
  Token token;

  String note =
      'Al lanzar la tarea, estará en un estado de revisión durante un mes. Al finalizar, cambiara su estado (Edición => Revisión => Aprobado) dependiendo de la calificación que le den los usuarios.';

  _HomeworkState({this.homeworkDetailData, this.isUser, this.idProject}) {
    homeworkController = HomeworkController();
    listHomeworkProcessController = ListHomeworkProcessController();
    session = Session();
    token = Token();
    getHomeworks();

    deliveriesController = DeliveriesController();
    print('------->info : $homeworkDetailData');
    print(idProject);
  }

  Future getHomeworks() async {
    List<dynamic> data = await listHomeworkProcessController
        .getListHomeworkProcessTwo(context, this.idProject);

    await session.renovate();

    print('list homework');

    if (!mounted) return;

    setState(() {
      homeworkDetailData = data;
    });

    return homeworkDetailData;
  }

  Future getProjects() async {
    print('hola');
    print(homeworkDetailData.length);
    for (var homeworks in homeworkDetailData) {
      print(homeworks);
      setState(() {});
      return homeworkDetailData;
    }
  }

  Color myColorGrey = Color(0xfff2f5f8),
      myColorBlue = Colors.blue[800],
      lightText = Color(0xff8891a4);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: _homework(),
      ),
    );
  }

  Widget _homework() {
    return RefreshIndicator(
      onRefresh: getHomeworks,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 20),
        itemCount: homeworkDetailData.length,
        itemBuilder: (context, index) =>
          _cardTipo1(context, homeworkDetailData[index]),
      )
    );
  }

  Widget _createCarousel(List<dynamic> images) {
    return Container(
        height: 350,
        padding: EdgeInsets.all(16),
        child: Swiper(
          itemCount: images == null ? 0 : images.length,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: GestureDetector(
                onTap: () {
                  final route = MaterialPageRoute(builder: (context) {
                    return PhotoViewPage(images: images, tittle: 'Imagenes tarea',);
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
          viewportFraction: 0.5,
          scale: 0.8,
          control: SwiperControl(color: Colors.white),
        ));
  }

  Widget _cardTipo1(BuildContext context, dynamic homework) {
    String titleLimit = 'Fecha límite';
    String launchAt = homework["homeworks"]["launch_at"];
    int idHomework = homework["homeworks"]["id"];
    String message = '';
    DateTime convertUpdatedAt;
    String messageLaunch = 'Debe lanzar el proyecto';

    if (homework["homeworks"]["processHomework"] == 2) {
      convertUpdatedAt = DateTime.parse(launchAt);
      messageLaunch = formatDate(convertUpdatedAt, [
        d,
        '-',
        M,
        '-',
        yyyy,
      ]);

      todayDate = DateTime.now();

      Duration diference = todayDate.difference(convertUpdatedAt);

      int result = 0;

      if (diference.isNegative != true) {
        if (diference.inHours > 24) {
          result = 31 - diference.inDays;
          message = 'Faltan ' + result.toString() + ' Días';

          if (diference.inDays == 31 &&
              homework["homeworks"]["qualification"] >= 3.0) {
            listHomeworkProcessController.updateHomeworkToAproved(
                idHomework, {'launch_at': todayDate.toString()});

            message = 'Expirado';
          } else {
            if (diference.inDays == 31 &&
                homework["homeworks"]["qualification"] < 3.0) {
              listHomeworkProcessController.updateHomeworkToEdition(
                  idHomework, {'launch_at': todayDate.toString()});

              message = 'Corriga y vuelva a lanzar su tarea';
            }
          }
        } else {
          if (diference.inHours <= 23) {
            result = 1;
            message = 'Falta ' + result.toString() + ' Mes';
          }
        }
      } else {
        Duration positiveDiference = -(diference);

        if (positiveDiference.inHours >= 24) {
          result = 31 - positiveDiference.inDays;
          message = 'Faltan ' + result.toString() + ' Días';

          if (positiveDiference.inDays == 31 &&
              homework["homeworks"]["qualification"] >= 3.0) {
            listHomeworkProcessController.updateHomeworkToAproved(
                idHomework, {'launch_at': todayDate.toString()});

            message = 'Expirado';
          } else {
            if (positiveDiference.inDays == 31 &&
                homework["homeworks"]["qualification"] < 3.0) {
              listHomeworkProcessController.updateHomeworkToEdition(
                  idHomework, {'launch_at': todayDate.toString()});

              message = 'Corriga y vuelva a lanzar su tarea';
            }
          }
        } else {
          if (positiveDiference.inHours <= 23) {
            result = 1;
            message = 'Falta ' + result.toString() + ' Mes';
          }
        }
      }
    } else {
      if (homework["homeworks"]["processHomework"] == 3) {
        messageLaunch = 'Expiró';
        message = 'Expiró';
      } else {
        message = 'Debe lanzar el proyecto';
      }
    }

    final card = Container(
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: 15.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Text(
                        homework["homeworks"]["name"],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              child: _createCarousel(homework["imagesHomework"])),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: _titleSection(homework),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Valor óptimo: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              r'$',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                            Flexible(
                              child: Text(
                                '${homework["homeworks"]["optimal_cost"]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Valor mínimo: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              r'$',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                            Flexible(
                              child: Text(
                                '${homework["homeworks"]["minimal_cost"]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Fecha de lanzamiento',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          messageLaunch,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          titleLimit,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          message,
                          textAlign: TextAlign.end,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpandablePanel(
                  theme: ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center
                  ),
                  header: Text(
                    'Nota',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                      
                  collapsed: Text(
                    "$note",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Text(
                    "$note",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          _star(homework),
          Divider(
            color: Colors.black26,
          ),
          _deliveries(homework)
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 10.0))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: card,
      ),
    );
  }

  Widget _titleSection(dynamic homework) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
      child: Column(
        children: [
          ExpandablePanel(
            theme: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center
            ),
            header: Text(
              'Descripción',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),     
            collapsed: Text(
              "${homework['homeworks']["description"]}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            expanded: Text(
              "${homework['homeworks']["description"]}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              softWrap: true,
            ),
          ),

          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }

  Widget _star(dynamic homework) {
    return GestureDetector(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.star,
            ),
          ),
          title: Text("Calificaciones",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
          ),
        ),
        onTap: () {
          session.setMap('homeworkDetail', homework);
          Navigator.popAndPushNamed(context, 'StarsHomeworks');
        });
  }

  Widget _deliveries(dynamic homework) {
    return GestureDetector(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.assignment,
            ),
          ),
          title: Text("Entregas",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
          ),
        ),
        onTap: () {
          token.setNumber('idHomework', homework["homeworks"]["id"]);
          print('#############################################');
          print(homework["homeworks"]["id"]);
          print('#############################################');
          token.setBool('isUser', isUser);
          deliveriesController.getDeliveriesDatails(
              context, homework["homeworks"]["id"], isUser);
        });
  }
}
