import 'dart:io';

import 'package:colfunding/utils/Convert.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
class Camera {
  Convert convert;
  Camera(){
   convert = new Convert();
  }
  Future<List<File>> getImages(int maxImages)async{
     List<File> images = [];
     
     List assets = await MultiImagePicker.pickImages(
          maxImages:maxImages, enableCamera: true);
          print('assets');
          print(assets);
     for (var asset in assets){
            
             print('asset');
             print(asset);
             File file = await convert.writeToFile(await asset.getByteData());
             print('file');
             print(file);
             images.add(file);
          }
    return images;
  }
}