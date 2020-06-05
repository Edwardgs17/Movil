import 'dart:async';
import 'dart:io';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:colfunding/utils/Cloudinary.dart';
import 'package:colfunding/utils/Convert.dart';
import 'package:colfunding/src/projects/controllers/CreateProjectController.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Gallery extends StatefulWidget {
  @override
  GalleryState createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  List<Asset> _imageList = [];
  StreamController _imageListStreamCtrl = StreamController();
  String imageUrl;
  CreateProjectController createProjectController;
  Sidebar sidebar;
  Cloudinary cloudinary;
  Convert convert;
  List<String> images;
  bool isLoadImage;
  Token token;
  SeeProjectController seeProjectController;
  ProgressDialog progressDialog;
  GalleryState() {
    this.createProjectController = CreateProjectController();
    this.cloudinary = Cloudinary();
    this.convert = Convert();
    this.seeProjectController = SeeProjectController();
    sidebar = Sidebar(
      page: 2,
    );
  }
  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Guardando imagenes',
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

  void loadImage() {
    images = [];
    isLoadImage = !(images.length > 0);
    token = new Token();
    token.getList('imagesProject').then((res) {
      setState(() {
        print(res);
        images = res;
        isLoadImage = !(images.length > 0);
      });
    });
  }

  set imageStream(List<Asset> list) {
    _imageList.addAll(list);
    uploadImg(_imageList);
    _imageListStreamCtrl.sink.add(_imageList);
  }

  get imageStream => _imageListStreamCtrl.stream.asBroadcastStream();

  @override
  void dispose() {
    _imageListStreamCtrl.close();
    super.dispose();
  }

  Widget showList() {
    print(images);
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemCount: images.length,
        itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => listZoom(images[index])));
              },
              child: FadeInImage(
                image: NetworkImage(images[index]),
                placeholder: AssetImage('assets/jar-loading.gif'),
                height: 200.0,
                width: 200,
                fit: BoxFit.fill,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Galeria'),
          actions: <Widget>[
            InkWell(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Icon(Icons.photo_camera),
              ),
              onTap: () async {
                getimages();
              },
            )
          ],
        ),
        body: isLoadImage
            ? Center(
                child: GestureDetector(
                onTap: getimages,
                child: Image(
                  image: AssetImage('assets/upload2.png'),
                  width: 200,
                  height: 200,
                ),
              ))
            : showList()),
    );
  }

  Widget pageAlbum() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Album'),
      ),
      drawer: sidebar,
      body: StreamBuilder(
        stream: imageStream,
        builder: (context, snap) {
          if (!snap.hasData) return Container();
          List<Asset> date = snap.data;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: date.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => imageZoom(date[index])));
                    },
                    child: _imageTile(date[index]),
                  ));
        },
      ),
    );
  }

  getimages() async {
    try {
      imageStream = await MultiImagePicker.pickImages(
          maxImages: 5 - images.length, enableCamera: true);
    } on NoImagesSelectedException catch (e) {
      // print(e);
    } on Exception catch (e) {
      // print(e);
    }
    // return imageStream;
  }

  void uploadImg(date) async {
    progress();
    progressDialog.show();
    images = [];
    for (var data in date) {
      Asset primero = data;
      File primerFile = await convert.writeToFile(await primero.getByteData());
      print('--->$primerFile');
      imageUrl = await cloudinary.uploadImage(primerFile);
      print('===>$imageUrl');
      images.add(imageUrl);
    }
    await Session().renovate();
    final id = await token.getNumber('idProject');
    createProjectController
        .saveImage(context, {'idProject': id, 'urlPhoto': images}).then((res) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        progressDialog.hide().whenComplete(() {
          seeProjectController.getProjectDatails(context, id, true);
        });
      });
    });
  }
}

class imageZoom extends StatelessWidget {
  final Asset id;
  imageZoom(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(child: AssetThumb(asset: id, width: 600, height: 600)),
    );
  }
}

class listZoom extends StatelessWidget {
  final String id;
  listZoom(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
          child: Image.network(
        id,
        width: 600,
        height: 600,
      )),
    );
  }
}

class _imageTile extends StatelessWidget {
  final Asset imgAsset;
  _imageTile(this.imgAsset);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          AssetThumb(asset: imgAsset, width: 360, height: 360),
        ],
      ),
    );
  }
}
