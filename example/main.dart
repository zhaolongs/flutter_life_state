import 'package:flutter/material.dart';
import 'package:flutter_life_state/flutter_life_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("测试生命周期"),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new TestPage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends BaseLifeState<TestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A页面"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(" push B页面 "),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new TestBPage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }


  @override
  void onWillCreat() {
    super.onWillCreat();
    print(" A 页面 onWillCreat");
  }
  @override
  void onCreat() {
    super.onCreat();
    print(" A 页面 onCreat");
  }
  @override
  void onStart() {
    super.onStart();
    print(" A 页面 onStart");
  }
  @override
  void onResumed() {
    super.onResumed();
    print(" A 页面 onResumed");
  }
  @override
  void onPause() {
    super.onPause();
    print(" A 页面 onPause");
  }
  @override
  void onStop() {
    super.onStop();
    print(" A 页面 onStop");
  }
  @override
  void onWillDestory() {
    super.onWillDestory();
    print(" A 页面 onWillDestory");
  }
  @override
  void onDestory() {
    super.onDestory();
    print(" A 页面 onDestory");
  }
}

class TestBPage extends StatefulWidget {
  @override
  _TestBPageState createState() => _TestBPageState();
}

class _TestBPageState extends BaseLifeState<TestBPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("B页面"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text("返回A页面 "),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ),
    );
  }


  @override
  void onWillCreat() {
    super.onWillCreat();
    print(" B 页面 onWillCreat");
  }
  @override
  void onCreat() {
    super.onCreat();
    print(" B 页面 onCreat");
  }
  @override
  void onStart() {
    super.onStart();
    print(" B 页面 onStart");
  }
  @override
  void onResumed() {
    super.onResumed();
    print(" B 页面 onResumed");
  }
  @override
  void onPause() {
    super.onPause();
    print(" B 页面 onPause");
  }
  @override
  void onStop() {
    super.onStop();
    print(" B 页面 onStop");
  }
  @override
  void onWillDestory() {
    super.onWillDestory();
    print(" B 页面 onWillDestory");
  }
  @override
  void onDestory() {
    super.onDestory();
    print(" B 页面 onDestory");
  }
}
