import 'package:flutter/material.dart';


class CRMap extends StatefulWidget {
  CRMap({Key key}) : super(key: key);

  @override
  _CRMapState createState() => _CRMapState();
}

class _CRMapState extends State<CRMap> {
  String title = "";

  @override
  void initState() {
    super.initState();
    title = 'CR Review';
  }

  Widget build(BuildContext context) {
    print('CR Map build');
    return Scaffold(
        body: Text(
          'Map in here',
          style: TextStyle(
            fontSize: 30
          ),
          textAlign: TextAlign.center,
        )
    );
  }
}