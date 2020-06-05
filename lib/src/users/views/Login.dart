import 'package:colfunding/src/users/controllers/LoginController.dart';
import 'package:colfunding/src/users/providiers/LoginProvidier.dart';
import 'package:colfunding/src/users/controllers/RecoverPasswordController.dart';
import 'package:colfunding/src/Notifications/Providers/ConfigurePushNotificationsProvider.dart';
import 'package:colfunding/src/users/views/PasswordTextField.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Animation/FadeAnimation.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/validators/provider.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final String title;
  Login({this.title});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String title;
  TextEditingController email;
  TextEditingController password;
  TextEditingController emailsend;
  LoginController loginController;
  LoginProvidier loginProvidier;
  RecoverPasswordController recoverPasswordController;
  PushNotificationProvider pushNotificationProvider;
  Alert alert;
  Session session;
  FocusNode passwordFocusNode;

  _LoginState({this.title}) {
    this.email = TextEditingController();
    this.password = TextEditingController();
    this.emailsend = TextEditingController();
    this.loginController = LoginController();
    this.loginProvidier = LoginProvidier();
    this.recoverPasswordController = RecoverPasswordController();
    this.alert = Alert();
    this.pushNotificationProvider = PushNotificationProvider();
    passwordFocusNode = FocusNode();
    session = new Session();
  }

  @override
  Widget build(BuildContext context) {

    final bloc    = Provider.of(context);
    final formKey = GlobalKey<FormState>();
    String emailError    = '';
    String passwordError = '';

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: Stack(
                children: <Widget>[
                  FadeAnimation(
                    1.3, Container(
                      padding: EdgeInsets.fromLTRB(15.0, 120.0, 0.0, 0.0),
                      child: Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 40.0, 
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                        ),
                      ),
                    ),
                  ),

                  FadeAnimation(
                    1.4, Container(
                      padding: EdgeInsets.fromLTRB(15.0, 170.0, 0.0, 0.0),
                      child: Text(
                        'Inicio de Sesión',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  FadeAnimation(
                    1.4, Container(
                      padding: EdgeInsets.fromLTRB(196.0, 170.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                          fontSize: 25.0, 
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0,),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    FadeAnimation(
                      1.5, StreamBuilder(
                        stream: bloc.emailStream,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          
                          emailError = snapshot.error.toString();
                            
                          return TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'CORREO' ,
                              hintText: 'ejemplo@gmail.com',
                              labelStyle: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green
                                )
                              ),
                              errorText: snapshot.error
                            ),
                            onChanged: bloc.changeEmail,
                          );
                        }
                      )
                    ),

                    SizedBox(
                      height: 20.0,
                    ),

                    FadeAnimation(
                      1.5, StreamBuilder(
                        stream: bloc.passwordStream,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          
                          passwordError = snapshot.error.toString();
                          
                          return PasswordTextField(
                            passwordController: password,
                            errorText: snapshot.error,
                            onChanged: bloc.changePassword,
                            labelText: 'CONTRASEÑA' ,
                            textInputAction: TextInputAction.done,
                          );

                          // TextField(
                          //   controller: password,
                          //   obscureText: _obscureText,
                          //   decoration: InputDecoration(
                          //     labelText: 'CONTRASEÑA' ,
                          //     labelStyle: TextStyle(
                          //       fontSize: 12.0,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.grey
                          //     ),
                          //     suffixIcon: IconButton(
                          //       onPressed: () => setState(() => _obscureText = !_obscureText),
                          //       icon: Icon(
                          //         _obscureText ? Icons.visibility_off : Icons.visibility,
                          //       ),
                          //       iconSize: 18.0,
                          //     ),
                          //     fillColor: Colors.green,
                          //     focusedBorder: UnderlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: Colors.green
                          //       )
                          //     ),
                          //     errorText: snapshot.error
                          //   ),
                          //   onChanged: bloc.changePassword,
                          // );
                        }
                      )
                    ),

                    SizedBox( height: 5.0, ),

                    FadeAnimation(
                      1.6, Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, left: 20.0),
                        child: InkWell(
                          onTap: () => _createDialog(context),
                          child: Text(
                            'Recordar Contraseña',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                            ),
                          ),
                        ),              
                      ),
                    ),

                    SizedBox(
                      height: 40.0,
                    ),

                    FadeAnimation(
                      1.7, StreamBuilder(
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: InkWell(
                                onTap: () async {
                                  if (this.email.text.trim() != '' && this.password.text.trim() != '') {
                                    if (emailError == 'null' && passwordError == 'null') {
                                      final cellPhoneToken = await pushNotificationProvider.initNotifications();

                                      loginController.login(
                                        context, {
                                          'email': email.text.trim(), 
                                          'password': password.text.trim(),
                                        }, cellPhoneToken
                                      );
                                    } else {
                                      alert.showSuccesAlert(
                                        context,
                                        '¡Verificar!',
                                        'Datos incorrectos',
                                        Icons.highlight_off,
                                        Colors.red
                                      );
                                    }
                                  } else {
                                    alert.showSuccesAlert(
                                      context, 
                                      '¡Verificar!', 'Campos vacios',
                                      Icons.info, 
                                      Colors.blue
                                    );
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    'Iniciar Sesión',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      )
                    ),

                    SizedBox(
                      height: 20.0,
                    ),

                    FadeAnimation(
                      1.8, Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: InkWell(
                            onTap: () {
                                Navigator.pushReplacementNamed(context, 'Signin');
                              },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Icon(
                                    Icons.person_add,
                                  ),
                                ),

                                SizedBox(
                                  width: 5.0,
                                ),

                                Center(
                                  child: Text(
                                    'Registrar nuevo usuario',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
            ),

            SizedBox(
              height: 15.0,
            ),

            FadeAnimation(
              1.9, Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '¿Usuario nuevo?',
                  ),

                  SizedBox( width: 10.0,),

                  InkWell(
                    onTap: () => Navigator.pushReplacementNamed(context, 'Signin'),
                    child: Text(
                      'Registrese',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox( height: 20.0,),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   Provider.of(context);
  //   return Scaffold(
  //     resizeToAvoidBottomPadding: false,
  //     body: Stack(
  //       children: <Widget>[
  //         _createBackground( context ),
  //         _loginForm(context),
  //       ],
  //     ),
  //   );
  // }

  // Widget _loginForm(BuildContext context) {
  //   final bloc = Provider.of(context);

  //   return SingleChildScrollView(
  //     child: Column(
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.only(top: 10.0),
  //           child: SafeArea(
  //             child: Container(
  //               height: 180.0,
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(),
  //           child: Container(
  //             margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
  //             padding: EdgeInsets.symmetric(vertical: 77.6),
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 boxShadow: <BoxShadow>[
  //                   BoxShadow(
  //                       color: Colors.black26,
  //                       blurRadius: 3.0,
  //                       offset: Offset(20.0, 9.0),
  //                       spreadRadius: 10.0)
  //                 ]),
  //             child: Center(
  //               child: Column(
  //                 children: <Widget>[
  //                   Text('Iniciar Sesión', style: TextStyle(fontSize: 20.0)),
  //                   SizedBox(height: 60.0),
  //                   _createEmail(bloc),
  //                   SizedBox(height: 30.0),
  //                   _createPassword(bloc),
  //                   SizedBox(height: 30.0),
  //                   _createButton(bloc, context),
  //                   SizedBox(height: 30.0),
  //                   _createLink(bloc)
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _createEmail(LoginBloc bloc) {
  //   return StreamBuilder(
  //     stream: bloc.emailStream,
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       return Container(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 35.0),
  //           child: Padding(
  //             padding: const EdgeInsets.only(),
  //             child: TextField(
  //               controller: email,
  //               decoration: InputDecoration(
  //                   icon: Icon(Icons.email, color: Colors.green[800]),
  //                   border: OutlineInputBorder(),
  //                   hintText: 'ejemplo@correo.com',
  //                   labelText: 'Correo Electronico',
  //                   errorText: snapshot.error),
  //               onChanged: bloc.changeEmail,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _createPassword(LoginBloc bloc) {
  //   return StreamBuilder(
  //     stream: bloc.passwordStream,
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       return Container(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 35.0),
  //           child: Padding(
  //             padding: const EdgeInsets.only(),
  //             child: TextField(
  //               controller: password,
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                   icon: Icon(Icons.lock, color: Colors.green[800]),
  //                   border: OutlineInputBorder(),
  //                   labelText: 'Contraseña',
  //                   errorText: snapshot.error),
  //               onChanged: bloc.changePassword,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _createButton(LoginBloc bloc, BuildContext context) {
  //   return StreamBuilder(
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       return Padding(
  //         padding: const EdgeInsets.only(),
  //         child: RaisedButton(
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
  //               child: Text('Iniciar Sesión'),
  //             ),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8.0)),
  //             elevation: 0.0,
  //             color: Colors.green[800],
  //             textColor: Colors.white,
  //             onPressed: () async{
  //               final cellPhoneToken = await pushNotificationProvider.initNotifications();

  //               loginController.login(
  //                   context, {'email': email.text, 'password': password.text}, cellPhoneToken);
  //             }
  //             ),
  //       );
  //     },
  //   );
  // }

  _createDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: new Text("Introduce tu Correo:"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: <Widget>[
                Text('Se enviara tu nueva contraseña a este correo.',
                  style: TextStyle(
                    fontSize: 15.0, 
                    fontWeight: FontWeight.w700
                  )
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: emailsend,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ]
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Enviar'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Colors.green[800],
              onPressed: () {
                recoverPasswordController
                  .recoverPassword(emailsend.text.trim(), {}).then((res) {
                    print('RESPONSE SEND EMAIL: ' + res.toString());
                  recoverPasswordController.checkEmail(context, res);
                });
                print('correo enviado ${emailsend.text}');
              }
            ),
            
            // usually buttons at the bottom of the dialog
            MaterialButton(
              elevation: 5.0,
              child: Text('Cerrar'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              color: Colors.green[800],
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      }
    );
  }
}
