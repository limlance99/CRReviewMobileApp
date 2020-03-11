/*
Authors: JV Afable, JP Chanchico, Lance Lim
This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.
Code History:
	Mar 11, 2020: JP Chanchico - Initialized file.
*/

import 'package:connectivity/connectivity.dart';
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
  PageController _pageControl;

  Connection _connection;
  Map _source;

  bool _show;
  String title;
  int _selected;

  GlobalKey key;

  @override
  void initState() {
    super.initState();
    _show = true;
    _scrollControl = ScrollController();
    _pageControl = PageController();
    title = widget.title;
    _selected = 0;
    _source = {ConnectivityResult.none: false};
    _connection = Connection.instance;

    _connection.init();
    _connection.stream.listen((source) {
      setState(() {
        _source = source;
      });
      if (!_connected()) {
        showOKBox('You are offline.', 'Please check your internet connection.', context, Icons.network_check, () {
          print('OK is pressed');
        });
      }
    });

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
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < 0) {
            print('swiping right');
            setState(() {
              _selected = 1;
              _show = true;
              _pageControl.animateToPage(_selected, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
            });
          }
        },
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageControl,
          onPageChanged: (index) {
            setState(() => _selected = index);
          },
          children: <Widget>[
            CRList(scrollControl: _scrollControl,),
            CRMap(),
          ],
        ),
      ),
      backgroundColor: Colors.green[50],
      bottomNavigationBar: AnimatedContainer(
        curve: Curves.decelerate,
        duration: Duration(milliseconds: 500),
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
          _pageControl.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        });
      },
    );
  }

  bool _connected() {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        return false;
        break;
      case ConnectivityResult.mobile:
        return true;
        break;
      case ConnectivityResult.wifi:
        return true;
      default:
        return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _connection.closeStream();
    _scrollControl.dispose();
  }
}