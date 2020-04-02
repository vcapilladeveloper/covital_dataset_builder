//import 'package:covital_dataset_builder/user_data.dart';
import 'package:flutter/material.dart';
import 'user_data_container.dart';
import 'survey.dart';

class DeviceSpecsScreen extends StatefulWidget {
  @override
  _DeviceSpecsScreenState createState() => new _DeviceSpecsScreenState();
}

class _DeviceSpecsScreenState extends State<DeviceSpecsScreen> {
  String brand;
  String reference_number;

  @override
  void initState() {
    super.initState();

//    SchedulerBinding.instance.addPostFrameCallback((_){
//      runInitTasks();
//    });
  }

//  @protected
//  Future runInitTasks() async {
////    await UserDataContainer.of(context).data.initialize();
////    Navigator.of(context).pushReplacementNamed('/home');
//  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
        appBar: AppBar(
          title: Text("Specs"),
//        actions: <Widget>[
//          FlatButton(
//            child: Text("Save"),
//            onPressed: save,
//          )
//        ],
        ),
        body: new Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
//              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(children: <Widget>[
                              ListTile(
                                title: Text("Device brand"),
                              ),
                              TextField(
//                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.input),
                                    labelText: "brand"
                                    //                  labelText: 'Frequency of capture (s)'
                                    ),
                                onChanged: (String s) {
                                  print("Submitted: " + s);
                                  setState(() {
                                    setState(() {
                                      brand = s;
                                    });
                                  });
                                },
                              )
                            ])))),
//                Divider(),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(children: <Widget>[
                              ListTile(
                                title: Text("Device ref"),
                              ),
                              TextField(
//                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.input),
                                    labelText: "ref"
                                    //                  labelText: 'Frequency of capture (s)'
                                    ),
                                onChanged: (String s) {
                                  print("Submitted: " + s);
                                  setState(() {
                                    setState(() {
                                      reference_number = s;
                                    });
                                  });
                                },
                              )
                            ])))),
//                Divider(),
                OutlineButton(
                  child: Text(
                    "Save",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: save,
                )
              ],
            )));
  }

  void save() {
    UserDataContainer.of(context).data.commercial_device = CommercialDevice();
    var settings = UserDataContainer.of(context).data.commercial_device;

    settings.brand = brand;
    settings.reference_number = reference_number;

    assert(UserDataContainer.of(context).data.commercial_device != null);


    Navigator.of(context).pushReplacementNamed('/home');
  }
}
