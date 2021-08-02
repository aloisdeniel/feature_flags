import 'package:feature_flags/feature_flags.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

const features = [
  Feature('DECREMENT', name: 'Decrement'),
  Feature('RESET', name: 'Reset'),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Features(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.check_box),
            onPressed: () {
              DebugFeatures.show(
                context,
                availableFeatures: features,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          if (Features.isFeatureEnabled(context, 'DECREMENT'))
            FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
            ),
          if (Features.isFeatureEnabled(context, 'RESET'))
            FloatingActionButton(
              onPressed: _resetCounter,
              tooltip: 'Reset',
              child: Icon(Icons.delete),
            ),
        ],
      ),
    );
  }
}
