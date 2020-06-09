import '../imports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
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

    String message = "";
    Color sbrColor;

    if (txnResponse.status == UpiTransactionStatus.success) {
      message = "Transaction Completed!";
      sbrColor = Colors.green;
    } else if (txnResponse.status == UpiTransactionStatus.failure) {
      message = "Transaction Failed!";
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
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          demoMessage(),
          SizedBox(
            height: 40.0,
          ),
          upiAppsGridView(),
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
            text: "You will be sending ₹2 to UPI ID rrjp@ylb\n\n",
            style: TextStyle(
                color: Colors.green,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                "Choose any from all the UPI enabled applications installed in your device",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
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
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: (data.getUPIAppList().length != 0)
              ? Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: data.getUPIAppList().length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 30.0,
                    ),
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
                )
              : Text(
                  "No UPI based applications found on your device",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
        );
      },
    );
  }
}
