import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main.dart';

//서버의 로그인과 로그아웃에 채널을 연결한다.


class MyWebHomePage extends StatelessWidget{
  final SignController gController = Get.find();
  String webUrl = 'http://192.168.1.82:8088/login/customLogin';


  @override
  Widget build(BuildContext context) {
    print('-------webview build');
    if(gController.isInput.value){
      webUrl = 'http://192.168.1.82:8088/login/customLogin';
    }else webUrl = 'http://192.168.1.82:8088/adpt';

    var wController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            webUrl = url;
            print('-------마지막 페이지 url   $url');
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('flutterChannel',
          onMessageReceived: (msg){
        //서버 코드는 flutterChannel.postMessage('{"id":"'+id.value+'","is_login":'+isLogin+'}'); 필요하다.
              print('------자바스크립트에서 온 메시지 : ${msg.message} type${msg.message.runtimeType}');
              Map<String, dynamic> map = jsonDecode(msg.message);
              if(map["is_login"]) {
                print(' ----------map ["id"] : ${map["id"]}');
                gController.isInput.value= false;
                gController.user.value=map["id"];
              } else {
                print(' ----------map ["is_login"] : ${map["is_login"]}');
                gController.isInput.value=true;
              }
          })
      ..loadRequest(Uri.parse(webUrl));
      //..loadRequest(Uri.parse('http://192.168.1.200:8088/flutter_webview/webviewtest3.jsp'));
    return WebViewWidget(controller: wController);
  }
}