import 'package:animate_do/animate_do.dart';
import 'package:colfunding/src/users/controllers/UpdateUserController.dart';
import 'package:colfunding/utils/Modals.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/utils/NavigationBloc.dart';
import 'package:intl/intl.dart';

class UpdateUser extends StatefulWidget with NavigationStates {
  final title;

  UpdateUser({this.title});

  @override
  UpdateUserState createState() => UpdateUserState();
}

class UpdateUserState extends State<UpdateUser> {
  TextEditingController document, name, birthday;
  UpdateUserController updateUserController;
  Modals modals;
  Sidebar sidebar;
  Session session;
  Map user;
  bool botton;
  String email, _fecha;

  UpdateUserState() {
    botton = false;
    document = TextEditingController();
    name = TextEditingController();
    birthday = TextEditingController();
    updateUserController = UpdateUserController();
    session = new Session();
    loadInformation();
    modals = Modals();
    sidebar = Sidebar(
      page: 2,
    );
  }

  void loadInformation() {
    session.getInformation().then((user) {
      this.user = user;
      botton = true;
      updateUserController.getUserInformation(user['email']).then((res) {
        setState(() {
          document.text = res['document'].toString() == 'null'
              ? ''
              : res['document'].toString();
          name.text = res['fullname'];
          birthday.text = res['birthday'];
          email = res['email'];
        });
      }).catchError((err) async {
        await session.renovate();
        loadInformation();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.enhanced_encryption,
              color: Colors.transparent,
            ),
            onPressed: null),
        backgroundColor: Colors.green,
        title: Text('Actualizar datos',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            )),
      ),
      body: ZoomIn(
        delay: Duration(milliseconds: 50),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 03.0, right: 03.0),
              child: Form(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      _createNameComplet(),
                      SizedBox(
                        height: 18.0,
                      ),
                      _createDocument(),
                      SizedBox(
                        height: 18.0,
                      ),
                      _email(),
                      SizedBox(
                        height: 18.0,
                      ),
                      _crearFecha(context),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _createButton(),
            SizedBox(
              height: 20.0,
            )
          ]),
        ),
      ),
    ));
  }

  Widget _createNameComplet() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 09.0, vertical: 00.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nombres",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                      color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Nombre',
                  ),
                  controller: name,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createDocument() {
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
                  "Número de identidad",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                      color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Documento',
                  ),
                  controller: document,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _email() {
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
                  "E-mail",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                      color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(05.0),
                      ),
                      hintText: email == null ? '' : email),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 09.0, vertical: 00.0),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Fecha de nacimiento",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15.0,
                    color: Colors.green[800]),
              ),
              SizedBox(height: 10.0),
              TextField(
                enableInteractiveSelection: false,
                controller: birthday,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(05.0),
                  ),
                  hintText: 'Fecha de nacimiento',
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime tempDate;
    if (birthday.text.isNotEmpty) {
      tempDate = new DateFormat("yyyy-MM-dd").parse(birthday.text);
    } else {
      tempDate = DateTime.now();
    }

    DateTime picked = await showDatePicker(
        context: context,
        initialDate: tempDate,
        firstDate: new DateTime(1950),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xFF4CAF50),
              accentColor: const Color(0xFF4CAF50),
              splashColor: const Color(0xFF4CAF50),
            ),
            child: child,
          );
        });

    if (picked != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        _fecha = formattedDate;
        birthday.text = _fecha;
      });
    }
  }

  // Widget _createBirthDate() {
  //   return Container(
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 21.0),
  //       child: Padding(
  //           padding: const EdgeInsets.only(),
  //           child: Row(
  //             children: <Widget>[
  //               Container(
  //                 width: 200.0,
  //                 padding: EdgeInsets.only(top: 20.0),
  //                 child: TextField(
  //                   textAlign: TextAlign.center,
  //                   enabled: false,
  //                   controller: this.birthday,
  //                   decoration: InputDecoration(
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                   width: 65.0,
  //                   padding: EdgeInsets.only(left: 10, top: 30),
  //                   child: RaisedButton(
  //                     child: Icon(Icons.calendar_view_day),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(15.0),
  //                     ),
  //                     onPressed: () {
  //                       this.modals.selectDate(context).then((res) {
  //                         setState(() {
  //                           String date = res.toString().split(' ')[0];
  //                           print(date);
  //                           this.birthday.text = date == 'null' ? '' : date;
  //                         });
  //                       });
  //                     },
  //                   )),
  //             ],
  //           )),
  //     ),
  //   );
  // }

  Widget _createButton() {
    return InkWell(
        onTap: () async {
          if (botton) {
            await session.renovate();
            updateUserController.updateUser(
                this.user['email'] == null ? '' : this.user['email'], {
              'fullname': name.text,
              'document': int.tryParse(document.text),
              'birthday': birthday.text,
            }).then((res) {
              updateUserController.checkUpdate(context, res);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.only(top: 10.0, left: 08.0, right: 08.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green[800]],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        'Guardar',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 21),
                      ),
                      Spacer(),
                    ],
                  ),
                )),
          ),
        ));
    // return Container(
    //   child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
    //       child: ButtonTheme(
    //         padding: EdgeInsets.only(),
    //         height: 35.0,
    //         minWidth: 200.0,
    //         child: RaisedButton(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //           child: Text('Actualizar'),
    //           color: Colors.green[800],
    //           textColor: Colors.white,
    //           onPressed: () async {
    //             if (botton) {
    //               await session.renovate();
    //               updateUserController.updateUser(
    //                   this.user['email'] == null ? '' : this.user['email'], {
    //                 'fullname': name.text,
    //                 'document': int.tryParse(document.text),
    //                 'birthday': _fecha,
    //               }).then((res) {
    //                 updateUserController.checkUpdate(context, res);
    //               });
    //             }
    //           },
    //         ),
    //       )),
    // );
  }
}
