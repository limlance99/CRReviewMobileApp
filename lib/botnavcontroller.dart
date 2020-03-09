import 'package:flutter/material.dart';
import './screens/cr_list.dart';
import './screens/cr_map.dart';
import 'utility.dart';


class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() => _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState extends State<BottomNavigationBarController> {
  final List<Widget> _pages = [
    CRList(key: PageStorageKey('Page1')),
    CRMap(key: PageStorageKey('Page2')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selected = 0;

  Widget _bottomNavBar(_selected) => BottomNavigationBar(
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
        _selected = index;
      });
    }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavBar(_selected),
      body: PageStorage(
        child: _pages[_selected],
        bucket: bucket,
      ),
    );
  }
}