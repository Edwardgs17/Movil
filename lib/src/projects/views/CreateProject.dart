import 'dart:io';

import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/utils/Camera.dart';
import 'package:colfunding/utils/Cloudinary.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/src/projects/controllers/createProjectController.dart';
import 'package:colfunding/src/projects/controllers/InvestmentsController.dart';
import 'package:colfunding/src/projects/models/target_models.dart';
import 'package:colfunding/utils/Utils.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class CreateProject extends StatefulWidget {
  CreateProject();

  @override
  CreateProjectState createState() => CreateProjectState();
}

class CreateProjectState extends State<CreateProject> {
  Camera camera;
  TextEditingController title;
  TextEditingController description;
  TextEditingController objectives;
  TextEditingController targetAudience;
  TextEditingController process;
  TextEditingController minimalCost;
  TextEditingController optimalCost;
  TextEditingController location;
  CreateProjectController createProjectController;
  InvestmentsController investmentsController;
  Cloudinary cloudinary;
  Session session;
  Sidebar sidebar;
  bool isSave;
  SeeProjectController seeProjectController;
  Token token;
  CreateProjectState() {
    this.camera = Camera();
    this.isSave = false;
    this.session = new Session();
    this.title = TextEditingController();
    this.description = TextEditingController();
    this.objectives = TextEditingController();
    this.targetAudience = TextEditingController();
    this.process = TextEditingController();
    this..minimalCost = TextEditingController();
    this.optimalCost = TextEditingController();
    this.location = TextEditingController();
    this.createProjectController = CreateProjectController();
    this.investmentsController = InvestmentsController();
    this.cloudinary = Cloudinary();
    this.seeProjectController = SeeProjectController();
    this.token = Token();
  }

  TargetAudiences _currentTarget = new TargetAudiences(11, "Seleccionar:");
  File image;
  String imageUrl;
  final formKey = GlobalKey<FormState>();
  ProgressDialog progressDialog;

  Iterable<dynamic> listTargetAudience = [];

  Future<List<dynamic>> getListTargetAudience() async {
    List<dynamic> lista =
        await createProjectController.listTargetAudience(context);

    setState(() {
      listTargetAudience = lista;
    });

    return lista;
  }

  @override
  void initState() {
    super.initState();

    getListTargetAudience();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            child: AppBar(
              backgroundColor: Colors.green,
              title: Text("Crear Proyecto",
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
                      child: Column(children: <Widget>[
                        _showPhoto(),
                        SizedBox(
                          height: 15.0,
                        ),
                        _createTitle(),
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
                          height: 18.0,
                        ),
                        _createLocation(),
                        SizedBox(
                          height: 13.0,
                        ),
                      ]),
                    ),
                  )),
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

  Widget _createTitle() {
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
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: Colors.green[600]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Nombre del proyecto',
                  ),
                  validator: (value) {
                    if (value.length < 3) {
                      return 'Ingrese el nombre del proyecto';
                    } else {
                      return null;
                    }
                  },
                ),
              ])),
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
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        color: Colors.green[600]),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      maxLines: 4,
                      controller: description,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(05.0)),
                        hintText: 'Descripción del proyecto',
                      ),
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Ingrese la descripción del proyecto';
                        } else {
                          return null;
                        }
                      }),
                ]))),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: Colors.green[600]),
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
                      hintText: 'Objetivos del proyecto',
                    ),
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Ingrese los objetivos del proyecto';
                      } else {
                        return null;
                      }
                    }),
              ])),
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
              child: Container(
                child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Text(
                        "Compromiso social",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            color: Colors.green[600]),
                      ),
                      SizedBox(height: 10.0),
                      Row(
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
                                        child: Text(_currentTarget.name)),
                                    items: listTargetAudience.map((target) {
                                      return DropdownMenuItem(
                                          value: target,
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10.0, 0.0, 0.0, 0.0),
                                              child: Text(target.name)));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _currentTarget = value;
                                      });
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
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
                  "Costo minimo",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: Colors.green[600]),
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
              ])),
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
                  "Costo optimo",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: Colors.green[600]),
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

  Widget _createLocation() {
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
                  "Ubicación",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Colors.green[600],
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                    controller: location,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(06.0),
                      ),
                      hintText: 'Ubicación',
                    ),
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Ingrese la ubicación del proyecto';
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
        width: 350,
        fit: BoxFit.fill,
      );
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
        source: origen); //, maxHeight: 1400.0, maxWidth: 2000.0);S
    if (image != null) {
      imageUrl = null;
    }

    setState(() {});
  }

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Guardando proyecto',
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

  Widget _createButton() {
    return InkWell(
        onTap: _submit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
              padding: EdgeInsets.only(top: 10.0, left: 08.0, right: 08.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
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
        ));
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {});
    final user = await session.getInformation();
    if (image != null && !isSave) {
      isSave = true;
      imageUrl = await cloudinary.uploadImage(image);
      await session.renovate();

      progress();
      progressDialog.show();

      createProjectController.createProject(context, {
        'idUser': user['id'],
        'title': title.text,
        'description': description.text,
        'objectives': objectives.text,
        'targetAudience': _currentTarget.id,
        'minimal_cost': minimalCost.text,
        'optimal_cost': optimalCost.text,
        'location': location.text,
        'process': 1
      }).then((res) async {
        token.setNumber('idProject', res["id"]);

        Future.delayed(Duration(seconds: 3)).then((value) {
          progressDialog.hide().whenComplete(() {
            createProjectController.saveImage(context, {
              'idProject': res["id"],
              'urlPhoto': [imageUrl]
            });

            seeProjectController.getProjectDatails(context, res['id'], true);
          });
        });
      });
    } else {
      createProjectController.showAlert(context, "Verificar",
          "Seleccione o tome una foto", Icons.info, Colors.green);
    }
  }
}
