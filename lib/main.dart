import 'package:flutter/material.dart';
import 'Screens/MyCards.dart';
import 'Models/SlideRoute.dart';
import 'Screens/Settings.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentColor = 0;
  List<Color> _colors = [ //Get list of colors
    Color.fromARGB(255,112,112,112),
    Color.fromARGB(255,15,232,149),
  ];


  void _changeARColor() {
    setState(() {
      _currentColor = _currentColor ^ 1;
    });
  }
  Widget bottomRow(){
        return new Padding(
          padding: const EdgeInsets.all(50.0),
          child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    SlideRightRoute(page:MyCards()),
                  );
                },
                tooltip: 'List',
                iconSize: 40.0,
                icon: Icon(
                  Icons.list,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    SlideLeftRoute(page:Settings()),
                  );
                },
                tooltip: 'Person',
                iconSize: 40.0,
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
          ]
          )
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:70.0,left: 20.0),
              child: FlatButton(
                child: new  Text(
                    'AR',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 40.0,
                      color: _colors[_currentColor],
                    ),
                ),
                onPressed: _changeARColor,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ],
        ),

      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:bottomRow()

    );
  }
}
