import 'package:colfunding/src/projects/controllers/ProjectQualificationController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alert {
  ProjectQualificationController projectQualificationController;

  void simpleAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }
  
  void showSuccesAlertOne(BuildContext context, String title, String message,
      IconData icon, Color color) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Icon(
                        icon,
                        size: 80.0,
                        color: color,
                      ),
                    )),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(message),
              ],
            ),
          );
        });
      }

  void showSuccesAlert(BuildContext context, String title, String message,
      IconData icon, Color color) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Icon(
                        icon,
                        size: 80.0,
                        color: color,
                      ),
                    )),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(message, textAlign: TextAlign.center,),
              ],
            ),
          );
        });
  }

  void showAlert(BuildContext context, String title, String message,
      IconData icon, Color color) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Icon(
                        icon,
                        size: 80.0,
                        color: color,
                      ),
                    )),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(message),
                FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text('Continuar'),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'SideBarLayout');
                    }),
              ],
            ),
          );
        });
  }

void errorAlert(BuildContext context, String title, String message,
      IconData icon, Color color) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Icon(
                        icon,
                        size: 80.0,
                        color: color,
                      ),
                    )),
                Text(
                  'Advertencia',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(message),
              ]), 
               actions: <Widget>[
                FlatButton(
                  child: Text('cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                   }),
               
              ],
            
          );
        });
  }

  void emailAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: Image(
            image: AssetImage('assets/gmail.gif'),
            width: 200.0,
            height: 200.0,
          ),
        );
      },
    );
  }

  void confirmEmailAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(message)),
          content: Image(
            image: AssetImage('assets/check.gif'),
            width: 200.0,
            height: 200.0,
          ),
          // backgroundColor: Colors.green[100],
        );
      },
    );
  }
}
