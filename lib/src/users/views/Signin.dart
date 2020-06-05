import 'package:colfunding/src/Notifications/Providers/NotificationsProvider.dart';
import 'package:colfunding/src/users/views/PasswordTextField.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/validators/provider.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/src/users/controllers/SigninController.dart';
import 'package:colfunding/src/Notifications/Providers/ConfigurePushNotificationsProvider.dart';

class Signin extends StatefulWidget {
  
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  
  TextEditingController email;
  TextEditingController password;
  SigninController signinController;
  PushNotificationProvider pushNotificationProvider;
  NotificationsProvider notificationsProvider;
  Alert alert;

  String emailError    = '';
  String passwordError = '';

  _SigninState() {
    this.email = TextEditingController();
    this.password = TextEditingController();
    this.signinController = SigninController();
    this.pushNotificationProvider = PushNotificationProvider();
    this.notificationsProvider = NotificationsProvider();
    this.alert = Alert();
  }

  @override
  Widget build(BuildContext context) {

    final bloc    = Provider.of(context);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 80.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 120.0, 0.0, 0.0),
                    child: Text(
                      'Colfunding',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 170.0, 0.0, 0.0),
                    child: Text(
                      'Registro de usuario',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(238.0, 155.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),
                    ),
                  )
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Form(
                key: formKey,
                  child: Column(
                  children: <Widget>[

                    StreamBuilder(
                      stream: bloc.emailStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {

                        emailError = snapshot.error.toString();
                        
                        return TextFormField(
                          controller: this.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'CORREO' ,
                            hintText: 'ejemplo@gmail.com',
                            labelStyle: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                            ),
                            fillColor: Colors.green,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green
                              )
                            ),
                            errorText: snapshot.error
                          ),
                          onChanged: bloc.changeEmail,
                          maxLines: 1,
                        );
                      }
                    ),

                    SizedBox(
                      height: 20.0,
                    ),

                    StreamBuilder(
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

                        //  return TextFormField(
                        //   controller: this.password,
                        //   obscureText: true,
                        //   decoration: InputDecoration(
                        //     labelText: 'CONTRASEÑA' ,
                        //     labelStyle: TextStyle(
                        //       fontSize: 12.0,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.grey
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
                    ),

                    SizedBox(height: 50.0),

                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: InkWell(
                          onTap: _submit,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(
                                width: 5.0,
                              ),

                              Center(
                                child: Text(
                                  'Registrar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ),

                    SizedBox(height: 20.0),

                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pushNamed('Login'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Icon(
                                  Icons.replay,
                                ),
                              ),

                              SizedBox(
                                width: 5.0,
                              ),

                              Center(
                                child: Text(
                                  'Volver',
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
                    
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ]
        ),
      )
    );
  }

  void _submit() async{
    if (this.email.text.trim() != '' && this.password.text.trim() != '') {
      if (emailError == 'null' && passwordError == 'null') {
        
        final cellPhoneToken = await pushNotificationProvider.initNotifications();
        
        await signinController.signin(context, {
          'email': this.email.text.trim(),
          'password': this.password.text.trim(),
        }).then((resp){
          if(resp == null) {
            alert.showSuccesAlert(
              context,
              '¡Error!', 'Ya existe un usuario con este correo',
              Icons.highlight_off,
              Colors.red
            );
          } else {
            notificationsProvider.createDeviceToken({
              'deviceToken': cellPhoneToken,
              'idUser': resp[0]['id']    
            });
            print(resp[0]['id']);
            print(cellPhoneToken);  
          }
        });
      } else {
        alert.showSuccesAlert(context, '¡Verificar!', 'Datos incorrectos', Icons.highlight_off, Colors.red);
      }
    } else {
      alert.showSuccesAlert(context, '¡Verificar!', 'Campos vacios', Icons.info, Colors.blue);
    }
  }
}