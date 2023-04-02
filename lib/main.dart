import 'package:flutter/material.dart';

import 'package:germes_tasks/rest/Rest.dart';
import 'package:germes_tasks/config/Settings.dart';
import 'screens/MainScreen.dart';
import 'screens/TaskItem.dart';
import 'screens/AddItem.dart';
import 'package:intl/intl.dart';

void main() async {

  var tl  = Rest(url,token);
  var shipList = await tl.GetRestJson("getShipsList");
  //var result = await tl.GetTasksList("getGlobalTaskList");
  List<String> shipsListList = [];
  //print(shipList);
  //print(shipList.runtimeType);
  var i = 0;
  for(var v in shipList.values) {
    //print(v);
    shipsListList.insert(i,v);
    i++;
  }
  //print(shipsListList);
  //print(shipsListList.runtimeType);

  runApp(MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/':(BuildContext context) => MainScreen(ship: 0, title: "Все задачи", shipList: shipList),
        '/1':(BuildContext context) => MainScreen(ship: 1, title: "Панферов", shipList: shipList),
        '/2':(BuildContext context) => MainScreen(ship: 2, title: "Достоевский", shipList: shipList),
        '/add':(BuildContext context) => AddItem(shipList: shipsListList),
      },

      onGenerateRoute: (routeSettings){
        var path = routeSettings.name!.split('/');
        if (path[1] == "view") {
          return MaterialPageRoute(
            builder: (context) => new TaskItem(item: path[2], shipList: shipList),
            settings: routeSettings,
          );
        }
      }

  ));

}