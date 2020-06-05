import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/utils/sidebar/sidebar_item.dart';

class SidebarLayout extends StatefulWidget {

  final int indexPage;

  const SidebarLayout({Key key, this.indexPage}) : super(key: key);

  @override
  _SidebarLayoutState createState() => _SidebarLayoutState(indexPage: this.indexPage);
}

class _SidebarLayoutState extends State<SidebarLayout> with AfterLayoutMixin {

  int selectedIndex = 0;

  LabeledGlobalKey _loginKey    = LabeledGlobalKey("loginKey");
  LabeledGlobalKey _registerKey = LabeledGlobalKey("registerKey");

  RenderBox renderBox;
  double startYPosition = 0;

  _SidebarLayoutState({int indexPage}) {
    selectedIndex = indexPage;
  }

  void onTabTap(int index) {
    setState(() {
      selectedIndex = index;

      switch (selectedIndex) {
        case 0:
          renderBox = _loginKey.currentContext.findRenderObject();
          Navigator.pushReplacementNamed(context, 'Login');
          break;
        case 1:
          renderBox = _registerKey.currentContext.findRenderObject();
          Navigator.pushReplacementNamed(context, 'Signin');
          break;
      } 
    
      startYPosition = renderBox.localToGlobal(Offset.zero).dy; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          width: 90,
          top: -25,
          bottom: 0,
          right: 0,
          child: ClipPath(
            clipper: SidebarClipper(
              (startYPosition == null) ? 0 : startYPosition - 40,
              (startYPosition == null) ? 0 : startYPosition + 80,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF4CAF50),],
                  stops: [1] 
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -30,
          top: 0,
          bottom: 0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 40,
              ),
              
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SidebarItem(
                      key: _loginKey,
                      text: 'Iniciar Sesión',
                      onTabTap: () {
                        onTabTap(0);
                      },
                      isSelected: selectedIndex == 0,
                    ),
                    SidebarItem(
                      key: _registerKey,
                      text: 'Registro',
                      onTabTap: () {
                        onTabTap(1);
                      },
                      isSelected: selectedIndex == 1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 120,
              ),
            ],  
            
          )
        )
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      switch (selectedIndex) {
        case 0:
          renderBox = _loginKey.currentContext.findRenderObject();
          break;
        case 1:
          renderBox = _registerKey.currentContext.findRenderObject();
          break;
      } 
      startYPosition = renderBox.localToGlobal(Offset.zero).dy; 
    });
  }
}

class SidebarClipper extends CustomClipper<Path> {

  final double startYPosition, endYPosition;

  SidebarClipper(this.startYPosition, this.endYPosition);

  @override
  Path getClip(Size size) {
    Path path = Path();

    double width = size.width;
    double height = size.height;

    // Up Curve
    path.moveTo(width, 0);
    path.quadraticBezierTo(width / 3, 5, width / 3, 70);

    // Custom Curve
    path.lineTo(width / 3, startYPosition);
    path.quadraticBezierTo(width / 3 - 2, startYPosition + 15, width / 3 -10, startYPosition + 25);
    path.quadraticBezierTo(0, startYPosition + 45, 0, startYPosition + 60);
    path.quadraticBezierTo(0, endYPosition - 45, width / 3 - 10, endYPosition -25);
    path.quadraticBezierTo(width / 3 - 2, endYPosition - 15, width / 3,  endYPosition);
    path.lineTo(width / 3, endYPosition);

    // Down Curve
    path.lineTo(width / 3, height - 70);
    path.quadraticBezierTo(width / 3, height - 5, width, height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}