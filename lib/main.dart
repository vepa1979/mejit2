import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'help.dart';
import 'market.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MaterialApp(
      home: new MyApp()
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();











  @override
  void initState() {
    super.initState();


    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

  }


  bool _canGoBack = false;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {

    if(index==0)
    Navigator.of(context).pop();
    if(index==2)
       Navigator.push(
        context, MaterialPageRoute(builder: (context) => Helppage()));
    if(index==3)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Marketpage()));


    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("Amazon TM")),
      // drawer: Drawer(
      //   child:
      //     Text("deneme")
      //
      // ),
        body:

    WillPopScope(

    onWillPop: () async {
    if (_canGoBack) {
      webViewController?.goBack();
    return false;
    }
    return true;
    },
    child:
        SafeArea(

            child: Column(

                children: <Widget>[

              Expanded(

                child: Stack(
                  children: [
                    InAppWebView(

                      key: webViewKey,
                      initialUrlRequest:
                      URLRequest(url: Uri.parse("https://sanlysahypa.com/simple/example/example_basic_selector.php#googtrans(ru)")),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;


                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          var snackBar = SnackBar(content: Text('Amazon bazaryna hoş geldiňiz...'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![ "http", "https", "file", "chrome",
                          "data", "javascript", "about"].contains(uri.scheme)) {
                          if (await canLaunch(url)) {
                            // Launch the App
                            await launch(
                              url,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                          _canGoBack = true;
                        });




                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                       // print(consoleMessage);
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),

            ])),

    ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        iconSize: 24,
        showSelectedLabels: false, //selected item
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),

      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
          SizedBox(
            height: 100,
            child:
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,

              ),
              child: Text(
                'Amazon TM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),

            Padding(
              padding: EdgeInsets.all(16),
              child:
              Text("Amazon TM www.amazon.ae websaýtyndan söwda etmäge kömek edýar.Tehniki näsazlyk ýüze çyksa şu belgä jaň ediň : +99365939482",style: TextStyle(fontSize: 18,height: 1.5),),

            ),
            ListTile(
              leading: Icon(Icons.help_center),
              title: Text('Gollanma'),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child:
              Text("www.amazon.ae websaýtyndan haryt saýlanandan soň sahypanyň aşak kysmyndan satyn al düwmesine basyň! Mobil belgiňizi ýazyp dowam et düwmesine basmaly.",style: TextStyle(fontSize: 16,height: 1.2),),

            ),
          ],
        ),
      ),
    );
  }
}