import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
class CameraScreen  extends StatefulWidget {
  final List<CameraDescription> camera;

  const CameraScreen ({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _CameraScreen createState() => _CameraScreen();
}

class _CameraScreen  extends State<CameraScreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  @override
  void initState() {
    super.initState();
    // 1
    availableCameras().then((availableCameras) {

      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      }else{
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255,41,43,66),
      appBar: AppBar(
        title: Text('Camera'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios
          ),
        ),
      ),
//      body: _cameraPreviewWidget(),
      body: WillPopScope(
        child:Column(
        children: <Widget>[
          _cameraPreviewWidget(),
          _cameraTogglesRowWidget(),
        ],
      ),
        onWillPop: ()async{
          controller.dispose();
          return true;
        },
      )
    );
  }
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }
    setState(() {});
//    if (mounted) {
//      setState(() {});
//    }
  }
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }
  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child:Row(

            mainAxisAlignment:MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                FlatButton.icon(
                    onPressed: _onSwitchCamera,
                    icon: Icon(
                        _getCameraLensIcon(lensDirection),
                      color: Colors.white,
                    ),
                    label: Text(
                        "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                ),
                Expanded(
                  child:Padding(
                    child: IconButton(
                      iconSize: 60,
                      onPressed: _onCapturePressed,
                      icon: Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                    ) ,
                    padding: EdgeInsets.only(right: 90),
                  )
                )


          ],
        )
      ),
    );
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive ) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        _initCameraController(controller.description);

      }
    }
  }
  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }
  void _onSwitchCamera() {
    selectedCameraIdx =
    selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }
  void _onCapturePressed() async {
    try {
      // 1
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      // 2
      await controller.takePicture(path);
      // 3
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: path),
        ),
      );
      if(result != null){
        Navigator.pop(context,result);
      }
    } catch (e) {
      print(123);
      print(e);
    }
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comfirm picture'),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:Icon(
                Icons.arrow_back_ios,
            )
        ),
      ),
      backgroundColor: Color.fromARGB(255,41,43,66),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Image.file(
              File(
                  imagePath
              )
          ),
          Expanded(
              child:Row(
                mainAxisAlignment:MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child:Padding(
                        child: IconButton(
                          iconSize: 60,
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                        ) ,
                        padding: EdgeInsets.only(left: 85),
                      )
                  ),
                  IconButton(
                    iconSize: 60,
                    onPressed: (){
                      Navigator.pop(context, imagePath);
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ) ,
                ],
              )
          )
        ],
      )
    );
  }
}