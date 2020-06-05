import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PhotoViewPage extends StatefulWidget {
  @required final List images;
  @required final String tittle;
  PhotoViewPage({this.images, this.tittle});
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState(images: this.images, tittle: this.tittle);
}
class _PhotoViewPageState extends State<PhotoViewPage> {
  List images;
  String tittle;

  _PhotoViewPageState({this.images, this.tittle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          tittle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: PhotoViewGallery.builder(
        itemCount: images.length, 
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 70.0,
            height: 70.0,
            child: SpinKitPouringHourglass(
              color: Colors.green,
            ),
          ),
        ),
        builder: (context, index){
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              images[index],
            ),
            minScale: PhotoViewComputedScale.contained *0.8,
            maxScale: PhotoViewComputedScale.covered  *2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        loadFailedChild: Center(
          child: CircularProgressIndicator(),
        )
      )
    ); 
  }
}