import "package:flutter/foundation.dart";

import "dart:io";
import "./location.dart";

class Snap{
  final String id;
  final String name;
  final File snapFile;
  final Location taggedPlace;

  Snap({
    @required this.id,
    @required this.name,
    @required this.snapFile,
    @required this.taggedPlace
  });
}