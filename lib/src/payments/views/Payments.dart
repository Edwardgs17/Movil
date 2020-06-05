import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colfunding/src/Notifications/Providers/NotificationsProvider.dart';
import 'package:colfunding/src/payments/providers/PaymentsProviders.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  FlutterWebviewPlugin flutterWebviewPlugin;
  PaymentsProviders paymentsProviders;
  NotificationsProvider notificationsProvider;
  Alert alert;
  Session session;
  Token token;
  String url;
  int c;
  int priceRewards;

  _PaymentsState() {
    c = 0;
    alert = new Alert();
    session = new Session();
    token = new Token();
    notificationsProvider = NotificationsProvider();
    token.getString('url').then((url) {
      print(url);
      setState(() {
        this.url = url;
      });

      token.getNumber('priceRewards').then((price) {
        priceRewards = price;
        print(priceRewards);
        print("sdasdsadasdasdsa");
      });
    });
    paymentsProviders = new PaymentsProviders();
    flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.contains('success') && c < 1) {
        c++;
        flutterWebviewPlugin.close();
        final user = await session.getInformation();
        final idProject = await token.getNumber('idProject');
        final idReward = await token.getNumber('idReward');
        print(idProject);
        bool res = await paymentsProviders.success({
          'idRewards': idReward,
          'idUser': user['id'],
          'idProject': idProject,
          'url': url
        });
        if (res) {
          print('ok');
          final idUser = await token.getNumber('idUserProject');
          print(idUser);
          DateTime now = DateTime.now();
          String d = DateFormat('d').format(now);
          String m = DateFormat('M').format(now);
          int day = int.parse(d);
          int month = int.parse(m);
          Firestore.instance.collection('expenses').add({
            "idProject": idProject,
            "reward": idReward,
            "month": month,
            "day": day,
            "value": priceRewards
          });
          notificationsProvider.sendNotifications({
            'idUser': idUser,
            'title': 'Nuevo fondo!',
            'body': 'Alguien ha invertido en tu proyecto!!'
          });
          alert.showAlert(context, 'Pago exito!', 'Gracias por tu inversion!',
              Icons.done_outline, Colors.green);
          Future.delayed(Duration(seconds: 5)).then((resp) {
            Navigator.pushReplacementNamed(context, 'SideBarLayout');
          });
        } else {
          print(res);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Centro de pagos'),
      ),
      body: url != null
          ? WebviewScaffold(
              url: url,
            )
          : Text('Cargando...'),
    ));
  }
}
