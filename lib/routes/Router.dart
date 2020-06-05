import 'package:colfunding/src/payments/views/Payments.dart';
import 'package:colfunding/src/projects/views/CreateDeliverie.dart';
import 'package:colfunding/src/projects/views/CreateHomeWork.dart';
import 'package:colfunding/src/projects/views/CreateReward.dart';
import 'package:colfunding/src/projects/views/DeliveriesProcess.dart';
import 'package:colfunding/src/projects/views/Gallery.dart';
import 'package:colfunding/src/projects/views/ListHomeworkProcess.dart';
import 'package:colfunding/src/projects/views/ListProjectsProcess.dart';
import 'package:colfunding/src/projects/views/MyInvestments.dart';
import 'package:colfunding/src/projects/views/StarsDeliveries.dart';
import 'package:colfunding/src/projects/views/StarsHomework.dart';
import 'package:colfunding/src/projects/views/SupportedProjects.dart';
import 'package:colfunding/src/projects/views/UpdateProject.dart';
import 'package:colfunding/src/projects/views/myProjects.dart';
import 'package:colfunding/src/users/views/ChangePassword.dart';
import 'package:colfunding/utils/Sidebar_Layout.dart';
import 'package:colfunding/utils/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/src/projects/views/CreateProject.dart';
import 'package:colfunding/src/projects/views/EditHomework.dart';
import 'package:colfunding/src/users/views/Login.dart';
import 'package:colfunding/src/users/views/Signin.dart';
import 'package:colfunding/src/users/views/UpdateUser.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    'SideBarLayout': (BuildContext context) => SideBarLayout(),
    'Login': (BuildContext context) => Login(),
    'Signin': (BuildContext context) => Signin(),
    'UpdateUser': (BuildContext context) => UpdateUser(),
    'ChangePassword': (BuildContext context) => PageChangePassword(),
    'ListProjects': (BuildContext context) => MyHome(),
    'CreateProject': (BuildContext context) => CreateProject(),
    'MyProjects': (BuildContext context) => MyProjects(),
    'Gallery': (BuildContext context) => Gallery(),
    'CreateHomeWork': (BuildContext context) => CreateHomeWork(),
    'CreateReward': (BuildContext context) => CreateReward(),
    'EditHomework': (BuildContext context) => EditHomeworkPage(),
    'Splash': (BuildContext context) => Splash(),
    'MyInvestments': (BuildContext context) => MyInvestments(),
    'SupportedProjects': (BuildContext context) => SupportedProjects(),
    'Payments': (BuildContext context) => Payments(),
    'UpdateProject': (BuildContext context) => UpdateProject(),
    'StarHomework': (BuildContext context) => StarsHomework(),
    'MyProcess': (BuildContext context) => MyProcess(),
    'Deliveries': (BuildContext context) => Deliveries(),
    'CreateDeliverie': (BuildContext context) => CreateDeliverie(),
    'StarsDeliveries': (BuildContext context) => StarsDeliveries(),
    'StarsHomeworks': (BuildContext context) => StarsHomework(),
  };
}
