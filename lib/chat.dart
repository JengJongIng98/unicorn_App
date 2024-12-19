//firebase연결 . yaml파일에  firebase core, firebase store 등록
//안드로이드 파일들 설정 build.gradle (minsdk, multiDexEnabled)
//firebase store 확인 및 컬렉션 설정
//관리자와 채팅

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'main.dart';

class ManagerChat extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ManagerChatState();
  }
}

class ManagerChatState extends State<ManagerChat>{
  var textController = TextEditingController();
  late String? user ;
  final SignController gController = Get.find();


  void sendPress() async{

     if(gController.isInput.value) {
       showToast('로그인 하세요');
        return;
     }

    String msg = textController.text;
    print('----------------msg:$msg');

     Map<String, dynamic> map = {
      "writer":user,
      "content":msg,
      "time":Timestamp.now()
    };

    await FirebaseFirestore.instance.collection(user!).add(map);
    textController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(gController.isInput.value) {
      showToast('로그인 하세요');
      return;
    }

    //user = FirebaseAuth.instance.currentUser!.email;
    user = gController.user.value;

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SignController>(builder:(gController)=>
      Column(
      children: [
        Expanded(child:gController.isInput.value?
            Container(
                padding: EdgeInsets.only(top: 100),
                child:Text('로그인 하세요.' ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)))
        //채팅창
            :StreamBuilder(
            stream: FirebaseFirestore.instance.collection(user!).orderBy(
                'time', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final docs = snapshot.data?.docs;
              return ListView.builder(
                  itemCount: docs?.length ?? 0,
                  reverse: true,
                  itemBuilder: (context, index) {
                    bool isMe = docs?[index].get('writer') == user;
                    return Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                                color: isMe ? Colors.lightGreen : Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(14)
                                )
                            ),
                            child: Text(docs?[index].get('content'),
                                style: TextStyle(fontSize: 16.0)),
                          )
                        ]
                    );
                  }
              );
            })
        ),
        Padding(padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(child: TextField(controller : textController)),
              IconButton(onPressed: (){sendPress();}, icon: Icon(Icons.send))
            ],
          ),
        )
      ],
    ));
  }
}
