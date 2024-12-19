import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project6test1/web_home.dart';
import 'chat.dart';
import 'firebase_options.dart';
import 'list.dart';

showToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor:Colors.white,
      fontSize: 16.0
  );
}

class SignController extends GetxController{
  var user= 'guest'.obs ;
  var isInput = true.obs ; //입력창이 보이는 상태이면 로그인 된 상황이 아니다.
//isInput상태가  false 이면  로그인 된 상태이다.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //로그인된 상태를 전체 유지하기 위해 GetX를 사용하는 것이 가장 편했음
    //지금 코드 상태로는 provider보다 는 GetX가 코딩하기 편함
    Get.put(SignController());
    return MaterialApp(
      debugShowCheckedModeBanner: false, //312
      theme: ThemeData(
        // primarySwatch: Colors.orange,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white
          )
      ),
      home: OneScreen(),
    );
  }
}
class OneScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return OneScreenState();
  }
}

class OneScreenState extends State<OneScreen> with SingleTickerProviderStateMixin{


  void _onItemTapped(int index){
    setState(() {
      tController.index=index;
    });
  }

  late TabController tController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tController =  TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        bottomNavigationBar: BottomNavigationBar(  //327쪽 참조
          type: BottomNavigationBarType.fixed, //shifting,  //
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '로그인',
            ) ,
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: '목록',
            ) ,
            BottomNavigationBarItem(
              icon: Icon(Icons.interests),
              label: '채팅',
            )
          ],
          //currentIndex: _selectedIndex,
          currentIndex: tController.index,
          selectedItemColor: Colors.green,
          backgroundColor: Colors.grey[200],
          onTap: _onItemTapped,
        ),
        appBar: (tController.index==0)?
        PreferredSize(preferredSize: Size.fromHeight(3), child: Center())
            :AppBar(title: Text("CRIZAL"),
        ),
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),//스와이프 방지
            controller:tController,
            children: [
              MyWebHomePage(),
              DogListWidget(),
              ManagerChat()
            ]),
      );
  }
}