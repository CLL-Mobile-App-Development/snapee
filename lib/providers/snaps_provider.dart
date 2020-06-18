import 'package:flutter/foundation.dart';

import '../models/snap.dart';

class SnapsProvider with ChangeNotifier {
  List<Snap> _snaps = [];

  // Getter for snaps list data
  List<Snap> get snaps {
    return [..._snaps]; // Spread operator used to destruct the private
    // list data and create a new list as copy, returned
    // to the caller.
  }

  // Method to fetch matching snap list item with given id
  Snap getSnapById(String snapId) {
    return _snaps.firstWhere((snapItem) => snapItem.id == snapId);
  }

  // Adds passed in new snap entry to the back of the list of entries .
  void addSnap(Snap newSnap) {
    _snaps.add(newSnap);
    print(_snaps);
    notifyListeners(); // Notify registered listeners in the widget
    // tree of the change in the data.
  }
}
