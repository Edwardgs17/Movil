import 'package:colfunding/src/users/controllers/ChangePasswordController.dart';
import 'package:flutter/material.dart';

import '../../../utils/Session.dart';
import '../../../utils/Sidebar.dart';
import 'package:colfunding/utils/NavigationBloc.dart';

class PageChangePassword extends StatefulWidget with NavigationStates {
  final title;

  PageChangePassword({this.title});

  @override
  _PageChangePasswordState createState() => _PageChangePasswordState();
}

class _PageChangePasswordState extends State<PageChangePassword> {
  Map<String, dynamic> user;

  final formKey = GlobalKey<FormState>();

  Sidebar sidebar;
  Session session;

  TextEditingController oldPassword, newPassword, confirmPassword;

  ScrollController _scrollController = new ScrollController();

  ChangePasswordController changePasswordController;

  _PageChangePasswordState() {
    oldPassword = TextEditingController();
    newPassword = TextEditingController();
    confirmPassword = TextEditingController();

    changePasswordController = new ChangePasswordController();

    session = new Session();

    sidebar = Sidebar(
      page: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.enhanced_encryption,
                color: Colors.transparent,
              ),
              onPressed: null),
          title: Text('Cambiar contraseña',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              )),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 30.0, left: 03.0, right: 03.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        children: <Widget>[
                          _actualPassword(),
                          SizedBox(
                            height: 18.0,
                          ),
                          _newPassword(),
                          SizedBox(
                            height: 18.0,
                          ),
                          _confirmPassword(),
                          SizedBox(
                            height: 13.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _createButton(),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _actualPassword() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 09.0, vertical: 00.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Contraseña actual",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Contraseña',
                  ),
                  validator: (input) =>
                      input.length > 6 ? null : 'Digite su contraseña actual',
                  controller: oldPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _newPassword() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 09.0, vertical: 00.0),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nueva Contraseña",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Contraseña',
                  ),
                  validator: (input) => input.length >= 6
                      ? null
                      : 'Debe contener mínimo 6 caracteres',
                  controller: newPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmPassword() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 09.0, vertical: 00.0),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Confirmar nueva contraseña",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Contraseña',
                  ),
                  validator: (input) => input.length >= 6
                      ? null
                      : 'Debe contener mínimo 6 caracteres',
                  controller: confirmPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createButton() {
    return InkWell(
        onTap: _onSubmit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
              padding: EdgeInsets.only(top: 10.0, left: 08.0, right: 08.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.green[800]],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      'Actualizar',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 21),
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ));
  }

  // Widget _createButton(BuildContext context) {
  //   return Container(
  //     child: Padding(
  //         padding: EdgeInsets.only(bottom: 20),
  //         child: ButtonTheme(
  //           height: 35.0,
  //           minWidth: 200.0,
  //           child: RaisedButton(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             child: Text(
  //               'Actualizar',
  //               style: TextStyle(fontSize: 15.0),
  //             ),
  //             color: Colors.green,
  //             textColor: Colors.white,
  //             onPressed: _onSubmit,
  //           ),
  //         )),
  //   );
  // }

  void _onSubmit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      String email;

      this.user = await session.getInformation().catchError((error) async {
        await session.renovate();
      });

      email = this.user['email'];

      if (newPassword.text == confirmPassword.text) {
        Map body = {
          "password": oldPassword.text,
          "newPassword": confirmPassword.text
        };

        await session.renovate();

        Map<String, dynamic> messages =
            await changePasswordController.changePassword(email, body);

        if (messages['message'] == '¡Contraseña Actualizada!') {
          changePasswordController.showAlert(context, 'Éxito',
              messages['message'], Icons.check_circle, Colors.green);
          _cleanFields();
        } else {
          changePasswordController.showAlert(context, 'Error',
              messages['message'], Icons.highlight_off, Colors.red);
        }
      } else {
        changePasswordController.showAlert(context, '¡Verificar!',
            'Las contraseñas no coinciden', Icons.info, Colors.green[800]);
      }
    }
  }

  void _cleanFields() {
    oldPassword.text = '';
    newPassword.text = '';
    confirmPassword.text = '';
  }
}
