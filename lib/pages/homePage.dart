import '../imports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  // helps shuffle the UPI list to identify the order to show and which apps are installed
  Future<void> shuffleUPIList() async {
    var homePageModel = Provider.of<HomePageModel>(context, listen: false);
    // gets the list of preset apps
    Map<String, Map<String, dynamic>> _presetUPIs =
        homePageModel.getPresetUPIList();
    Map<String, Map<String, dynamic>> _reorderedPresetUPIs = new Map();
    List<ApplicationMeta> _installedUPIApps = homePageModel.getUPIAppList();
    if (_installedUPIApps.length > 0) {
      for (int i = 0; i < _presetUPIs.length; i++) {
        // print(i.toString());
        for (int j = 0; j < _installedUPIApps.length; j++) {
          // print(_presetUPIs[_presetUPIs.keys.elementAt(i)]["packageName"]);
          // print(_installedUPIApps[j].packageName);
          if (_presetUPIs[_presetUPIs.keys.elementAt(i)]["packageName"] ==
              _installedUPIApps[j].packageName) {
            // print(_installedUPIApps[j].packageName);
            // print(_presetUPIs[_presetUPIs.keys.elementAt(i)]["packageName"]);
            _presetUPIs[_presetUPIs.keys.elementAt(i)]["installed"] = true;
            _presetUPIs[_presetUPIs.keys.elementAt(i)]["upiApplication"] =
                _installedUPIApps[j].upiApplication;
            // _reorderedPresetUPIs.addAll({
            //   _presetUPIs.keys.elementAt(i):
            //       _presetUPIs[_presetUPIs.keys.elementAt(i)]
            // });
          }
        }
      }
    }
    homePageModel.updatPresetUPIList(_presetUPIs);
  }

  // gets list of UPI applications installed and loads UPI options
  void loadUPIOptions() async {
    var homePageModel = Provider.of<HomePageModel>(context, listen: false);
    List<ApplicationMeta> upiApps = await UpiPay.getInstalledUpiApplications();
    homePageModel.modifyUPIAppsList(upiApps);
    await shuffleUPIList();
    homePageModel.flipisLoadingValue();
  }

  // handles the tapping of UPI icon
  void processTapOnUPIIcon(int index) async {
    var homePageModel = Provider.of<HomePageModel>(context, listen: false);
    Map<String, Map<String, dynamic>> presetUPIList =
        homePageModel.getPresetUPIList();
    UpiApplication upiApplication =
        presetUPIList[presetUPIList.keys.elementAt(index)]["upiApplication"];
    UpiTransactionResponse txnResponse = await UpiPay.initiateTransaction(
        app: upiApplication,
        receiverUpiAddress: "rrjp@ybl",
        receiverName: "Rohit",
        transactionNote: "Payment for ORD1215236",
        transactionRef: "ORD1215236",
        amount: "2.00");

    String message = "";
    Color sbrColor;

    if (txnResponse.status == UpiTransactionStatus.success) {
      message = "Transaction Completed!";
      sbrColor = Colors.green;
    } else if (txnResponse.status == UpiTransactionStatus.failure) {
      message = "Transaction incomplete";
      sbrColor = Colors.red;
    } else if (txnResponse.status == UpiTransactionStatus.submitted) {
      message = "Transaction Submitted!";
      sbrColor = Colors.orange;
    }

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: sbrColor,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void initState() {
    super.initState();
    // getting list of UPI applications installed and loading UPI options
    loadUPIOptions();
  }

  @override
  Widget build(BuildContext context) {
    print("==================BUILD FROM SCRATCH================");
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Instant UPI Payment"),
      ),
      body: SafeArea(
        child: homePageBody(),
      ),
    );
  }

  Widget homePageBody() {
    return Container(
      child: Center(child: Consumer<HomePageModel>(
        builder: (context, data, child) {
          return (data.getLoadingValue())
              ? loadingIndicator()
              : upiAppsLoadedView();
        },
      )),
    );
  }

  // holds the loading indicator
  Widget loadingIndicator() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }

  // holds the view after the UPI apps installed have been loaded
  Widget upiAppsLoadedView() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          demoMessage(),
          SizedBox(
            height: 20.0,
          ),
          upiAppsGridView(),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  // holds the message for the demo
  Widget demoMessage() {
    return Container(
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(children: [
          TextSpan(
            text: "Merchant UPI ID rrjp@ylb\n\n",
            style: TextStyle(
                color: Colors.green,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "Payment Methods:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          )
        ]),
      ),
    );
  }

  // holds the gridview of all installed UPI applications
  Widget upiAppsGridView() {
    return Consumer<HomePageModel>(
      builder: (context, data, child) {
        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.getPresetUPIList().length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, Map<String, dynamic>> _presetUPIs =
                  data.getPresetUPIList();
              List<ApplicationMeta> _installedUPIApps = data.getUPIAppList();

              return Card(
                child: InkWell(
                  child: ListTile(
                    leading: Container(
                      height: 50.0,
                      width: 50.0,
                      child: Image.asset(
                        _presetUPIs[_presetUPIs.keys.elementAt(index)]
                            ["imgAddress"],
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(_presetUPIs.keys.elementAt(index)),
                    subtitle: (_presetUPIs[_presetUPIs.keys.elementAt(index)]
                            ["installed"])
                        ? Text(
                            "Installed",
                            style: TextStyle(color: Colors.green),
                          )
                        : Text("Not Installed"),
                  ),
                  onTap: () {
                    if (_presetUPIs[_presetUPIs.keys.elementAt(index)]
                        ["installed"]) {
                      processTapOnUPIIcon(index);
                    } else {
                      try {
                        launch("market://details?id=" +
                            _presetUPIs[_presetUPIs.keys.elementAt(index)]
                                ["packageName"]);
                      } on PlatformException catch (e) {
                        launch(
                            "https://play.google.com/store/apps/details?id=" +
                                _presetUPIs[_presetUPIs.keys.elementAt(index)]
                                    ["packageName"]);
                      }
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
