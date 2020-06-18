import "dart:io";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/snaps_provider.dart";

import "../models/snap.dart";

class SnapDetailScreen extends StatefulWidget {
  static const routeName = "/snap-detail";

  @override
  _SnapDetailScreenState createState() => _SnapDetailScreenState();
}

class _SnapDetailScreenState extends State<SnapDetailScreen> {
  String snapItemId;

  @override
  void didChangeDependencies() {
    final routeArgsMap =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    snapItemId =
        routeArgsMap['id'] as String; // Extract the snap item id as String

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Calling provider method to get the snap entry data matching the input id.
    // Not listening to changes as no changes can be done to the snap entry data
    // from this screen to dynamically re-render the UI with changed state.
    final Snap matchingSnap = Provider.of<SnapsProvider>(context, listen: false)
        .getSnapById(snapItemId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          matchingSnap.name,
        ),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width > 500
                ? (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.top) * 0.775
                : 500,
            width: MediaQuery.of(context).size.width > 500
                ? MediaQuery.of(context).size.width * 0.4
                : double.infinity,
            child: Image.file(
              matchingSnap.snapFile,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
