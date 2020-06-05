import 'dart:io';
import 'package:colfunding/src/projects/controllers/CreateRewardController.dart';
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
import 'dart:async';
import 'package:colfunding/src/projects/controllers/RewardsController.dart';

class CreateReward extends StatefulWidget {
  final title;

  CreateReward({this.title});

  @override
  CreateRewardState createState() => CreateRewardState();
}

class CreateRewardState extends State<CreateReward> {
  Cloudinary cloudinary;
  File image;
  String imageUrl;
  RewardsController rewardsController;
  TextEditingController description, price;
  CreateRewardController createRewardController;
  Modals modals;
  Sidebar sidebar;
  Session session;
  Map user;
  bool botton;
  final formKey = GlobalKey<FormState>();
  Token token;
  SeeProjectController seeProjectController;
  ProgressDialog progressDialog;
  Camera camera;
  CreateRewardState() {
    camera = Camera();
    botton = true;
    description = TextEditingController();
    price = TextEditingController();
    cloudinary = Cloudinary();
    createRewardController = CreateRewardController();
    seeProjectController = SeeProjectController();
    rewardsController = RewardsController();
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
      message: 'Guardando Recompensa',
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
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Crear Recompensa',
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          ),
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
                        SizedBox(
                          height: 15.0,
                        ),
                        _showPhoto(),
                        SizedBox(
                          height: 15.0,
                        ),
                        _createDescription(),
                        SizedBox(
                          height: 15.0,
                        ),
                        _createPrice(),
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0,color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                    maxLines: 4,
                    controller: description,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(05.0)),
                      hintText: 'Descripción de recompensa',
                    ),
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Ingrese la descripción de la recompensa';
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

  Widget _createPrice() {
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
                  "Precio",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0, color: Colors.green[800]),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: price,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),
                    hintText: 'Precio de la recompensa',
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
            await session.renovate();
            imageUrl = await cloudinary.uploadImage(image);

            final int id = await token.getNumber('idProject');
            createRewardController.createReward({
              'idProjects': id,
              'description': description.text,
              'idTypeRewards': 1,
              'price': price.text
            }).then((res) async {
              Future.delayed(Duration(seconds: 3)).then((value) {
                progressDialog.hide().whenComplete(() {
                  createRewardController.createImageReward({
                    'idReward': res["id"],
                    'urlPhoto': [imageUrl]
                  });
                  rewardsController.getRewardsDatails(context, id, true);
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

  //                 final int id = await token.getNumber('idProject');
  //                 createRewardController.createReward({
  //                   'idProjects': id,
  //                   'description': description.text,
  //                   'idTypeRewards': 1,
  //                   'price': price.text
  //                 }).then((res) async {
  //                   Future.delayed(Duration(seconds: 3)).then((value) {
  //                     progressDialog.hide().whenComplete(() {
  //                       createRewardController.createImageReward({
  //                         'idReward': res["id"],
  //                         'urlPhoto': [imageUrl]
  //                       });
  //                       rewardsController.getRewardsDatails(context, id, true);
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
        width: 320,
        height: 300.0,
        fit: BoxFit.fill,
      );
    }
  }
}
