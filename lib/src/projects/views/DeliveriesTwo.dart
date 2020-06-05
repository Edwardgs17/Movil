import 'package:colfunding/src/projects/controllers/DeliveriesOneController.dart';
import 'package:colfunding/src/projects/controllers/ListProjectsProcessController.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/PhotoView.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class DeliverieTwo extends StatefulWidget {
  final List homeworkDetailData2;
  final bool isUser;
  final int idHomework;
  DeliverieTwo({this.homeworkDetailData2, this.isUser, this.idHomework});
  @override
  _ListProjectsState createState() => _ListProjectsState(
        homeworkData: this.homeworkDetailData2,
        isUser: this.isUser,
        idHomework: this.idHomework,
      );
}

class _ListProjectsState extends State<DeliverieTwo> {
  List homeworkData;
  final bool isUser;
  Alert alert;
  List<dynamic> projectsData = new List();
  ListProjectsProcessController listProjectsController;
  Sidebar sidebar;
  Map user = {};
  int c, idHomework;
  Token token;
  DateTime todayDate;
  Session session;
  SeeProjectController seeProject;
  DeliveriesOneController deliveriesOneController;

  String note =
      'Al lanzar la entrega, estará en un estado de revisión durante un mes. Al finalizar, cambiara su estado (Edición => Revisión => Aprobado) dependiendo de la calificación que le den los usuarios.';

  _ListProjectsState({this.homeworkData, this.isUser, this.idHomework}) {
    this.seeProject = SeeProjectController();
    deliveriesOneController = DeliveriesOneController();
    session = new Session();
    c = 0;
    token = new Token();
    sidebar = Sidebar(
      page: 2,
    );
    getDeliveries();
    print('INFO DELIVERIES TWO');
    print(idHomework.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _homework(),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Future getDeliveries() async {
    List<dynamic> data = await deliveriesOneController
        .getListDeliveriesProcessTwo(this.idHomework);

    await session.renovate();

    print('list deliverie revision');

    if (!mounted) return;

    setState(() {
      homeworkData = data;
    });

    return homeworkData;
  }

  Widget _homework() {
    return RefreshIndicator(
        onRefresh: getDeliveries,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 20),
          itemCount: homeworkData.length,
          itemBuilder: (context, index) =>
              _cardTipo1(context, homeworkData[index]),
        ));
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
                    return PhotoViewPage(images: images, tittle: 'Imagenes entrega',);
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

    String launchAt = homework["launch_at"];
    int idDeliverie = homework["id"];
    String message = 'Debe lanzar la entrega';
    DateTime convertUpdatedAt;
    String messageLaunch = 'Debe lanzar la entrega';

    if (homework["process"] == 2) {
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

          if (diference.inDays == 31 && homework["qualification"] >= 3.0) {
            deliveriesOneController.updateDeliverieToAproved(
                idDeliverie, {'launch_at': todayDate.toString()});

            message = 'Expirado';
          } else {
            if (diference.inDays == 31 && homework["qualification"] < 3.0) {
              deliveriesOneController.updateDeliverieToEdition(
                  idDeliverie, {'launch_at': todayDate.toString()});

              message = 'Corriga y vuelva a lanzar su entrega';
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
              homework["qualification"] >= 3.0) {
            deliveriesOneController.updateDeliverieToAproved(
                idDeliverie, {'launch_at': todayDate.toString()});

            message = 'Expirado';
          } else {
            if (positiveDiference.inDays == 31 &&
                homework["qualification"] < 3.0) {
              deliveriesOneController.updateDeliverieToEdition(
                  idDeliverie, {'launch_at': todayDate.toString()});

              message = 'Corriga y vuelva a lanzar su entrega';
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
      if (homework["process"] == 3) {
        messageLaunch = 'Expiró';
        message = 'Expiró';
      } else {
        message = 'Debe lanzar la entrega';
      }
    }

    final card = Container(
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              child: _createCarousel(homework["imagesDeliverie"])),
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
                          'Fecha de lanzamiento',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
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
                          'Fecha límite',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
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
                SizedBox(
                  height: 5.0,
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
            height: 10,
            color: Colors.black26,
          ),
          _star(homework),
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
              "${homework["description"]}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            expanded: Text(
              "${homework["description"]}",
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
        onTap: () async {
          session.setMap('DeliveriesData', homework);
          Navigator.popAndPushNamed(context, 'StarsDeliveries');
        });
  }
}
