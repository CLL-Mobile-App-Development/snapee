import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import 'package:places_app/models/location.dart';
import "package:provider/provider.dart";
import "package:path/path.dart"
    as path; // For forging paths in device filesystem
import "package:path_provider/path_provider.dart"
    as syspath; // To know the accessible resource paths on device

import "../providers/snaps_provider.dart";

import "../models/snap.dart";

class CreateSnapScreen extends StatefulWidget {
  static const routeName = "/create-snap";

  @override
  State<CreateSnapScreen> createState() => _CreateSnapScreenState();
}

class _CreateSnapScreenState extends State<CreateSnapScreen> {
  final _titleController = TextEditingController();
  final _locationTagController = TextEditingController();

  bool isImageBeingCaptured = false; // To track if the user is currently taking
  // a snap/image with camera. Accordingly, the
  // preview Container widget will have a circular
  // loader or the taken image once done.

  File _capturedSnap;
  final imagePicker = ImagePicker();

  void _addSnap() {
    final String snapTitle = _titleController.text;
    final String locationTag = _locationTagController.text;

    if (snapTitle.isEmpty || _capturedSnap == null || locationTag.isEmpty) {
      return; // Exit this method if required information
      // is not yet available from the user.
    }

    final newSnap = Snap(
      id: DateTime.now().toIso8601String(),
      name: snapTitle,
      snapFile: _capturedSnap,
      taggedPlace: Location(
        locationName: locationTag,
        latitude: 0.0,
        longitude: 0.0,
      ),
    );

    // Calling the provider method to add new entry to its local list of snaps.
    Provider.of<SnapsProvider>(context, listen: false).addSnap(newSnap);
    Navigator.of(context)
        .pop(); // Pops this screen off the view-port to reveal the
    // previous screen underneath the current Navigator
    // stack top.
  }

  Future<void> captureSnapFromCamera() async {
    // Set the flag tracking the user camera use
    // and accordingly re-render UI with appropriate
    // widget based on this flag state (in preview
    // Container widget).
    setState(() => isImageBeingCaptured = true);

    // await on getImage as the image/snap will be available
    // only when user finishes taking a snap with the camera.
    final _cameraSnap = await imagePicker.getImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );

    final documentDirectory = await syspath
        .getApplicationDocumentsDirectory(); // Get the document directory resource
    // on the device, for the app to store
    // user-generated data/resource.

    // Re-build the screen to show the preview of the captured
    // image from the camera, now available through the private
    // variable _capturedSnap.
    setState(() {
      isImageBeingCaptured = false; // Reset to allow the image to be displayed
      // in the preview Container widget. Or else,
      // the circular loader will be displayed instead
      // of the captured image.
      _capturedSnap = File(_cameraSnap.path);
    });

    // Get the captured image file name using "path".
    final capturedSnapName = path.basename(_capturedSnap.path);

    final capturedSnapCopyPath = documentDirectory.path +
        "/" +
        capturedSnapName; // Essentially forging the copy path, from
    // the fetched document directory path and
    // the name of the captured image file,
    // through snap taken from the camera.

    _capturedSnap.copy(
        capturedSnapCopyPath); // Copy captured snap from the current device location to
    // persistent document directory on the device.
    print("captured snap path: ${_capturedSnap.path}");
    print("document directory path: ${documentDirectory.path}");
    print("persistent copy path: $capturedSnapCopyPath");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationTagController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Snap',
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline1.color,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: (_capturedSnap == null)
                              ? Alignment.center
                              : null, // To allow the image to cover the
                          // container widget space, with
                          // BoxFit.cover
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          height: MediaQuery.of(context).size.width > 500
                              ? 200
                              : 150,
                          width: MediaQuery.of(context).size.width > 500
                              ? 275
                              : 200,
                          child:
                              (isImageBeingCaptured) // Initially false, so, gets to _capturedSnap == null
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )
                                  : (_capturedSnap == null)
                                      ? Text(
                                          'No capture to preview !',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        )
                                      : Image.file(
                                          _capturedSnap,
                                          fit: BoxFit.cover,
                                        ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Expanded(
                          child: FlatButton.icon(
                            icon: Icon(
                              Icons.camera,
                              color: Theme.of(context).accentColor,
                            ),
                            label: Text(
                              'Capture',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            onPressed: () async =>
                                await captureSnapFromCamera(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Location Tag',
                      ),
                      controller: _locationTagController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            //width: double.infinity,
            child: RaisedButton.icon(
              color: Colors.blueGrey[400],
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: _addSnap,
              icon: Icon(
                Icons.add,
                size: 25,
                color: Colors.white,
              ),
              label: Text('Add Snap',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
