import 'dart:async';
import 'package:colfunding/utils/Session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:colfunding/utils/Menu_Item.dart';
import 'package:colfunding/src/users/controllers/UpdateUserController.dart';
import 'package:colfunding/utils/NavigationBloc.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;

  final _animationDuration = Duration(milliseconds: 500);
  Session session;
  Map user;
  UpdateUserController updateUserController;
  String name = '';
  String email = '';
  String nameAvatar = '';

  _SideBarState() {
    session = new Session();
    updateUserController = new UpdateUserController();
    loadInformation();
    print("##############Nombre#############################");
    print(name);
  }

  void loadInformation() {
    session.getInformation().then((user) {
      this.user = user;
      updateUserController.getUserInformation(user['email']).then((res) {
        setState(() {
          name = res['fullname'].toString();
          nameAvatar = name.substring(0,2).toUpperCase();
          email = res['email'];
        });
      }).catchError((err) async {
        await session.renovate();
        loadInformation();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSidebarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          curve: Curves.easeInOutExpo,
          left: isSidebarOpenedAsync.data ? 0 : -screenWidth,
          right: isSidebarOpenedAsync.data ? 25 : screenWidth - 37,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                height: screenHeight,
                padding: EdgeInsets.symmetric(horizontal: 15),
                // color: Colors.white,
                color: Colors.green,
                child: Container(
                  margin: EdgeInsets.only(top: 70.0),
                  color: Colors.green,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Card(
                          //margin: EdgeInsets.only( top: 0.0 ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(20.0, 20.0),
                            bottom: Radius.elliptical(20.0, 20.0),
                          )),
                          color: Colors.white,
                          elevation: 8.0,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            title: Text(
                              name,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              email,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 18),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: name != 'Anónimo' && name != null?
                                Text(
                                  '$nameAvatar',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ) 
                              : Icon(
                                Icons.person_pin,
                                color: Colors.white,
                                size: 50,
                              ),
                              radius: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Divider(
                          height: 60,
                          thickness: 0.5,
                          color: Colors.white,
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                            icon: Icons.home,
                            title: "Inicio",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.HomePageClickedEvent);
                            }),
                        MenuItem(
                            icon: Icons.portrait,
                            title: "Editar perfil",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(
                                  NavigationEvents.EditProfileClickedEvent);
                            }),
                        MenuItem(
                            icon: Icons.vpn_key,
                            title: "Cambiar contraseña",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(
                                  NavigationEvents.ChangePasswordClickedEvent);
                            }),
                        MenuItem(
                            icon: Icons.monetization_on,
                            title: "Mis inversiones",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(
                                  NavigationEvents.MyInvestmentsClikedEvent);
                            }),
                        MenuItem(
                            icon: Icons.archive,
                            title: "Mis proyectos",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.MyProjectsClickedEvent);
                            }),
                        MenuItem(
                            icon: Icons.timeline,
                            title: "Mi actividad",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.MyActivityClickedEvent);
                            }),
                        Divider(
                          height: 60,
                          thickness: 0.5,
                          color: Colors.white,
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                          icon: Icons.exit_to_app,
                          title: "Cerrar sesión",
                          onTap: () => session.close(context),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              Align(
                alignment: Alignment(0, -0.95),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipBehavior: Clip.antiAlias,
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.green,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.green;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
