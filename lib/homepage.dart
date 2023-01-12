import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? file;
  ImagePicker image = ImagePicker();
  PermissionStatus? storageStatus;
  PermissionStatus? cameraStatus;
  checkPermission() {

    if (storageStatus == PermissionStatus.granted || cameraStatus == PermissionStatus.granted){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              animation: AlwaysStoppedAnimation(2),
              backgroundColor: Colors.red,
              content: Text("Permission Allowed!", style: TextStyle(fontSize: 20),)));
    }else if (storageStatus == PermissionStatus.denied || cameraStatus == PermissionStatus.denied || cameraStatus == PermissionStatus.limited){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              animation: AlwaysStoppedAnimation(2),
              backgroundColor: Colors.red,
              content: Text("Permission Denied!", style: TextStyle(fontSize: 20),)));
    }
  }

  requestPermissionStorage() async {
    storageStatus = await Permission.storage.request();

    if (storageStatus == PermissionStatus.granted) {
      checkPermission();
    }
    if (storageStatus == PermissionStatus.denied ) {
      checkPermission();
    }

    if (storageStatus == PermissionStatus.permanentlyDenied ) {
      openAppSettings();
    }
  }

  requestPermissionCamera()async {
    cameraStatus = await Permission.camera.request();

    if (storageStatus == PermissionStatus.granted) {
        checkPermission();
    }
    if (storageStatus == PermissionStatus.denied ) {
      checkPermission();
    }

    if (storageStatus == PermissionStatus.permanentlyDenied ) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    requestPermissionStorage();
    requestPermissionCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Upload Image")),
        body: Column(
          children: [
            const Padding(padding: EdgeInsetsDirectional.only(top: 20)),
            Container(
                height: 700,
                width: 400,
                color: Colors.white24,
                child: file == null
                    ? const Icon(
                        Icons.image,
                        size: 70,
                      )
                    : Image.file(file!, fit: BoxFit.contain)),
            const Spacer(),
            Row(
              children: [
                const Padding(padding: EdgeInsetsDirectional.only(start: 120.0)),
                SizedBox(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (storageStatus == PermissionStatus.granted){
                          getImage();
                        }else{
                          requestPermissionStorage();
                        }
                      },
                      child: const Text("Upload Image",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  )),
                ),
                const Padding(padding: EdgeInsetsDirectional.only(start: 40.0)),
                SizedBox(
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                            onPressed: () {
                              if (cameraStatus == PermissionStatus.granted){
                                getCamera();
                              }else{
                                requestPermissionCamera();
                              }
                            },
                            child: const Text("Camera",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)))),
                  ),
                ),
                const Padding(padding: EdgeInsetsDirectional.only(bottom: 200.0))
              ],
            )
          ],
        ));
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  getCamera() async {
    var img = await image.pickImage(source: ImageSource.camera);
    setState(() {
      file = File(img!.path);
    });
  }
}
