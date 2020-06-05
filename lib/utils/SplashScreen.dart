import 'package:colfunding/utils/Session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  Session session;
  _SplashState(){
        session = new Session();
  }
  @override
  void initState() { 
    Future.delayed(
      Duration(seconds: 3),
      (){
      session.renovate().then((res){
      if (res) {
        Navigator.pushReplacementNamed(context, 'SideBarLayout');
      }else{
       Navigator.pushReplacementNamed(context, 'Login');
      } 
    });
       
      }
    );
        super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       body: Stack(
         fit: StackFit.expand,
         children: <Widget>[
           Container(
             decoration: BoxDecoration(color:Colors.green),
           ),
           Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Color.
                        fromRGBO(247, 247, 247, 1.0),
                        radius: 63.0,
                        child: Image(
                          image: AssetImage('assets/log.png'),
                          
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.0) ,
                      ),
                      Text(
                        "Colfunding",
                         style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
               flex: 1,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   
                   CircularProgressIndicator(
                     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                     ),
                   Padding(padding: EdgeInsets.only(top: 20.0)
                   ),
                 ],
               ),
              )
            ],
           )
         ],
       ),
    );
  }
}