import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/*
 
  Description : Webview 
  Date        : 2024.04.20 Sat
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.20 Sat by pdg
		  - 별로 쓸때가 없지만 일단 플러터 복습하는김에 만들어 보았다.
      - 농넷의 도매가 현황 사이트를 보여줌. 
      - 뒤로가기 앞으로 가기 버튼 필요함? -> 일단 만듬. 
  Detail      : - 

*/
class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController webViewController;
  late bool isLoading;
  late String siteName;
  late TextEditingController tfController;

  @override
  void initState() {
    super.initState();
    siteName = "www.nongnet.or.kr/";
    isLoading = true;
    tfController = TextEditingController(text: siteName);
    webViewController = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            isLoading = true;
            setState(() {});
          },
          onProgress: (progress) {
            isLoading = true;
            setState(() {});
          },
          onPageFinished: (url) {
            isLoading = false;
            setState(() {});
          },
          onWebResourceError: (error) {
            isLoading = false;
            setState(() {});
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://$siteName'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Farmers Web",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 219, 109),
      ),
      body: Stack(children: [
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const Stack(),
        WebViewWidget(
          controller: webViewController,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => backProcess(),
        backgroundColor: Colors.amber,
        child: Icon(Icons.arrow_back),
      ),
    );
  }
  // Function
  backProcess() async{
    if (await webViewController.canGoBack()){
      webViewController.goBack();
    }else{
      snackbarFunction();
    }
  }
      reloadProcess() async {
    //Cpu 따로 쓰니까 어싱크, 다운로드 중에도 back 할수있으니까!
    await webViewController.reload();
  }
  forwardProcess() async {
    //Cpu 따로 쓰니까 어싱크, 다운로드 중에도 back 할수있으니까!
    if (await webViewController.canGoForward()) {
      // 뒤에 갈거있는지 물어본다.
      webViewController.goForward();
    } else {
      snackbarFunction();
    }
  }
  snackbarFunction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        content: Text("뒤로 갈수 없습니다. "),
        duration: Duration(seconds: 2),
      ),
    );
  }
    reloadSite() {
    //siteName ="www.google.com";
    webViewController.loadRequest(Uri.parse("https://$siteName"));
  }
}//End
