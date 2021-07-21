import 'package:flutter/material.dart';

import './home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent,
        // fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 14.0,
            color: Colors.red,
          ),
        ),
      ),
      home: MyHomePage(title: 'Django Todo'),
      routes: {
        MyHomePage.routeName: (ctx) => MyHomePage(
              title: "home",
            ),
      },
    );
  }
}
