import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/snap_listing_screen.dart';
import './screens/snap_detail_screen.dart';
import './screens/create_snap_screen.dart';

import './providers/snaps_provider.dart';

void main() {
  runApp(Snapee());
}

class Snapee extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: SnapsProvider(),
      child: MaterialApp(
        title: 'ImgLogs',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.lightGreen,
          accentColor: Colors.purple,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SnapListingScreen(),
        routes: {
          SnapDetailScreen.routeName: (buildCxt) => SnapDetailScreen(),
          CreateSnapScreen.routeName: (buildCxt) => CreateSnapScreen()
        },
      ),
    );
  }
}
