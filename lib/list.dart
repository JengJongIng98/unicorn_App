import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DogListWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DogListWidgetState();
  }
}

class DogListWidgetState extends State<DogListWidget>{
  bool isList =false;

  Future<List<dynamic>> getData() async{
    var response = await Dio().get('http://192.168.1.82:8088/adptmgmt/adpt/list');
    if(response.statusCode == 200){
      // isList=true;
      print('....... response data: ${response.data.toString()}');
      return response.data;
    }
    else
      return [response.statusCode.toString()];
  }

  _dialog(Animal animal){
    List<Widget> imageWidgetList =[];

    for(var imgObj in animal.imgs){
      imageWidgetList.add(Image.network('http://192.168.1.82:8088${imgObj["image_src"]}'));
      print('------애니멀 이미지  ${imgObj["image_src"]}');
    }

    showDialog(context: context,
      barrierDismissible: true, //다른 위치 클릭시 다이얼로그 자동 닫힘
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(animal.name),
          content: SingleChildScrollView( //256
            scrollDirection: Axis.horizontal,
            child: Row( 
              children: imageWidgetList))
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot){
              //데이터를 가져오기
              if(snapshot.hasData) {
                var list= snapshot.data;
                return ListView.separated(
                  itemCount:list?.length ?? 0,
                  itemBuilder: (context, index) {
                    var animal = Animal.fromJson(list?[index]);
                    return ListTile( //288쪽 참조
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: animal.imgs.isEmpty?
                        AssetImage('images/no_dog.png')
                            :NetworkImage('http://192.168.1.82:8088${animal.imgs[0]["image_src"]}'), //192쪽 참조
                      ),
                      title: Text('이름 : ${animal.name}'),
                      subtitle: Text('아이디 : ${animal.id}'),
                      trailing: Icon(Icons.more_vert),
                      onTap: (){_dialog(animal);},
                    );
                  }, separatorBuilder: (context, index) {
                  return Divider(height: 2, color: Colors.green);
                },
                ) ;
              }
              //데이터를 가져오는 중 일경우
              return Center(
                child: CircularProgressIndicator(backgroundColor: Colors.green),
              );
            })
    );
  }
}

class Animal {
  String id;
  String name;
  List imgs;

  Animal(this.id, this.name, this.imgs);
  Animal.fromJson(Map<String, dynamic> json):
        id=json['animal_id'], name = json['animal_name'], imgs=json['animal_images'] ;
}