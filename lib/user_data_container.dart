import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'survey_lib/user_data.dart';
import 'survey_lib/commercial_device.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Import package
import 'package:screen/screen.dart';
import 'survey_lib/survey.dart';


class UserDataContainer extends StatefulWidget {
// Your apps state is managed by the container

// This widget is simply the root of the tree,
// so it has to have a child!

  final Widget child;

  CommercialDevice commercial_device;

  List<CameraDescription> cameras;

//  String last_video;

  UserDataContainer({Key key, this.child, this.commercial_device, this.cameras
//    @required this.userdata,
  }) {
//    print("CREATED USERDATA CONTAINER");
//    print("The name: " + this.userdata.name);
  }

// This creates a method on the AppState that's just like 'of'
// On MediaQueries, Theme, etc
// This is the secret to accessing your AppState all over your app
//  static _UserDataContainerState of(BuildContext context) {
//    return (context.inheritFromWidgetOfExactType(_InheritedUserDataContainer)
//            as _InheritedUserDataContainer);
//  }

  static _InheritedUserDataContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedUserDataContainer>();
//      context.inheritFromWidgetOfExactType(_InheritedUserDataContainer)
//          as _InheritedUserDataContainer;

  @override
  UserDataContainerState createState() => new UserDataContainerState();
}

class UserDataContainerState extends State<UserDataContainer> {
// Just padding the state through so we don't have to
// manipulate it with widget.state.
//  UserDataType userdata  = UserDataType();

//  UserDataType userdata = UserDataType();


  Survey current_survey = Survey();

  String last_video;
  List<CameraDescription> cameras;


  CommercialDevice commercial_device;
  Box commercial_device_hive;
  Box user_settings_hive;
  UserSettings user_settings;


  bool is_init = false;
//  bool isSync = false;


  List<ColorSwatch> colors = [MaterialColor(0xffdfbaa7, Map<int, Color>()),
    MaterialColor(0xffdea887, Map<int, Color>()),
    MaterialColor(0xffd08a6f, Map<int, Color>()),
//    MaterialColor(0xffd08870, Map<int, Color>()),
    MaterialColor(0xff9f614a, Map<int, Color>()),
    MaterialColor(0xff6a4c48, Map<int, Color>()),
    MaterialColor(0xff3a3c37, Map<int, Color>())];


  void initState() {
    super.initState();
    print("Init state container user data!");
    cameras = widget.cameras;
//    last_video = widget.last_video;
    commercial_device = widget.commercial_device;
  }



  @override
  void dispose() {
    super.dispose();
  }


  initialize() async {

    // Get the current brightness:
//    double brightness = await Screen.brightness;

// Set the brightness:
//    Screen.setBrightness(0.5);

// Check if the screen is kept on:
//    bool isKeptOn = await Screen.isKeptOn;

// Prevent screen from going into sleep mode:
    Screen.keepOn(true);

    registerHiveCommercialDevice();
    registerHiveuserSettings();

    print("init state");
    cameras = await availableCameras();
    await Hive.initFlutter();
    commercial_device_hive = await Hive.openBox('lifelapseparam');
    user_settings_hive = await Hive.openBox('usersettings');

    if(commercial_device_hive.isEmpty){
      commercial_device_hive.add(CommercialDevice());
    }
    commercial_device = commercial_device_hive.getAt(0);
    if(user_settings_hive.isEmpty){
      user_settings_hive.add(UserSettings());
    }
    user_settings = user_settings_hive.getAt(0);
//    if(commercial_device == null){
//      commercial_device = CommercialDevice();
//      assert(commercial_device != null);
//    }
    is_init = true;
  }


// So the WidgetTree is actually
// AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new _InheritedUserDataContainer(
      data: this,
//      products: products,
//      purchases: purchases,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedUserDataContainer extends InheritedWidget {
// The data is whatever this widget is passing down.
//  final _UserDataContainerState data;
  UserDataContainerState data;

//  final List<ProductDetails> products;
//  final List<PurchaseDetails> purchases;
//

// InheritedWidgets are always just wrappers.
// So there has to be a child,
// Although Flutter just knows to build the Widget thats passed to it
// So you don't have have a build method or anything.
  _InheritedUserDataContainer({
    Key key,
    @required this.data,
//    @required this.products,
//    @required this.purchases,
    @required Widget child,
  }) : super(key: key, child: child);

// This is a better way to do this, which you'll see later.
// But basically, Flutter automatically calls this method when any data
// in this widget is changed.
// You can use this method to make sure that flutter actually should
// repaint the tree, or do nothing.
// It helps with performance.
  @override
  bool updateShouldNotify(_InheritedUserDataContainer oldWidget) {
//    print("DATA IS THE SAME ? " + (data != oldWidget.data).toString());
    return !(data != oldWidget.data);
  }


}