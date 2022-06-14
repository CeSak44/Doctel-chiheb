import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Page/adress.dart';
import 'package:get/get.dart';

class creat_ordonnance extends StatefulWidget {
  creat_ordonnance({Key? key, required this.appid}) : super(key: key);
  var appid;

  @override
  State<creat_ordonnance> createState() => _creat_ordonnanceState(appid: appid);
}

class _creat_ordonnanceState extends State<creat_ordonnance> {
  var appid;

  _creat_ordonnanceState({Key? key, required this.appid});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String ordonnaceData = '';
              String contrlrText = _controllers
                  .where((element) => element.text != "")
                  .fold("",
                      (acc, element) => acc += "${element.text}\n"); // _counter
              String counterText = '';
              for (var i = 0; i < _controllers.length; i++) {
                if (_controllers[i].text != '') {
                  ordonnaceData = ordonnaceData +
                      _controllers[i].text +
                      '     * ' +
                      _counter[i].toString() +
                      '\n';
                  counterText = counterText + _counter[i].toString() + '\n';
                }
              }

              final alert = AlertDialog(
                title: const Text('Are you sure ?'),
                //   content: Text(teext),
                content: Table(
                  children: [
                    TableRow(children: [
                      Text(contrlrText.trim()),
                      Text(counterText.trim())
                    ])
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('Appointments')
                          .doc(appid)
                          .update({'Ordonnance': ordonnaceData});

                      Navigator.of(context).pop();
                      Get.back();
                    },
                    child: const Text("Submit"),
                  ),
                ],
              );
              if (ordonnaceData.isNotEmpty) {
                 await showDialog(
                context: context,
                builder: (BuildContext context) => alert,
              );
              }
             
            },
            child: Icon(Icons.upload),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Ordonnance"),
          ),
          body: Column(
            children: [
              Expanded(child: _listView()),
              addTextField(),
              removeTextField(),
            ],
          )),
    );
  }

  TextButton removeTextField() {
    return TextButton.icon(
        onPressed: () {
          setState(() {
            if (_controllers.isNotEmpty && _fields.isNotEmpty) {
              _controllers.removeLast();
              _fields.removeLast();
            }
          });
        },
        icon: Icon(Icons.add),
        label: Text('remove item'));
  }

  TextButton addTextField() {
    return TextButton.icon(
        onPressed: () {
          int counter = 1;
          final controller = TextEditingController();
          final field = TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "item${_controllers.length + 1}",
            ),
          );

          setState(() {
            _controllers.add(controller);
            _fields.add(field);
            _counter.add(counter);
          });
        },
        icon: Icon(Icons.add),
        label: Text('add item'));
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(child: _fields[index]),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (_counter[index] != 1) {
                        _counter[index]--;
                      }
                    });
                  },
                  icon: const Icon(Icons.remove_circle)),
              Text(
                _counter[index].toString(),
                style: const TextStyle(fontSize: 17),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _counter[index]++;
                    });
                  },
                  icon: const Icon(Icons.add_circle))
            ],
          ),
        );
      },
    );
  }

  final List<TextEditingController> _controllers = [];
  final List<TextField> _fields = [];
  final List<int> _counter = [];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
