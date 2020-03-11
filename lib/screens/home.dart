/*
Authors: JV Afable, JP Chanchico, Lance Lim
This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.
Code History:
	Mar 11, 2020: JP Chanchico - Initialized file.
*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utility.dart';
import 'cr_map.dart';
import 'cr_list.dart';

class Home extends StatefulWidget {
  final String title;

  Home({
    Key key,
    @required this.title
  }) : super(key: key);

  // title: Title of the screen.

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollControl;
  bool _show;
  String title;
  int _selected;

  GlobalKey key;

  @override
  void initState() {
    super.initState();
    _show = true;
    _scrollControl = ScrollController();
    title = widget.title;
    _selected = 0;
    key = GlobalKey();

    _scrollControl.addListener(() {
      if (_scrollControl.position.userScrollDirection == ScrollDirection.reverse) {
        if (_show) {
          setState(() {
            print('scrolling down');
            _show = false;
          });
        }
      }
      if (_scrollControl.position.userScrollDirection == ScrollDirection.forward) {
        if (!_show) {
          setState(() {
            print('scrolling up');
            _show = true;
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: pageChooser(),
      backgroundColor: Colors.green[50],
      bottomNavigationBar: AnimatedContainer(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 400),
        height: _show ? 56.0 : 0.0,
        child: Wrap(children: <Widget>[botNavBar()]),
      ),
    );
  }

  Widget botNavBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          title: Text("Locations"),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Map",)
        ),
      ],
      currentIndex: _selected,
      selectedItemColor: MaterialColor(0xFF0F4C81, colorSwatch()),
      onTap: (index) {
        setState(() {
          this._selected = index;
        });
      },
    );
  }

  Widget pageChooser() {
    switch (this._selected) {
      case 0:
        return CRList(key: this.key, scrollControl: _scrollControl,);
        break;
      case 1:
        if (_selected == 1) {
          setState(() {
            _show = true;
          });
        }
        return CRMap();
        break;
      default:
        return CRList(key: this.key, scrollControl: _scrollControl,);
    }
  }
}