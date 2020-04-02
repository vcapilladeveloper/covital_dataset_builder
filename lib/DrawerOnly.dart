import 'package:flutter/material.dart';

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
                    color: Theme.of(context).accentColor
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

              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Spo2"),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/specs");
                },
              ),

            ])
    );


  }


}