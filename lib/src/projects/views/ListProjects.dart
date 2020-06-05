import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colfunding/src/projects/controllers/ListProjectController.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ListProjects extends StatefulWidget {
  ListProjects();
  @override
  _ListProjectsState createState() => _ListProjectsState();
}

class _ListProjectsState extends State<ListProjects> {
  Alert alert;
  List<dynamic> projectsData = new List();
  ScrollController _scrollController = new ScrollController();
  ListProjectsController listProjectsController;
  Sidebar sidebar;
  Map user = {};
  int c;
  Token token;
  Session session;
  SeeProjectController seeProject;

  _ListProjectsState() {
    this.seeProject = SeeProjectController();
    session = new Session();
    c = 0;
    token = new Token();
    sidebar = Sidebar(
      page: 2,
    );
  }
  Future getProjects() async {
    user = await session.getInformation();
    alert = new Alert();
    listProjectsController = new ListProjectsController();
    projectsData = await listProjectsController.getListProjects(context);
    bool state = false;
    print(projectsData.length);
    for (var project in projectsData) {
      if (project['idUser'].toString() == user['id'].toString()) {
        print('have Project');
        state = false;
        break;
      }
      state = true;
    }
    c = await token.getNumber('c');
    print(state);
    if (state && c < 1) {
      c++;
      token.setNumber('c', c);
      alert.errorAlert(context, "Advertencia",
              "Aun no has creado proyectos", Icons.warning, Colors.yellow[600]);
    }
    setState(() {});
    return projectsData;
  }

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            )),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[200],
      body: _createList(),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: const Icon(Icons.add),
          label: const Text('Nuevo Proyecto'),
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.pushNamed(context, 'CreateProject');
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  Future<Null> getPage() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      getProjects();
    });
    return Future.delayed(duration);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _createList() {
    print('create List');
    return RefreshIndicator(
      onRefresh: getProjects,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: projectsData.length,
        itemBuilder: (context, index) =>
            _cardTipo1(context, projectsData[index]),
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  Widget _createCarousel(List<dynamic> images) {
    return CarouselSlider.builder(
      height: 300.0,
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

  Widget _cardTipo1(BuildContext context, dynamic project) {
    final card = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 10.0),
                child: Text(
                  project["nameUser"] == null ? 'anonimo' : project["nameUser"],
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),
              Divider()
            ],
          ),
          Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              child: _createCarousel(project["imagesProject"])),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: _titleSection(project),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: _showMoreSection(project),
            onTap: () {
              print("Mas info");
            },
          ),
        ],
      ),
    );
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
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
        borderRadius: BorderRadius.circular(5.0),
        child: card,
      ),
    );
  }

  Widget _showMoreSection(dynamic project) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Información del proyecto',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*3*/
              Icon(
                Icons.keyboard_arrow_right,
                size: 35.0,
                color: Colors.green[800],
              ),
            ],
          ),
        ),
        onTap: () {
          token.setNumber('idProject', project["id"]);
          bool isUser = user['id'].toString() == project["idUser"].toString();
          print(project['id']);
          seeProject.getProjectDatails(context, project["id"], isUser);
        });
  }

  Widget _titleSection(dynamic project) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    '${project["title"]}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Text(
                  'Óptimo: ' + r'$' + '${project["optimal_cost"]}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Text(
                  'Minimo: ' + r'$' + '${project["minimal_cost"]}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
