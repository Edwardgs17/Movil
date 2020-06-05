import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/views/EditHomework.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homework extends StatefulWidget {
  final List homeworkDetailData;
  final bool isUser;
  Homework({this.homeworkDetailData, this.isUser});

  @override
  _HomeworkState createState() => _HomeworkState(
      homeworkDetailData: this.homeworkDetailData, isUser: this.isUser);
}

class _HomeworkState extends State<Homework> {
  HomeworkController homeworkController;
  List homeworkDetailData;
  final bool isUser;
  double rating = 0.0;
  _HomeworkState({this.homeworkDetailData, this.isUser}) {
    homeworkController = HomeworkController();
    print('------->info : $homeworkDetailData');
  }

  Color myColorGrey = Color(0xfff2f5f8),
      myColorBlue = Colors.blue[800],
      lightText = Color(0xff8891a4);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tareas',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              )),
          backgroundColor: Colors.green,
        ),
        body: _homework(),
        backgroundColor: Colors.grey[200],
        floatingActionButton: isUser
            ? FloatingActionButton.extended(
                elevation: 4.0,
                icon: const Icon(Icons.add),
                label: const Text('Crear tarea'),
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, 'CreateHomeWork');
                })
            : null,
      ),
      
    );
  }

  Widget _homework() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 20),
      itemCount: homeworkDetailData.length,
      itemBuilder: (context, index) =>
          _cardTipo1(context, homeworkDetailData[index]),
    );
  }

  Widget _createCarousel(List<dynamic> images) {
    return CarouselSlider.builder(
      itemCount: images.length == null ? 0 : images.length,
      itemBuilder: (BuildContext context, int index) => Carousel(
        boxFit: BoxFit.cover,
        images: [
          NetworkImage(images[index].toString()),
        ],
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }

  Widget _cardTipo1(BuildContext context, dynamic homework) {
    
    final card = Container(
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
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
              Divider()
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
           Divider(color: Colors.black26,),
            _star(homework),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: this.isUser
                      ? InkWell(
                          child: ButtonTheme(
                            minWidth: 100.0,
                            height: 48.0,
                            child: RaisedButton.icon(
                              splashColor: Colors.green[900],
                              color: Colors.green,
                              textColor: Colors.white,
                              label: Text('Editar'),
                              icon: Icon(Icons.mode_edit),
                              onPressed: () {
                                print(homework["homeworks"]);
                                final route =
                                    MaterialPageRoute(builder: (context) {
                                  return EditHomeworkPage(
                                      homeworkDetail: homework["homeworks"],
                                      homeworkImages:
                                          homework["imagesHomework"]);
                                });
                                Navigator.push(context, route);
                              },
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              Expanded(
                child: this.isUser
                    ? InkWell(
                        child: ButtonTheme(
                          minWidth: 100.0,
                          height: 48.0,
                          child: RaisedButton.icon(
                            splashColor: Colors.red,
                            color: Colors.red[800],
                            textColor: Colors.white,
                            label: Text('Eliminar'),
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0),
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
                                            "Eliminar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "¿Está seguro que desea eliminar esta tarea?",
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                onPressed:
                                                    Navigator.of(context).pop,
                                                child: Text("Cancelar"),
                                                splashColor: Colors.blueGrey,
                                              ),
                                              FlatButton(
                                                color: Colors.green,
                                                textColor: Colors.white,
                                                child: Text("Aceptar"),
                                                splashColor: Colors.green,
                                                onPressed: () async {
                                                  String res =
                                                      await homeworkController
                                                          .deleteHomework(
                                                              homework[
                                                                      "homeworks"]
                                                                  ["id"]);

                                                  if (res ==
                                                      'Tarea eliminada') {
                                                    print(res);

                                                    List<dynamic> response =
                                                        await homeworkController
                                                            .getHomeworksByIdProject(
                                                                homework[
                                                                        "homeworks"]
                                                                    [
                                                                    "idProject"]);

                                                    setState(() {
                                                      this.homeworkDetailData =
                                                          response;
                                                    });

                                                    Navigator.pop(context);
                                                  } else {
                                                    return homeworkController
                                                        .showAlert(
                                                            context,
                                                            'Error',
                                                            res,
                                                            Icons.highlight_off,
                                                            Colors.red);
                                                  }
                                                },
                                              ),
                                            ]),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),

],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
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
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${homework["homeworks"]["description"]}',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Óptimo: ' +
                      r'$' +
                      '${homework["homeworks"]["optimal_cost"]}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                Text(
                  'Mínimo: ' +
                      r'$' +
                      '${homework["homeworks"]["minimal_cost"]}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ],
            ),
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
          Session session = new Session();
           session.setMap('homeworkDetail', homework);
          Navigator.popAndPushNamed(context, 'StarsHomeworks');
        });
  }
}
