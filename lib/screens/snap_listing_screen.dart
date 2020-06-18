import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/snaps_provider.dart";

import "./create_snap_screen.dart";
import "./snap_detail_screen.dart";

class SnapListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Snapee',
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CreateSnapScreen.routeName,
                );
              },
            ),
          ]),
      body: Consumer<SnapsProvider>(
          child: Center(
            child: Text(
              'No snaps in store to display !',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          builder:
              (builderContext, snapsProvider, childAsEmptySnapStoreWidget) {
            final snapsList = snapsProvider
                .snaps; // Call to getter in SnapsProvider to fetch list of snaps

            return (snapsList.isEmpty)
                ? childAsEmptySnapStoreWidget // This is the widget set as value for the
                // named "child" attribute, which is in turn
                // passed on to the "builder" method as value
                // to the argument: childAsEmptySnapsStoreWidget.
                : Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 10,
                    ),
                    //padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: snapsList.length,
                      itemBuilder: (listBuildContext, snapItemIdx) {
                        return Container(
                          alignment: Alignment.center,
                          height: 75,
                          //padding: EdgeInsets.all(5),
                          child: Card(
                            margin: EdgeInsets.all(3),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  snapsList[snapItemIdx].snapFile,
                                ),
                              ),
                              title: Text(
                                snapsList[snapItemIdx].name,
                              ),
                              subtitle: Text(
                                snapsList[snapItemIdx].taggedPlace.locationName,
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SnapDetailScreen.routeName,
                                    arguments: {
                                      'id': snapsList[snapItemIdx].id,
                                    });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
          }),
    );
  }
}
