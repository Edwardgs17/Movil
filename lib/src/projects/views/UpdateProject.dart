import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/src/projects/controllers/UpdateProjectController.dart';
import 'package:colfunding/src/projects/models/target_models.dart';
import 'package:colfunding/src/users/controllers/UpdateUserController.dart';
import 'package:colfunding/utils/Modals.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:colfunding/utils/Utils.dart' as utils;

class UpdateProject extends StatefulWidget {
  final Map projectDetail;

  UpdateProject({this.projectDetail});

  @override
  UpdateProjectState createState() =>
      UpdateProjectState(projectDetail: this.projectDetail);
}

class UpdateProjectState extends State<UpdateProject> {
  final formKey = GlobalKey<FormState>();

  Map projectDetail;
  UpdateUserController updateUserController;
  Modals modals;
  Sidebar sidebar;
  Session session;
  bool botton;
  TextEditingController title;
  TextEditingController description;
  TextEditingController objectives;
  TextEditingController targetAudience;
  TextEditingController process;
  TextEditingController minimalCost;
  TextEditingController optimalCost;
  TextEditingController location;
  UpdateProjectController updateProjectController;
  ProgressDialog progressDialog;
  SeeProjectController seeProjectController;
  TargetAudiences _targetAudiences;
  Iterable<dynamic> listTargetAudiences = [];

  Token token;

  UpdateProjectState({this.projectDetail}) {
    this.session = new Session();
    this.title = TextEditingController();
    this.description = TextEditingController();
    this.objectives = TextEditingController();
    this.targetAudience = TextEditingController();
    this.process = TextEditingController();
    this..minimalCost = TextEditingController();
    this.optimalCost = TextEditingController();
    seeProjectController = SeeProjectController();
    this.location = TextEditingController();
    this.updateProjectController = UpdateProjectController();
    this.token = Token();
    _targetAudiences = new TargetAudiences(5, "Seleccione");

    getListTargetAudiences();
    loadInformation();
  }

  void loadInformation() {
    this.title.text = projectDetail['title'];
    this.description.text = projectDetail['description'];
    this.objectives.text = projectDetail['objectives'];
    this.process.text = projectDetail['process'];
    this.minimalCost.text = projectDetail['minimal_cost'].toString();
    this.optimalCost.text = projectDetail['optimal_cost'].toString();
    this.location.text = projectDetail['location'];
  }

  Future<List<dynamic>> getListTargetAudiences() async {
    List<dynamic> list =
        await updateProjectController.listTargetAudience(context);

    listTargetAudiences = list;
    print(projectDetail);
    for (var item in listTargetAudiences) {
      if (item.name == projectDetail["targetAudience"]) {
        setState(() {
          this._targetAudiences = item;
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
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            child: AppBar(
              centerTitle: true,
              backgroundColor: Colors.green,
              title: Text("Actualizar Proyecto",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  )),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10.0, left: 03.0, right: 03.0),
                  child: Form(
                    child: Card(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 10.0,
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Nombre del proyecto',
                  ),
                  controller: title,
                  validator: (value) {
                    if (value.length < 3) {
                      return 'Ingrese el nombre del proyecto';
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
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(05.0)),
                        hintText: 'Descripción del proyecto',
                      ),
                      controller: description,
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Ingrese la descripción del proyecto';
                        } else {
                          return null;
                        }
                      }),
                ],
              ),
            )),
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
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(05.0),
                      ),
                      hintText: 'Objetivos del proyecto',
                    ),
                    controller: objectives,
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Ingrese los objetivos del proyecto';
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
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Compromiso social",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15.0),
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
                                    hint: Text(_targetAudiences.name),
                                    items: listTargetAudiences
                                        .map((targetAudience) {
                                      return DropdownMenuItem(
                                          value: targetAudience,
                                          child: Text(targetAudience.name));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _targetAudiences = value;
                                      });
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                  controller: optimalCost,
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(05.0),
                      ),
                      hintText: 'Ubicación del proyecto',
                    ),
                    controller: location,
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

  Widget _createButton() {
    return InkWell(
        onTap: () {
          _submit();
        },
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

  // Widget _createButton(BuildContext context) {
  //   return Container(
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
  //       child: ButtonTheme(
  //         minWidth: 200.0,
  //         height: 35.0,
  //         child: RaisedButton.icon(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8.0),
  //           ),
  //           color: Colors.green[800],
  //           textColor: Colors.white,
  //           label: Text('Guardar'),
  //           icon: Icon(Icons.save),
  //           onPressed: () {
  //             _submit();
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Actualizando Proyecto',
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
    progress();
    progressDialog.show();
    await session.renovate();
    await updateProjectController
        .updateProject(context, this.projectDetail["id"], {
      'title': title.text,
      'description': description.text,
      'objectives': objectives.text,
      'minimal_cost': minimalCost.text,
      'optimal_cost': optimalCost.text,
      'location': location.text,
      'process': 1,
      "targetAudience": _targetAudiences.id
    }).then((res) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        progressDialog.hide().whenComplete(() {
          seeProjectController.getProjectDatails(
              context, this.projectDetail["id"], true);
        });
        print(projectDetail);
      });
    });
  }
}
