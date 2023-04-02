import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Rest{

  var _url;
  var _token;

  Rest(String u, String t){
    _url = u;
    _token = t;
  }

  GetRestJson(String action) async {
    final response = await http.post(Uri.parse(_url), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    }, body: {'token':_token,'action':action});
    //print("Response body: ${response.body}");
    final decoded = json.decode(response.body);
    return decoded;
    //print("Response status: ${response.statusCode}");

  }

  GetTasksList(String action) async {
    final response = await http.post(Uri.parse(_url), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    }, body: {'token':_token,'action':action});
    //print("Response body: ${response.body}");
    final decoded = json.decode(response.body);
    return decoded;
    //print("Response status: ${response.statusCode}");

  }

  Future GetTasksInfo(String action, String Item) async {
    final response = await http.post(Uri.parse(_url), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    }, body: {'token':_token,'action':action, 'Item':Item});
    //print("Response body: ${response.body}");
    final decoded = json.decode(response.body);
    return decoded;
    //print("Response status: ${response.statusCode}");

  }

  Future GetTaskPictures(String action, String Item) async {
    final response = await http.post(Uri.parse(_url), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    }, body: {'token':_token,'action':action, 'Item':Item});
    //print("Response body: ${response.body}");
    final decoded = json.decode(response.body);
    return decoded;
    //print("Response status: ${response.statusCode}");

  }

  Future GetTaskPosts(String action, String Item) async {
    final response = await http.post(Uri.parse(_url), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    }, body: {'token':_token,'action':action, 'Item':Item});
    //print("Response body: ${response.body}");
    final decoded = json.decode(response.body);
    return decoded;
    //print("Response status: ${response.statusCode}");

  }

  Future SaveItem(Map Item) async {

    var Data = {};
    Data['token'] = _token;
    Data['action'] = 'SaveItem';
    for(var once in Item.entries){
      // item представляет MapEntry<K, V>
      //print("${item.key} - ${item.value}");
      Data[once.key] = once.value;
    }

    final response = await http.post(Uri.parse(_url), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    }, body: Data);
    //print("Response body: ${response.body}");
    final decoded = json.decode(response.body);
    return decoded;
    //print("Response status: ${response.statusCode}");

  }

}