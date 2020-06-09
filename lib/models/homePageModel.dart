import '../imports.dart';

class HomePageModel extends ChangeNotifier {
  // holds if the page content is loading
  bool _isLoading = true;
  // holds list of UPI applications installed
  List<ApplicationMeta> _upiApps = [];

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
  void modifyUPIAppsList(List<ApplicationMeta> upiApps) {
    _upiApps = upiApps;
  }

  // gets the installed upiAppsList
  List<ApplicationMeta> getUPIAppList() {
    return _upiApps;
  }
}
