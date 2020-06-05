import 'package:colfunding/utils/PhotoView.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/src/projects/controllers/SupportedProjectsController.dart';
import 'package:colfunding/utils/NavigationBloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SupportedProjects extends StatefulWidget with NavigationStates {
  @override
  _SupportedProjectsState createState() => new _SupportedProjectsState();
}

class _SupportedProjectsState extends State<SupportedProjects> {
  Session session;
  SupportedProjectsController supportedProjectsController;
  Map user = {};
  List<dynamic> supportedProjects = [];
  ScrollController scrollController;
  Sidebar sidebar;

  _SupportedProjectsState() {
    session = new Session();
    sidebar = Sidebar(
      page: 2,
    );
  }

  Future getSupportedProjects() async {
    user = await session.getInformation();
    supportedProjectsController = new SupportedProjectsController();
    await session.renovate();

    supportedProjects =
        await supportedProjectsController.getSupportedProjects(user["id"]);

    print(supportedProjects);

    setState(() {});

    return supportedProjects;
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    Future.delayed(Duration(milliseconds: 1), () {
      getSupportedProjects();
    });
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
        title: Text(
          "Proyectos Que Apoyo",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
          overflow: TextOverflow.fade,
        ),
        backgroundColor: Colors.green,
      ),
      body: _mySupportedProjects(),
    ));
  }

  Widget _mySupportedProjects() {
    return ListView.builder(
        itemCount: supportedProjects == null ? 0 : supportedProjects.length,
        itemBuilder: (context, index) =>
            _cardTipo1(context, supportedProjects[index]));
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
                  project["title"],
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
              child: _createCarousel(project["imagesProject"])),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: _titleSection(project),
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
        onTap: () {});
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
          viewportFraction: 0.5,
          scale: 0.8,
          control: SwiperControl( color: Colors.white),
        ));
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
                Text(
                  'Innovado Por: '
                  '${project["nameUser"]}',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  '${project["description"]}',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 27.0,
                ),
                Container(
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
                      "${project["targetAudience"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  height: 15.0,
                ),
                Divider(),
                Text(
                  "Num De Mis Aportaciones : "
                  "${project["rewards"].length}",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Total De Dinero Invertido : "
                  r"$""${project["totalInvested"]}",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
