import '../imports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // gets list of UPI applications installed and loads UPI options
  void loadUPIOptions() async {
    var homePageModel = Provider.of<HomePageModel>(context, listen: false);
    List<ApplicationMeta> upiApps = await UpiPay.getInstalledUpiApplications();
    homePageModel.modifyUPIAppsList(upiApps);
    homePageModel.flipisLoadingValue();
  }

  // handles the tapping of UPI icon
  void processTapOnUPIIcon(ApplicationMeta tappedUPIApp) async {
    UpiTransactionResponse txnResponse = await UpiPay.initiateTransaction(
        app: tappedUPIApp.upiApplication,
        receiverUpiAddress: "rrjp@ybl",
        receiverName: "Rohit",
        transactionNote: "Payment for ORD1215236",
        transactionRef: "ORD1215236",
        amount: "2.00");
  }

  @override
  void initState() {
    super.initState();
    // getting list of UPI applications installed and loading UPI options
    loadUPIOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UPI Demonstration"),
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
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          upiAppsGridView(),
        ],
      ),
    );
  }

  // holds the gridview of all installed UPI applications
  Widget upiAppsGridView() {
    return Consumer<HomePageModel>(
      builder: (context, data, child) {
        return Container(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: data.getUPIAppList().length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 50.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: InkWell(
                  child: Image.memory(data.getUPIAppList()[index].icon,
                      width: 20, height: 20),
                  onTap: () {
                    processTapOnUPIIcon(data.getUPIAppList()[index]);
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
