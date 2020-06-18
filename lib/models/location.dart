import "package:flutter/foundation.dart";

class Location {
  final String locationName;
  final double latitude;
  final double longitude;

  Location({
    @required this.locationName,
    @required this.latitude,
    @required this.longitude
  });
}
