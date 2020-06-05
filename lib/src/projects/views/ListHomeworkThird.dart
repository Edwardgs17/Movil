import 'package:colfunding/src/projects/controllers/DeliveriesController.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/PhotoView.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:colfunding/src/payments/providers/PaymentsProviders.dart';
import 'package:colfunding/src/projects/controllers/UpdateProjectController.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:expandable/expandable.dart';
import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/ListHomeworkProcessController.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListHomeworkThird extends StatefulWidget {
  final List homeworkDetailData3;
  final bool isUser;
  final int idProject;
  ListHomeworkThird({this.homeworkDetailData3, this.isUser, this.idProject});

  @override
  _HomeworkState createState() => _HomeworkState(
      homeworkDetailData: this.homeworkDetailData3,
      isUser: this.isUser,
      idProject: this.idProject);
}

class _HomeworkState extends State<ListHomeworkThird> {
  HomeworkController homeworkController;
  ListHomeworkProcessController listHomeworkProcessController;
  bool financing;
  PaymentsProviders paymentsProviders;
  UpdateProjectController updateProjectController;
  DeliveriesController deliveriesController;
  Token token;
  int idProject;
  List homeworkDetailData;
  final bool isUser;
  DateTime date, todayDate;
  Session session;
  Alert alert;

  String note =
    'Al lanzar la tarea, estará en un estado de revisión durante un mes. Al finalizar, cambiara su estado (Edición => Revisión => Aprobado) dependiendo de la calificación que le den los usuarios.';

  _HomeworkState({this.homeworkDetailData, this.isUser, this.idProject}) {
    homeworkController = HomeworkController();
    listHomeworkProcessController = ListHomeworkProcessController();
    updateProjectController = UpdateProjectController();
    paymentsProviders = PaymentsProviders();
    deliveriesController = DeliveriesController();
    alert = Alert();
    session = Session();
    token = Token();
    
    getHomeworks();
    financing = false;

    token.getBool('financing').then((res) {
      setState(() {
        print('booooooooooooool : $res');
        financing = res;
        print(res);
      });
    });
    isPaybutton = false;
    print('------->info trhee: $homeworkDetailData');
    print(idProject);
  }

  Future getHomeworks() async {
    List<dynamic> data = await listHomeworkProcessController
        .getListHomeworkProcessThird(context, this.idProject);

    await session.renovate();

    print('list homework');

    if (!mounted) return;

    setState(() {
      homeworkDetailData = data;
    });

    return homeworkDetailData;
  }

  Color myColorGrey = Color(0xfff2f5f8),
      myColorBlue = Colors.blue[800],
      lightText = Color(0xff8891a4);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _homework(),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _homework() {
    return  RefreshIndicator(
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
    bool check =
        isUser && financing && homework["homeworks"]['withdrawal'] == false;
    print('object $check');
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
                          'Aprobada',
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Aprobada',
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
          Divider(
            height: 10,
            color: Colors.black26,
          ),
          _deliveries(homework),
          check
              ? Divider(
                  color: Colors.black26,
                )
              : Container(),
          check ? _getPay(homework) : Container(),
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

  bool isPaybutton;
  Widget _getPay(homework) {
    print('pay $isPaybutton');

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
          title: Text("Retirar dinero",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              )),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
          ),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Icon(
                              Icons.error_outline,
                              size: 70.0,
                              color: Colors.orange[300],
                            ),
                          )),
                      Text(
                        "retirar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "¿Está seguro que desea hacer este retiro?",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: Navigator.of(context).pop,
                            child: Text("Cancelar"),
                            splashColor: Colors.blueGrey,
                          ),
                          FlatButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            child: Text("Aceptar"),
                            splashColor: Colors.green,
                            onPressed: () async {
                              if (!isPaybutton) {
                                setState(() {
                                  homework["homeworks"]['withdrawal'] = true;
                                  isPaybutton = true;
                                });
                                bool a =
                                    homework["homeworks"]["minimal_cost"] == 0;
                                double value = 0;
                                if (a)
                                  value = double.parse(homework["homeworks"]
                                          ["optimal_cost"]
                                      .toString());
                                else
                                  value = double.parse(homework["homeworks"]
                                          ["minimal_cost"]
                                      .toString());
                                bool success = await paymentsProviders.payout({
                                  'email':
                                      'sb-wchkp721713@personal.example.com',
                                  'value': value,
                                  'senderItemId':
                                      homework["homeworks"]["id"].toString(),
                                  'idProject': homework["homeworks"]
                                          ["idProject"]
                                      .toString()
                                });
                                print(success);
                                setState(() {
                                  if (success) {
                                    alert.showSuccesAlert(
                                        context,
                                        '¡Has Retirado con exito!',
                                        'revisa tu cuenta paypal',
                                        Icons.check_circle_outline,
                                        Colors.green);
                                    Future.delayed(Duration(seconds: 1))
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      print(' 1 pay $isPaybutton');
                                      setState(() {
                                        isPaybutton = false;
                                      });
                                    });
                                  } else {
                                    alert.showSuccesAlert(
                                        context,
                                        '¡te Has quedado sin fondos!',
                                        'ya no puedes retirar mas',
                                        Icons.highlight_off,
                                        Colors.red);
                                  }
                                  financing = !success;
                                });
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ]),
                  ],
                );
              });
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
          print('***********************************');
          print(homework["homeworks"]["id"]);
          print('***********************************');
          print('#############################################');
          token.setBool('isUser', isUser);
          deliveriesController.getDeliveriesDatails(
              context, homework["homeworks"]["id"], isUser);
        });
  }
}
