import 'package:colfunding/routes/Router.dart';
import 'package:colfunding/validators/provider.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/src/users/views/Login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarIconBrightness: Brightness.light,
    ));

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Colfunding Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          cursorColor: Colors.green,
          fontFamily: 'Raleway',
        ),
        initialRoute: 'Splash',
        routes: getRoutes(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('es', 'ES'), //Spanish
        ],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => Login(),
          );
        },
      ),
    );
  }
}
