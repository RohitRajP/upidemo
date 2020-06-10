import '../imports.dart';

class HomePageModel extends ChangeNotifier {
  // holds if the page content is loading
  bool _isLoading = true;
  // holds list of UPI applications installed
  List<ApplicationMeta> _installedUPIApps = [];
  // holds the list of preset UPI applications
  Map<String, Map<String, dynamic>> _presetUPIs = {
    "Google Pay": {
      "imgAddress": "assets/images/google.png",
      "packageName": "com.google.android.apps.nbu.paisa.user",
      "upiApplication": null,
      "installed": false
    },
    "Paytm": {
      "imgAddress": "assets/images/paytm.png",
      "packageName": "net.one97.paytm",
      "upiApplication": null,
      "installed": false
    },
    "MyAirtel": {
      "imgAddress": "assets/images/airtel.png",
      "packageName": "com.myairtelapp",
      "upiApplication": null,
      "installed": false
    },
    "Amazon Pay": {
      "imgAddress": "assets/images/amazon.png",
      "packageName": "in.amazon.mShop.android.shopping",
      "upiApplication": null,
      "installed": false
    },
    "PhonePe": {
      "imgAddress": "assets/images/PhonePe.png",
      "packageName": "com.phonepe.app",
      "upiApplication": null,
      "installed": false
    },
    "BHIM UPI": {
      "imgAddress": "assets/images/bhim.png",
      "packageName": "in.org.npci.upiapp",
      "upiApplication": null,
      "installed": false
    },
    "Kotak - 811": {
      "imgAddress": "assets/images/kotak.png",
      "packageName": "com.msf.kbank.mobile",
      "upiApplication": null,
      "installed": false
    },
    "Truecaller UPI": {
      "imgAddress": "assets/images/truecaller.png",
      "packageName": "com.truecaller",
      "upiApplication": null,
      "installed": false
    },
  };

  // modifies the isLoading value
  void flipisLoadingValue() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  // gets the current isLoading value
  bool getLoadingValue() {
    return _isLoading;
  }

  // modifies the installed upiAppsList
  void modifyUPIAppsList(List<ApplicationMeta> installedUPIApps) {
    _installedUPIApps = installedUPIApps;
    notifyListeners();
  }

  // gets the installed upiAppsList
  List<ApplicationMeta> getUPIAppList() {
    return _installedUPIApps;
  }

  // gets the preset UPI app list
  Map<String, Map<String, dynamic>> getPresetUPIList() {
    return _presetUPIs;
  }

  // helps modify the UPI app list
  void updatPresetUPIList(Map<String, Map<String, dynamic>> presetUPIs) {
    _presetUPIs = presetUPIs;
    notifyListeners();
  }
}
