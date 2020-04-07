//import 'package:covital_dataset_builder/user_data.dart';
import 'package:flutter/material.dart';
import 'user_data_container.dart';
import 'package:flutter/scheduler.dart';

class DeviceSpecsScreen extends StatefulWidget {
  @override
  _DeviceSpecsScreenState createState() => new _DeviceSpecsScreenState();
}

class _DeviceSpecsScreenState extends State<DeviceSpecsScreen> {
  String brand;
  String reference_number;

//  TextEditingController _controller_brand = TextEditingController();
//  TextEditingController _controller_reference = TextEditingController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_){
      runInitTasks();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
//    _controller_brand.dispose();
//    _controller_reference.dispose();
    super.dispose();
  }

  @protected
  Future runInitTasks() async {
    var settings = UserDataContainer.of(context).data.commercial_device;
    brand = settings.brand;
    reference_number = settings.model;
  }

  @override
  Widget build(BuildContext context) {
    var settings = UserDataContainer.of(context).data.commercial_device;
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
                              TextFormField(
//                                controller: _controller_brand,
                                initialValue: settings.brand == null ? "" : settings.brand,
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
                              TextFormField(
//                                controller: _controller_reference,
                                initialValue: settings.model == null ? "" : settings.model,
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
//    UserDataContainer.of(context).data.commercial_device = CommercialDevice();
    var settings = UserDataContainer.of(context).data.commercial_device;

    bool first_init = false;
    if(settings.brand == null){
      first_init = true;
    }

    settings.brand = brand;
    settings.model = reference_number;

    assert(UserDataContainer.of(context).data.commercial_device != null);

    settings.save();

    if(first_init == true) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
    else{
      Navigator.of(context).pushNamed('/home');
    }
  }
}
