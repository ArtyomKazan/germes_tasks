import 'package:flutter/material.dart';
import 'package:germes_tasks/config/Settings.dart';
import 'package:germes_tasks/rest/Rest.dart';
import 'package:germes_tasks/screens/MainScreen.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

DateTime selectedDate = DateTime.now();


class AddItem extends StatelessWidget {

  List shipList = [];

  AddItem({super.key, required this.shipList});


  @override
  Widget build(BuildContext context) {

    print(shipList.runtimeType);

    return MaterialApp(
      title: "Добавить задачу",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Добавить задачу"),
        ),
        body: AddItemForm(shipList: shipList),
      ),
    );
  }
}

class AddItemForm extends StatefulWidget {

  List shipList = [];

  AddItemForm({super.key, required this.shipList});

  @override
  AddItemFormState createState() {
    return AddItemFormState(shipList: shipList);
  }
}

class AddItemFormState extends State<AddItemForm> {

  List shipList = [];

  AddItemFormState({required this.shipList});

  final _formKey = GlobalKey<FormState>();
  var fieldsValue = {};
  var format = DateFormat("d.M.y");
  var tl  = Rest(url,token);

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сохраняем...')),
      );
      //print(FieldsValue);
      await tl.SaveItem(fieldsValue);
      var shipList = await tl.GetRestJson("getShipsList");
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(ship: 0, title: "Все задачи", shipList: shipList),
          ),
        );
      }

    }

  }

  @override
  Widget build(BuildContext context) {

    return
      Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Введите название задачи',
                    labelText: 'Название *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите название задачи';
                    }
                    else {
                      fieldsValue['name'] = value;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  /*controller: _controllerAuthor,*/
                  decoration: const InputDecoration(
                    /*icon: Icon(Icons.person),*/
                    hintText: 'Введите автора задачи',
                    labelText: 'Автор задачи *',
                  ),
                  validator: (value) {
                    fieldsValue['author'] = value;
                    return null;
                  },
                ),
                TextFormField(
                  /*controller: _controllerSort,*/
                  decoration: const InputDecoration(
                    /*icon: Icon(Icons.person),*/
                    hintText: 'Введите сортировку',
                    labelText: 'Сортировка *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите сортировку';
                    }
                    else if(!RegExp(r'^[0-9]+$').hasMatch(value)){
                      return 'Вводим только цифры';
                    }
                    else {
                      fieldsValue['sort'] = value;
                    }
                    return null;
                  },
                ),
                DateTimeField(
                  /*controller: _controllerSrok,*/
                  format: format,
                  decoration: const InputDecoration(
                    /*icon: Icon(Icons.person),*/
                    hintText: 'Введите срок',
                    labelText: 'Срок *',
                  ),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Введите срок';
                    }
                    else {
                      fieldsValue['srok'] = value.toString();
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Теплоход *',
                  ),
                  value: fieldsValue['ship'],
                  hint: const Text(
                    'выберите теплоход',
                  ),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      fieldsValue['ship'] = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      fieldsValue['ship'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "выберите теплоход";
                    } else {
                      return null;
                    }
                  },
                  items: shipList.map((val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  }).toList(),
                ),
                TextFormField(
                  /*controller: _controllerExecutor,*/
                  minLines: 3, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    /*icon: Icon(Icons.person),*/
                    hintText: 'Введите ответственных',
                    labelText: 'Ответственные *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите ответственных';
                    }
                    else {
                      fieldsValue['executors'] = value;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Введите помощников',
                    labelText: 'Помощники',
                  ),
                  validator: (value) {
                    fieldsValue['helpers'] = value;
                    return null;
                  },
                ),
                TextFormField(
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Введите текст задачи',
                    labelText: 'Текст задачи *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите текст задачи';
                    }
                    else {
                      fieldsValue['text'] = value;
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Добавить задачу')
                ),
              ],
            ),
          )
      );
  }
}
