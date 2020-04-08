import 'package:covital_dataset_builder/user_data_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExamplePage extends StatefulWidget {
  ExamplePage({Key key}) : super(key: key);

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final ValueNotifier<double> notifier = ValueNotifier(0);
  int pageCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
            children: <Widget>[
              SlidingTutorial(
                pageCount: pageCount,
                notifier: notifier,
              ),
              Align(
                alignment: Alignment(0, 0.85),
                child: Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Colors.white,
                ),
              ),
              Align(
                alignment: Alignment(0, 0.99),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                      child: Text("Done"),
                      onPressed: (){
                        UserDataContainer.of(context).data.user_settings.has_played_tutorial = true;
                        UserDataContainer.of(context).data.user_settings.save();
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    ),


                    SlidingIndicator(
                      indicatorCount: pageCount,
                      notifier: notifier,
                      activeIndicator: Icon(
                        Icons.check_circle,
                        size: 10,
                        color: Theme.of(context).accentColor,
                      ),
                      inActiveIndicator: SvgPicture.asset(
                        "assets/hollow_circle.svg",
                      ),
                      margin: 8,
                      sizeIndicator: 10,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}




class SlidingTutorial extends StatefulWidget {
  final ValueNotifier<double> notifier;
  final int pageCount;

  const SlidingTutorial(
      {Key key, @required this.notifier, @required this.pageCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlidingTutorial();
}

class _SlidingTutorial extends State<SlidingTutorial> {
  var _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    _pageController..addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackgroundColor(
        pageController: _pageController,
        pageCount: widget.pageCount,
        child: Container(
            child: PageView(
                controller: _pageController,
                children: List<Widget>.generate(
                    widget.pageCount, (index) => _getPageByIndex(index)))));
  }

  Widget _getPageByIndex(int index) {
    switch (index % 3) {
      case 0:
        return ECommercePage(index, widget.notifier);
      case 1:
        return ECommercePage(index, widget.notifier);
      case 2:
        return ECommercePage(index, widget.notifier);
      default:
        throw ArgumentError("Unknown position: $index");
    }
  }

  _onScroll() {
    widget.notifier?.value = _pageController.page;
  }
}




class ECommercePage extends StatelessWidget {
  final int page;
  final ValueNotifier<double> notifier;

  ECommercePage(this.page, this.notifier);

  @override
  Widget build(BuildContext context) {
    return SlidingPage(
      notifier: notifier,
      page: page,
      child: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 0.4,
                child: SlidingContainer(
                    child: Image.asset(
                      "assets/logo.png",
                    ),
                    offset: 300),
              ),
            ),
//            Center(
//              child: FractionallySizedBox(
//                widthFactor: 0.55,
//                heightFactor: 0.18,
//                child: SlidingContainer(
//                    child: Image.asset(
//                      "assets/s_2_1.png",
//                    ),
//                    offset: 100),
//              ),
//            ),
//            Opacity(
//              opacity: 0.5,
//              child: Align(
//                alignment: Alignment(0.3, -0.35),
//                child: FractionallySizedBox(
//                  widthFactor: 0.75,
//                  heightFactor: 0.20,
//                  child: SlidingContainer(
//                      child: Image.asset(
//                        "assets/s_2_2.png",
//                      ),
//                      offset: 170),
//                ),
//              ),
//            ),
//            Align(
//              alignment: Alignment(-0.2, -0.27),
//              child: FractionallySizedBox(
//                widthFactor: 0.16,
//                heightFactor: 0.07,
//                child: SlidingContainer(
//                    child: Image.asset(
//                      "assets/s_2_4.png",
//                    ),
//                    offset: 50),
//              ),
//            ),
//            Align(
//              alignment: Alignment(0.3, -0.35),
//              child: FractionallySizedBox(
//                widthFactor: 0.14,
//                heightFactor: 0.07,
//                child: SlidingContainer(
//                    child: Image.asset(
//                      "assets/s_2_6.png",
//                    ),
//                    offset: 150),
//              ),
//            ),
//            Align(
//              alignment: Alignment(0.8, -0.3),
//              child: FractionallySizedBox(
//                widthFactor: 0.15,
//                heightFactor: 0.10,
//                child: SlidingContainer(
//                    child: Image.asset(
//                      "assets/s_2_5.png",
//                    ),
//                    offset: 50),
//              ),
//            ),
//            Align(
//              alignment: Alignment(0.7, 0.1),
//              child: FractionallySizedBox(
//                widthFactor: 0.25,
//                heightFactor: 0.15,
//                child: SlidingContainer(
//                    child: Image.asset(
//                      "assets/s_2_7.png",
//                    ),
//                    offset: 200),
//              ),
//            ),
//            Align(
//              alignment: Alignment(0, 0.78),
//              child: SlidingContainer(
//                offset: 250,
//                child: Text(
//                  "e-Commerce",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                    fontSize: 30,
//                    color: Colors.white,
//                  ),
//                ),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}