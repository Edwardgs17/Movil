import 'package:colfunding/src/projects/controllers/MyProjectsController.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/src/users/controllers/UpdateUserController.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:colfunding/utils/NavigationBloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MyProjects extends StatefulWidget with NavigationStates {
  final String title;
  final Map user;

  MyProjects({this.title, this.user});

  @override
  _MyProjectState createState() => new _MyProjectState(user: this.user);
}

class _MyProjectState extends State<MyProjects> with TickerProviderStateMixin {
  List<dynamic> projectsData = new List();
  MyProjectsController myProjectsController;
  ScrollController scrollController;
  Alert alert;
  Map user = {};
  Sidebar sidebar;
  int c;
  Token token;
  Session session;
  DateTime date, todayDate;
  SeeProjectController seeProject;
  UpdateUserController updateUserController;
  String qualification;
  String note =
    'El projecto tiene un tiempo limite de un mes, luego, este cambiara su estado dependiendo de la calificación que le den los usuarios.';

  _MyProjectState({this.user}) {
    alert = new Alert();
    updateUserController = UpdateUserController();
    this.seeProject      = SeeProjectController();

    print('my projects');
    session = new Session();
    c = 0;
    token = new Token();
    sidebar = Sidebar(
      page: 2,
    );
  }

  Future getMyProjects() async {
    user = await session.getInformation();
    myProjectsController = new MyProjectsController();
    await session.renovate();
    projectsData =
        await myProjectsController.getImageByIdProjects(context, user["id"]);
    print('list projects');
    //print(projectsData);

    if (!mounted) return;

    setState(() {});

    return projectsData;
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();

    getMyProjects();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.enhanced_encryption,
                color: Colors.transparent,
              ),
              onPressed: null),
          centerTitle: true,
          backgroundColor: Colors.green,
          title: Text(
            "Mis Proyectos",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        body: _myProjects(),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: const Icon(Icons.add),
          label: const Text('Nuevo Proyecto'),
          backgroundColor: Colors.green,
          onPressed: () {
            updateUserController.getUserInformation(user['email']).then((res) {
              if (res['document'] == null &&  res['fullname'] == 'Anónimo' &&
                res['birthday'] == null )
              {
                alert.showSuccesAlert(
                  context,
                  'Verificar',
                  'Debe actualizar sus datos para poder crear un proyecto',
                  Icons.help_outline,
                  Colors.blue
                );
              } else {
                Navigator.pushNamed(context, 'CreateProject');
              }
            }).catchError((err) async {
              await session.renovate();
            });
          }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
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
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                image: images[index].toString(),
                imageScale: 0.8,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            );
          },
          viewportFraction: 0.5,
          scale: 0.8,
          control: SwiperControl(color: Colors.white),
        ));
  }

  Widget _cardTipo1(BuildContext context, dynamic project) {
    final card = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(top: 15.0, left: 20.0, right: 10.0),
                      child: Text(
                        project["title"],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ]))
            ],
          ),
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            child: _createCarousel(project["imagesProject"])),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: _titleSection(context, project),
          ),
        ],
      ),
    );
    return GestureDetector(
        child: Container(
          margin:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
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
        ),
        onTap: () {
          token.setNumber('idProject', project["id"]);
          seeProject.getProjectDatails(context, project["id"], true);
        });
  }

  Widget _titleSection(BuildContext context, dynamic project) {
    
    bool disbleButton = false;
    String titleNewEstate = 'Fecha límite';
    String launchAt = project["launch_at"];
    String message = '';
    DateTime convertUpdatedAt;
    String updatedAtFormatDate = 'Debe lanzar el proyecto';

    if (project["process"] == 'Revisión') {
      convertUpdatedAt = DateTime.parse(launchAt);
      updatedAtFormatDate = formatDate(convertUpdatedAt, [
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

          if (diference.inDays == 31 && project["qualification"] >= 3.0) {
            myProjectsController.aprovedProject(
                project["id"], {'launch_at': todayDate.toString()});
            message = 'Expirado';
          } else {
            if (diference.inDays == 31 && project["qualification"] < 3.0) {
              myProjectsController.editedProject(
                  project["id"], {'launch_at': todayDate.toString()});
              message = 'Corriga y vuelva a lanzar su proyecto';
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
              project["qualification"] >= 3.0) {
            myProjectsController.aprovedProject(
                project["id"], {'launch_at': todayDate.toString()});
            message = 'Expirado';
          } else {
            if (positiveDiference.inDays == 31 &&
                project["qualification"] < 3.0) {
              myProjectsController.editedProject(
                  project["id"], {'launch_at': todayDate.toString()});
              message = 'Corriga y vuelva a lanzar su proyecto';
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
      if (project["process"] == 'Aprobado' ||
          project["process"] == 'Cancelado') {
        updatedAtFormatDate = 'Expiró';
        message = 'Expiró';
      } else {
        message = 'Debe lanzar el proyecto';
      }
    }

    IconData icon;
    Color color;

    switch (project["process"]) {
      case 'Edición':
        icon = Icons.assignment;
        color = Colors.yellow[800];
        disbleButton = false;
        break;
      case 'Revisión':
        icon = Icons.lock;
        color = Colors.yellow[800];
        disbleButton = true;
        break;
      case 'Aprobado':
        icon = Icons.offline_pin;
        color = Colors.green;
        disbleButton = true;
        break;
      case 'Cancelado':
        icon = Icons.not_interested;
        color = Colors.red;
        disbleButton = true;
        break;
      default:
        icon = Icons.cached;
        color = Colors.green;
        break;
    }

    return Container(
      padding: EdgeInsets.only(left: 20, top: 0.0, right: 20.0, bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                fontWeight: FontWeight.w500,
              ),
            ),
                
            collapsed: Text(
              "${project["description"]}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            expanded: Text(
              "${project["description"]}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              softWrap: true,
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
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    updatedAtFormatDate,
                    textAlign: TextAlign.end,
                    style: TextStyle(
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
                    titleNewEstate,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    message,
                    textAlign: TextAlign.end,
                    softWrap: true,
                    style: TextStyle(
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
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
                
            collapsed: Text(
              "$note",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              softWrap: true,
              maxLines: 2,
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

          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: 30.0,
                color: color,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "${project["process"]}",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
              ),
              Spacer(),
              Container(
                height: 30.0,
                width: 2.0,
                color: Colors.grey,
              ),
              Spacer(),
              FlatButton.icon(
                color: Colors.green,
                textColor: Colors.white,
                splashColor: Colors.white24,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                label: Text(
                  'Lanzar',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
                ),
                icon: Icon(Icons.backup),
                onPressed: disbleButton == false
                    ? () async {
                        date = DateTime.now();

                        Map<String, dynamic> data = await myProjectsController
                            .updateProcessProject(
                                project["id"], {'launch_at': date.toString()});

                        List newData = [data];

                        if (newData.length > 0) {
                          alert.showSuccesAlert(
                              context,
                              'Éxito',
                              'Proyecto lanzado a revisión',
                              Icons.check_circle,
                              Colors.green);

                          List<dynamic> finalData = await myProjectsController
                              .getImageByIdProjects(context, user["id"]);

                          setState(() {
                            projectsData = finalData;
                          });
                        } else {
                          alert.showSuccesAlert(
                              context,
                              "Error",
                              "No se pudó realizar la acción",
                              Icons.highlight_off,
                              Colors.red);
                        }
                      }
                    : null,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _myProjects() {
    return RefreshIndicator(
        onRefresh: getMyProjects,
        child: ListView.builder(
          controller: scrollController,
          itemCount: projectsData.length,
          itemBuilder: (context, index) =>
              _cardTipo1(context, projectsData[index]),
        ));
  }
}
