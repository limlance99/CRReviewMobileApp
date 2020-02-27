/*
Authors: JV Afable, JP Chanchico, Lance Lim
This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.
Code History:
	Jan 20, 2020: Lance Lim - Initialized file.
*/

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
        primarySwatch: Colors.blue,
      ),
      home: CRList(title: 'CR Review'),
    );
  }
}
