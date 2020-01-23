import 'package:flutter/material.dart';
import './screens/cr_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CR Review',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CRList(title: 'CR Review'),
    );
  }
}