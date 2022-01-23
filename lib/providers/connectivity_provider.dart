import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ConnectivityProvider extends ChangeNotifier {
  Connectivity _connectivity = Connectivity();
  bool _isOnline = false;
  bool get isOnline => _isOnline;

  Future<void> initConnectivity() async {
    try {
      var status = await _connectivity.checkConnectivity();

      if (status == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        _isOnline = true;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("Connectivity provider error: ${e.toString()}");
    }
  }
}
