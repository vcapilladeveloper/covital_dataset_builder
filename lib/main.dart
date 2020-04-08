import 'package:flutter/material.dart';
import 'user_data_container.dart';
import 'package:flutter/scheduler.dart';
import 'O2process/O2_process_page.dart';
import 'home.dart';
import 'ground_truth_page.dart';
import 'device_specs_page.dart';
import 'tutorial.dart';
import 'patient_information_page.dart';
import 'medical_history_page.dart';
import 'review_page.dart';
import 'thank_you_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new UserDataContainer(
        child: MaterialApp(

          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/home': (context) => Home(),
            '/video': (context) => O2ProcessPage(),
            '/gtpage': (context) => GroundTruthPage(),
            '/specs' : (context) => DeviceSpecsScreen(),
            '/tutorial': (context) => ExamplePage(),
            '/patient_information': (context) => PatientInformationPage(),
            '/medical_history': (context) => MedicalHistoryPage(),
            '/review_page': (context) => ReviewPage(),
            '/thank_you': (context) => ThankYouPage(),
//             When navigating to the "/second" route, build the SecondScreen widget.
//            '/lifelapse_edit_page': (context) => TimeLapsePage(),
          },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Code Snippets',
      theme: new ThemeData(primarySwatch: Colors.teal),
      home: new LoadingScreen(),
    ));
  }
}


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => new _LoadingScreenState();

}



class _LoadingScreenState extends State<LoadingScreen>{



  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_){
      runInitTasks();
    });


  }

  @protected
  Future runInitTasks() async {
    await UserDataContainer.of(context).data.initialize();
    print("init state done: " + UserDataContainer.of(context).data.commercial_device.toString());
//    if(UserDataContainer.of(context).data.commercial_device.brand == null){
//      print("Going to specs");
//      Navigator.of(context).pushReplacementNamed('/specs');
//    }
//    else {
      print("Going to home");
      Navigator.of(context).pushReplacementNamed('/tutorial');
//    }
  }



  @override
  Widget build(BuildContext context){
    final ThemeData theme = Theme.of(context);
//    var bright = theme.brightness;
//    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      body: new Center(
        child: Image.asset("assets/logo.png", fit: BoxFit.fill,),
      ),
    );
  }
}