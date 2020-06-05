import 'dart:io';

import 'package:colfunding/src/projects/controllers/EditHomeworkController.dart';
import 'package:colfunding/src/projects/controllers/HomeworkController.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/src/projects/models/typeHomeworkModel.dart';
import 'package:colfunding/utils/Camera.dart';
import 'package:colfunding/utils/Cloudinary.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:colfunding/utils/Utils.dart' as utils;

class EditHomeworkPage extends StatefulWidget {
  final Map homeworkDetail;
  final List homeworkImages;

  EditHomeworkPage({this.homeworkDetail, this.homeworkImages});

  @override
  _EditHomeworkPageState createState() => _EditHomeworkPageState(
      homeworkDetail: this.homeworkDetail, homeworkImages: this.homeworkImages);
}

class _EditHomeworkPageState extends State<EditHomeworkPage> {
  final formKey = GlobalKey<FormState>();

  List homeworkImages;
  Map homeworkDetail;
  TextEditingController name;
  TextEditingController description;
  TextEditingController objectives;
  TextEditingController minimalCost;
  TextEditingController optimalCost;
  TextEditingController qualification;
  EditHomeworkController editHomeworkController;
  Token token;
  SeeProjectController seeProjectController;
  HomeworkController homeworkController;
  Session session;
  File image;
  ProgressDialog progressDialog;
  String imageUrl;
  Cloudinary cloudinary;
  Camera camera;
  TypeHomework _currentTypeHomework;
  Iterable<dynamic> listTypeHomework = [];

  _EditHomeworkPageState({this.homeworkDetail, this.homeworkImages}) {
    camera = Camera();
    this.name = TextEditingController();
    this.description = TextEditingController();
    this.objectives = TextEditingController();
    this.minimalCost = TextEditingController();
    this.optimalCost = TextEditingController();
    this.editHomeworkController = EditHomeworkController();
    this.cloudinary = Cloudinary();
    this.session = Session();
    seeProjectController = SeeProjectController();
    homeworkController = HomeworkController();
    token = Token();
    _currentTypeHomework = new TypeHomework(11, "Seleccione");

    _loadInformation();
    getListTypeHomework();
  }

  void _loadInformation() {
    this.name.text = homeworkDetail["name"];
    this.description.text = homeworkDetail["description"];
    this.objectives.text = homeworkDetail["objectives"];
    this.minimalCost.text = homeworkDetail["minimal_cost"].toString();
    this.optimalCost.text = homeworkDetail["optimal_cost"].toString();
    imageUrl = this.homeworkImages[0];
  }

  Future<List<dynamic>> getListTypeHomework() async {
    List<dynamic> list =
        await editHomeworkController.getTypeHomeworkDropdown(context);

    listTypeHomework = list;

    for (var item in listTypeHomework) {
      if (item.name == homeworkDetail["typeHomework"]) {
        setState(() {
          this._currentTypeHomework = item;
        });
      }
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Tarea',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            )),
        backgroundColor: Colors.green,
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
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
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
                      _createDropdown(),
                      SizedBox(
                        height: 18.0,
                      ),
                      _createMinimalCost(),
                      SizedBox(
                        height: 18.0,
                      ),
                      _createOptimalCost(),
                      SizedBox(
                        height: 13.0,
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
    ));
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Descripción",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
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

  Widget _createDropdown() {
    return Container(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 09.0, vertical: 00.0),
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tipo de tarea",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  isExpanded: false,
                                  hint: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Text(_currentTypeHomework.name)),
                                  items: listTypeHomework.map((typeHomework) {
                                    return DropdownMenuItem(
                                        value: typeHomework,
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10.0, 0.0, 0.0, 0.0),
                                            child: Text(typeHomework.name)));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentTypeHomework = value;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
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

  // Widget _createButton() {
  //   return Container(
  //     child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
  //         child: ButtonTheme(
  //           padding: EdgeInsets.only(),
  //           height: 35.0,
  //           minWidth: 200.0,
  //           child: RaisedButton.icon(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8.0)),
  //               label: Text('Actualizar'),
  //               color: Colors.green[800],
  //               textColor: Colors.white,
  //               icon: Icon(Icons.save),
  //               onPressed: _submit),
  //         )),
  //   );
  // }

  Widget _createButton() {
    return InkWell(
        onTap: _submit,
        child: Container(
            padding: EdgeInsets.only(top: 10.0, left: 08.0, right: 08.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: [Colors.greenAccent, Colors.green],
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
            )));
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

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {});

    if (this.homeworkImages.length != 0) {
      String oldImage = this.homeworkImages[0];
      String newImage;

      progress();
      progressDialog.show();

      final int id = await token.getNumber('idProject');

      await session.renovate();

      if (image != null) {
        newImage = await cloudinary.uploadImage(image);

        await editHomeworkController.updateImageHomework(
            this.homeworkDetail["id"], {"urlPhoto": oldImage, "url": newImage});
      }

      await editHomeworkController.updateHomework(this.homeworkDetail["id"], {
        "idProject": this.homeworkDetail["idProject"],
        "name": this.name.text,
        "objectives": this.objectives.text,
        "description": this.description.text,
        "minimal_cost": this.minimalCost.text,
        "optimal_cost": this.optimalCost.text,
        "idTypeHomework": _currentTypeHomework.id
      }).then((res) {
        Future.delayed(Duration(seconds: 3)).then((value) {
          progressDialog.hide().whenComplete(() {
            homeworkController.getHomeworkDatails(
                context, this.homeworkDetail["idProject"], true);
          });
        });
        //editHomeworkController.showAlert(context, "Exitó", "Tarea Actualizada", Icons.check_circle, Colors.green);
      });
    }
  }

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
    // _processImage(ImageSource.camera);
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
        height: 300.0,
        fit: BoxFit.fill,
      );
    }
  }
}
