import 'dart:io';

import 'package:colfunding/src/projects/controllers/CreateHomeWorkController.dart';
import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Camera.dart';
import 'package:colfunding/utils/Cloudinary.dart';
import 'package:colfunding/utils/Modals.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:colfunding/utils/Utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CreateHomeWork extends StatefulWidget {
  final title;

  CreateHomeWork({this.title});

  @override
  CreateHomeWorkState createState() => CreateHomeWorkState();
}

class CreateHomeWorkState extends State<CreateHomeWork> {
  Cloudinary cloudinary;
  File image;
  String imageUrl;
  Camera camera;
  TextEditingController description, name, objectives, minimalCost, optimalCost;
  CreateHomeWorkController createHomeWorkController;
  Modals modals;
  Sidebar sidebar;
  Session session;
  Map user;
  bool botton;
  final formKey = GlobalKey<FormState>();
  Token token;
  SeeProjectController seeProjectController;
  HomeworkController homeworkController;
  ProgressDialog progressDialog;
  Alert alert;
  CreateHomeWorkState() {
    camera = new Camera();
    botton = true;
    name = TextEditingController();
    description = TextEditingController();
    objectives = TextEditingController();
    minimalCost = TextEditingController();
    optimalCost = TextEditingController();
    cloudinary = Cloudinary();
    createHomeWorkController = CreateHomeWorkController();
    homeworkController = HomeworkController();
    seeProjectController = SeeProjectController();
    token = Token();
    session = new Session();
    alert = Alert();
    modals = Modals();
    sidebar = Sidebar(
      page: 2,
    );
  }
  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Guardando tarea',
      borderRadius: 15.0,
      backgroundColor: Colors.black,
      progressWidget: CircularProgressIndicator(),
      elevation: 20.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            child: AppBar(
              backgroundColor: Colors.green,
              title: Text('Crear tarea',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  )),
              actions: <Widget>[
                // IconButton(
                //   icon: Icon(Icons.photo_size_select_actual),
                //   onPressed: _selectPhoto,
                // ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _takePhoto,
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 03.0, right: 03.0),
                child: Form(
                  key: formKey,
                  child: Card(
                    child: Column(
                      children: <Widget>[

                        _showPhoto(),
                        SizedBox(
                          height: 15.0,
                        ),
                        _createName(),
                        SizedBox(
                          height: 18.0,
                        ),
                        _createDescription(),
                        SizedBox(
                          height: 18.0,
                        ),
                        _createObjectives(),
                        SizedBox(
                          height: 18.0,
                        ),
                        _createMinimalCost(),
                        SizedBox(
                          height: 18.0,
                        ),
                        _createOptimalCost(),
                        SizedBox(
                          height: 18.0,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _createName() {
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
                  "Nombre",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: name,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Nombre de la tarea',
                  ),
                  validator: (value) {
                    if (value.length < 3) {
                      return 'Ingrese el nombre de la tarea';
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createDescription() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 09.0, vertical: 00.0),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: Container(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Descripción",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0, color: Colors.green[800]),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      maxLines: 4,
                      controller: description,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(05.0)),
                        hintText: 'Descripción de la tarea',
                      ),
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Ingrese la descripción de la tarea';
                        } else {
                          return null;
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createObjectives() {
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
                  "Objetivos",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                    maxLines: 4,
                    controller: objectives,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(05.0),
                      ),
                      hintText: 'Objetivos de la tarea',
                    ),
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Ingrese los objetivos de la tarea';
                      } else {
                        return null;
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createMinimalCost() {
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
                  "Costo min",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: minimalCost,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Costo Minimo',
                  ),
                  validator: (value) {
                    if (utils.isNumeric(value)) {
                      return null;
                    } else {
                      return 'Solo numeros';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createOptimalCost() {
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
                  "Costo opt",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: optimalCost,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Costo Optimo',
                  ),
                  validator: (value) {
                    if (utils.isNumeric(value)) {
                      return null;
                    } else {
                      return 'Solo numeros';
                    }
                  },
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
        onTap: () async {
          print(image);
          print(botton);
          if (!formKey.currentState.validate()) return;
          formKey.currentState.save();
          if (image != null && botton) {
            progress();
            progressDialog.show();
            botton = false;
            imageUrl = await cloudinary.uploadImage(image);
            await session.renovate();
            double minimal_Cost = double.parse(minimalCost.text);
            double optimal_Cost = double.parse(optimalCost.text);
            print(((minimal_Cost < await token.getNumber('minimal_Cost')) &&
                (optimal_Cost < await token.getNumber('optimal_Cost'))));
            if ((minimal_Cost < await token.getNumber('minimal_Cost')) &&
                (optimal_Cost < await token.getNumber('optimal_Cost')) &&
                optimal_Cost > minimal_Cost) {
              await progressDialog.hide();
             alert.errorAlert(context, "Advertencia",
              "Aun no has creado tareas", Icons.warning, Colors.yellow);
    }

            final int id = await token.getNumber('idProject');
            createHomeWorkController.createHomework({
              'idProject': id,
              'name': name.text,
              'description': description.text,
              'objectives': objectives.text,
              'idTypeHomework': 1,
              'minimal_cost': minimal_Cost,
              'optimal_cost': optimal_Cost
            }).then((res) async {
              Future.delayed(Duration(seconds: 3)).then((value) {
                progressDialog.hide().whenComplete(() {
                  createHomeWorkController.createImageHomework({
                    'idHomework': res['id'],
                    'urlPhoto': [imageUrl]
                  });
                  homeworkController.getHomeworkDatails(context, id, true);
                });
              });
            });
            setState(() {});
          } else {
            Alert().showAlert(context, "Verificar",
                "Seleccione o tome una foto", Icons.info, Colors.green);
          }
        },
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
        ));
  }

  // Widget _createButton() {
  //   return Container(
  //     child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
  //         child: ButtonTheme(
  //           padding: EdgeInsets.only(),
  //           height: 35.0,
  //           minWidth: 200.0,
  //           child: RaisedButton(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             child: Text('Guardar y continuar'),
  //             color: Colors.green[800],
  //             textColor: Colors.white,
  //             onPressed: () async {
  //               print(image);
  //               print(botton);
  //               if (!formKey.currentState.validate()) return;
  //               formKey.currentState.save();
  //               if (image != null && botton) {
  //                 progress();
  //                 progressDialog.show();
  //                 botton = false;
  //                 await session.renovate();
  //                 imageUrl = await cloudinary.uploadImage(image);
  //                 double minimal_Cost = double.parse(minimalCost.text);
  //                 double optimal_Cost = double.parse(optimalCost.text);
  //                 print(((minimal_Cost <
  //                         await token.getNumber('minimal_Cost')) &&
  //                     (optimal_Cost < await token.getNumber('optimal_Cost'))));
  //                 if ((minimal_Cost < await token.getNumber('minimal_Cost')) &&
  //                     (optimal_Cost < await token.getNumber('optimal_Cost')) &&
  //                     optimal_Cost > minimal_Cost) {
  //                   await progressDialog.hide();
  //                   alert.errorAlert(context,
  //                       'el costo minimo y optimo de una tarea debe ser menor al del proyecto, el costo optimo debe ser mayor al minimo');

  //                   return;
  //                 }

  //                 final int id = await token.getNumber('idProject');
  //                 createHomeWorkController.createHomework({
  //                   'idProject': id,
  //                   'name': name.text,
  //                   'description': name.text,
  //                   'objectives': objectives.text,
  //                   'idTypeHomework': 1,
  //                   'minimal_cost': minimal_Cost,
  //                   'optimal_cost': optimal_Cost
  //                 }).then((res) async {
  //                   Future.delayed(Duration(seconds: 3)).then((value) {
  //                     progressDialog.hide().whenComplete(() {
  //                       createHomeWorkController.createImageHomework({
  //                         'idHomework': res['id'],
  //                         'urlPhoto': [imageUrl]
  //                       });
  //                       homeworkController.getHomeworkDatails(
  //                           context, id, true);
  //                     });
  //                   });
  //                 });
  //                 setState(() {});
  //               } else {
  //                 Alert().showAlert(context, "Verificar",
  //                     "Seleccione o tome una foto", Icons.info, Colors.green);
  //               }
  //             },
  //           ),
  //         )),
  //   );
  // }

  void _selectPhoto() async {
    _processImage(ImageSource.gallery);
  }

  void _takePhoto() async {
    List files = await camera.getImages(1);
    image = files[0] ?? null;

    setState(() {
      imageUrl = '';
    });
    cloudinary.uploadImage(image).then((url) {
      setState(() {
        imageUrl = url;
      });
    }).catchError((error) {
      setState(() {
        imageUrl = null;
      });
    });
    //_processImage(ImageSource.camera);
  }

  _processImage(ImageSource origen) async {
    image = await ImagePicker.pickImage(
        source: origen, maxHeight: 1400.0, maxWidth: 2000.0);

    if (image != null) {
      imageUrl = null;
    }

    setState(() {});
  }

  Widget _showPhoto() {
    if (imageUrl != null) {
      return FadeInImage(
        image: NetworkImage(imageUrl),
        placeholder: AssetImage('assets/loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return FadeInImage(
        image: NetworkImage(imageUrl ?? ''),
        placeholder: AssetImage('assets/notfound.png'),
        width: 345,
        height: 300.0,
        fit: BoxFit.fill,
      );
    }
  }
}
