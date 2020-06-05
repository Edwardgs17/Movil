import 'package:colfunding/utils/NavigationBloc.dart';
import 'package:flutter/material.dart';
import './ListProjectsProcessOne.dart' as first;
import './ListProjectsProcessTwo.dart' as second;

class MyHome extends StatefulWidget with NavigationStates {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
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
          leading: IconButton(
            icon: Icon(Icons.enhanced_encryption, color: Colors.transparent,), 
            onPressed: null
          ),
          centerTitle: true,
          title: Text(
            "Colfunding",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          ),
          backgroundColor: Colors.green,
          bottom: new TabBar(
            controller: controller,
            indicatorColor: Colors.white,
            tabs: <Tab>[
              new Tab(
                child: new Text(
                  'Aprobados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ),
              new Tab(
                child: new Text(
                  'En Revisión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ),
            ]
          )
        ),
          
        body: new TabBarView(
          controller: controller, 
          children: <Widget>[
            new first.ListProjectsOne(),
            new second.ListProjectsTwo(),
          ]
        )
      ),
    );
  }
}
