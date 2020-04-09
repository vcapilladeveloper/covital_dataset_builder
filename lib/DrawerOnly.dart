import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:community_material_icon/community_material_icon.dart';

enum DrawerSections {
  home,

}
class DrawerOnly extends StatefulWidget {
  final List<DrawerSections> whatToNotDraw;

  const DrawerOnly({this.whatToNotDraw});
  @override
  _DrawerOnlyState createState() => new _DrawerOnlyState();
}

class _DrawerOnlyState extends State<DrawerOnly>
{

  _launchWebsite() async {
    const url = 'https://www.covital.org/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchGithubIssue() async {
    const url = 'https://github.com/CoVital-Project/covital_dataset_builder/issues';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
//    _instagramTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new Drawer(
        child: new ListView(
            children: <Widget>[

              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: Image.asset("assets/logo.png", fit: BoxFit.fill,),
              ),
//              UserAccountsDrawerHeader(
////            child:
//
//                currentAccountPicture: Image.asset("assets/logo.png", fit: BoxFit.contain,),
//                accountName: Text("CoVital"),
//                accountEmail: null,
//
//
//              ),

//              ListTile(
//                leading: Icon(Icons.settings),
//                title: Text("Spo2"),
//                onTap: (){
//                  Navigator.of(context).pop();
//                  Navigator.of(context).pushNamed("/specs");
//                },
//              ),

              ListTile(
                leading: Icon(Icons.email),
//                  padding: const EdgeInsets.all(15.0),
                title: Text("Feedback"),
//                subtitle: Text("fridgify.app@gmail.com"),
                onTap: () {
                  launch("mailto:hello@covital.org?subject=Covital Data collection feedback&body=");
                },
//
              ),

              ListTile(
                leading: Icon(Icons.bug_report),
//                  padding: const EdgeInsets.all(15.0),
                title: Text("Report an issue"),
//                subtitle: Text("Having an issue? Report it here"),
                onTap: _launchGithubIssue,
//
              ),

              ListTile(
                leading: Icon(CommunityMaterialIcons.web),
//                  padding: const EdgeInsets.all(15.0),
                title: Text("CoVital"),
//                subtitle: Text("To website"),
                onTap: _launchWebsite,
//
              ),

              ListTile(
                leading: Icon(CommunityMaterialIcons.help),
//                  padding: const EdgeInsets.all(15.0),
                title: Text("Tutorial"),
//                subtitle: Text("fridgify.app@gmail.com"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/start');
                },
//
              ),


            ])
    );


  }


}