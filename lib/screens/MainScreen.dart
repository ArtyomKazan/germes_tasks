import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:germes_tasks/config/Settings.dart';
import 'package:germes_tasks/rest/Rest.dart';
import 'package:germes_tasks/screens/AddItem.dart';
import 'package:germes_tasks/screens/TaskItem.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {

  var ship = 0;
  String title = "Все задачи";
  var shipList = {};
  var tl = Rest(url,token);
  dynamic newresult = [];
  dynamic result;

  MainScreen({super.key, required this.ship,  required this.title, required this.shipList});

  @override
  State createState() { // Avoid using private types in public APIs.
    return _MainScreen();
  }

}

class _MainScreen extends State<MainScreen> {

  DateTime preBackpress = DateTime.now();

  @override
  Widget build(BuildContext context) {

    AlertDialog _buildExitDialog(BuildContext context) {
      return AlertDialog(
        title: const Text('Подтвердите действие'),
        content: const Text('Вы хотите выйти из приложения?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Нет'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text('Да'),
          ),
        ],
      );
    }

    Future<bool> _onWillPop(BuildContext context) async {
      bool? exitResult = await showDialog(
        context: context,
        builder: (context) => _buildExitDialog(context),
      );
      return exitResult ?? false;
    }


    Future<bool?> _showExitDialog(BuildContext context) async {
      return await showDialog(
        context: context,
        builder: (context) => _buildExitDialog(context),
      );
    }


    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
            body: FutureBuilder(
                    future: widget.tl.GetTasksList("getGlobalTaskList"),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("error main screen");
                      }
                      else if (snapshot.hasData) {

                        widget.result = snapshot.data!;
                        for(final e in widget.result){
                          if(e['ship_id'] == widget.ship.toString()){
                            widget.newresult.add(e);
                          }
                          if(widget.ship.toString() == "0"){
                            widget.newresult.add(e);
                          }
                        }

                        return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: widget.newresult.length,
                            itemBuilder: (BuildContext context, int index) {
                              var timestamp = int.parse(widget.newresult[index]['dat']);
                              var timestampNow = DateTime.now().millisecondsSinceEpoch / 1000;
                              var cardColor = Colors.black12;
                              if (timestamp < (timestampNow + 432000) &&
                                  int.parse(widget.newresult[index]['complete']) != 1) {
                                cardColor = Colors.red;
                              }
                              if (int.parse(widget.newresult[index]['complete']) == 1) {
                                cardColor = Colors.green;
                              }
                              var myDate = DateTime.fromMillisecondsSinceEpoch(
                                  timestamp * 1000);
                              var format = DateFormat("d.M.y");
                              var dateString = format.format(myDate);
                              String shipName = widget.shipList[widget.newresult[index]['ship_id']];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: cardColor,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskItem(item: widget.newresult[index]['id'], shipList: widget.shipList),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(widget.newresult[index]['name'], style: const TextStyle(fontSize: 18.0)),
                                    subtitle: Text("Срок: $dateString \nТеплоход: $shipName", style: const TextStyle(fontSize: 12.0)),
                                  ),
                                ),
                              );
                            }
                        );

                      }
                      else
                      {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                  ),
          appBar: AppBar(
            title: Text(widget.title),
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
                        builder: (context) => AddItem(shipList: shipsListList),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle)
              ),
              PopupMenuButton(
                //key: _menuKey,
                icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white
                ),
                itemBuilder: (_) => const<PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      value: '0',
                      child: Text("Все задачи")
                  ),
                  PopupMenuItem<String>(
                      value: '1',
                      child: Text("Панферов")
                  ),
                  PopupMenuItem<String>(
                      value: '2',
                      child: Text('Достоевский')
                  ),
                ],
                onSelected: (value) {
                  //print("value:$value");
                  var shipId = int.parse(value);
                  print(shipId);
                  var titleMainScreen = "";
                  if(value == "0") {
                    titleMainScreen = "Все задачи";
                  } else {
                    titleMainScreen = widget.shipList[value];
                  }
                  print(titleMainScreen);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(ship: shipId, title: titleMainScreen, shipList: widget.shipList),
                    )
                  );
                },
              )
            ],
          ),
        )
    );

  }

}