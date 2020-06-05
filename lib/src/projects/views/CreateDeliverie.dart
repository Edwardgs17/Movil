import 'dart:io';

import 'package:colfunding/src/projects/controllers/DeliveriesController.dart';
import 'package:colfunding/utils/Alerts.dart';
import 'package:colfunding/utils/Camera.dart';
import 'package:colfunding/utils/Cloudinary.dart';
import 'package:colfunding/utils/Modals.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CreateDeliverie extends StatefulWidget {
  final title;

  CreateDeliverie({this.title});

  @override
  CreateDeliverieState createState() => CreateDeliverieState();
}

class CreateDeliverieState extends State<CreateDeliverie> {
  Cloudinary cloudinary;
  File image;
  String imageUrl;
  Camera camera;
  TextEditingController description;
  DeliveriesController deliveriesController;
  Modals modals;
  Sidebar sidebar;
  Session session;
  Map user;
  bool botton;
  final formKey = GlobalKey<FormState>();
  Token token;
  ProgressDialog progressDialog;

  CreateDeliverieState() {
    camera = new Camera();
    botton = true;
    deliveriesController = DeliveriesController();
    this.description = TextEditingController();
    cloudinary = Cloudinary();
    token = Token();
    session = new Session();

    modals = Modals();
    sidebar = Sidebar(
      page: 2,
    );
  }
  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Guardando Entrega',
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
              title: Text('Subir Entrega',
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
                        _createDescription(),
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
                        hintText: 'Descripción de la entrega',
                      ),
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Ingrese la descripción de la entrega';
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
            await session.renovate();
            imageUrl = await cloudinary.uploadImage(image);
            final int id = await token.getNumber('idHomework');
            print(id);
            print('################################');
            print(id);
            print(description.text);
            print('################################');
            deliveriesController.createDeliveries(context, {
              'idHomework': id,
              'description': description.text,
              'process': 1,
            }).then((res) async {
              Future.delayed(Duration(seconds: 3)).then((value) {
                progressDialog.hide().whenComplete(() {
                  deliveriesController.saveImagesDeliveries(context,
                      {'idDeliverie': res['id'], 'urlPhoto': imageUrl});
                  deliveriesController.getDeliveriesDatails(context, id, true);
                });
              });
            });
            setState(() {});
          } else {
            Alert().showAlert(context, "Verificar",
                "Seleccione o tome una foto", Icons.info, Colors.green);
          }
        },
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
            )));
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
  //                 final int id = await token.getNumber('idHomework');
  //                 print(id);
  //                 print('################################');
  //                 print(id);
  //                 print(description.text);
  //                 print('################################');
  //                 deliveriesController.createDeliveries(context, {
  //                   'idHomework': id,
  //                   'description': description.text,
  //                   'process': 1,
  //                 }).then((res) async {
  //                   Future.delayed(Duration(seconds: 3)).then((value) {
  //                     progressDialog.hide().whenComplete(() {
  //                       deliveriesController.saveImagesDeliveries(context,
  //                           {'idDeliverie': res['id'], 'urlPhoto': imageUrl});
  //                       deliveriesController.getDeliveriesDatails(
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
        width: 350,
        height: 300.0,
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
}
