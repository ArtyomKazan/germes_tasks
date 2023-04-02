import 'package:flutter/material.dart';
import 'package:germes_tasks/config/Settings.dart';
import 'package:germes_tasks/rest/Rest.dart';
import 'package:germes_tasks/screens/MainScreen.dart';
import 'package:germes_tasks/screens/RedoItem.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';


class TaskItem extends StatefulWidget {

  var item = "";
  var shipList = {};
  var tl = Rest(url,token);

  TaskItem({super.key, required this.item, required this.shipList});

  @override
  State createState() { // Avoid using private types in public APIs.
    return _TaskItem();
  }

}

class _TaskItem extends State<TaskItem> {

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(ship: 0, title: "Все задачи", shipList: widget.shipList),
            ),
          );
          return false;
        },
        child: Scaffold(

          appBar: AppBar(
              title: const Text('Просмотр задачи'),
              actions: <Widget>[
                        IconButton(
                          onPressed: (){
                              List<String> shipsListList = [];
                              var i = 0;
                              for(var v in widget.shipList.values) {
                                shipsListList.insert(i,v);
                                i++;
                              }
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RedoItem(shipList: shipsListList, id: widget.item),
                                ),
                              );
                            },
                          icon: const Icon(Icons.edit)
                        )
                  ]
          ),

          body: FutureBuilder(
              future: widget.tl.GetTasksInfo("getTaskInfo", widget.item),
              builder:(context, snapshot){
                if(snapshot.hasError){
                  return const Text("error");
                }
                else if(snapshot.hasData){
                  var result = [];
                  String complet = "";
                  result = snapshot.data!;
                  //print(result);
                  if(result[0]['complete']=="1"){
                    complet = "Задача завершена";
                  }
                  else{
                    complet = "Задача не завершена";
                  }
                  var timestamp = int.parse(result[0]['created']);
                  var myDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                  var format = DateFormat("d.M.y");
                  var dat = format.format(myDate);
                  timestamp = int.parse(result[0]['dat']);
                  myDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                  format = DateFormat("d.M.y");
                  var srok = format.format(myDate);

                  var ship = widget.shipList[result[0]['ship_id']];

                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(result[0]['name'], style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(complet, style: const TextStyle(fontSize: 18.0))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text("Поставлена: $dat", style: const TextStyle(fontSize: 18.0))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text("Срок: $srok", style: const TextStyle(fontSize: 18.0))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text("Теплоход: $ship", style: const TextStyle(fontSize: 18.0))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text("Автор: ${result[0]['author_str']}", style: const TextStyle(fontSize: 18.0))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text("Ответственный: ${result[0]['executor']}", style: const TextStyle(fontSize: 18.0))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text("Помощник:  ${result[0]['helpers']}", style: const TextStyle(fontSize: 18.0))
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(result[0]['text'], style: const TextStyle(fontSize: 20.0))
                      ),
                      // галерея
                      FutureBuilder(
                          future: widget.tl.GetTaskPictures("getTaskPictures", widget.item),
                          builder:(context, snapshot){
                            if(snapshot.hasError){
                              return const Text("error1");
                            }
                            else if(snapshot.hasData){
                              dynamic result2;
                              result2 = snapshot.data!;
                              //print(result2);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  itemCount: result2.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: result2[index]);
                                  }
                              );
                            }
                            else{
                              return const Text("Загружаем картинки, если есть...");
                            }
                          }
                      ),
                      // переписка
                      FutureBuilder(
                          future: widget.tl.GetTaskPictures("getTaskPosts", widget.item),
                          builder:(context, snapshot){
                            if(snapshot.hasError){
                              return const Text("error1");
                            }
                            else if(snapshot.hasData){
                              dynamic result3;
                              result3 = snapshot.data!;
                              return ListView.builder(
                                //scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  itemCount: result3.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var timestamp = int.parse(result3[index]['date']);
                                    var myDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                                    var format = DateFormat("d.M.y H:m");
                                    var dat = format.format(myDate);
                                    return ListTile(
                                        title: Text(result3[index]["text"]),
                                        subtitle: Text(" -- $result3[index]['author_str'] в $dat")
                                    );
                                  }
                              );
                            }
                            else{
                              return const Text("Загружаем переписку, если есть...");
                            }
                          }
                      )
                    ],
                  );
                }
                else
                {
                  return const Center(child: CircularProgressIndicator());
                }
              }
          ),

        )
    );

  }


}