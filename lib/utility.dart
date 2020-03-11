/*
Authors: JV Afable, JP Chanchico, Lance Lim
This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.
Code History:
  Jan 23, 2020: Lance Lim - Coded the functions
	Feb 13, 2020: JV Afable - Transferred functions to separate file
*/

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

// _floorOfCR: Widget that handles string logic to display the proper floor of the CR.
// ex. 2 => 2nd Floor.
//   floor: number that represents the floor of an item.
Widget floorOfCR(floor) {

  // floorString: empty string that will eventually store the final string to be printed.
  String floorString = "";

  // lastDigit: the last digit of the floor.
  int lastDigit = floor % 10;
  if (lastDigit == 1) {
    if ((floor % 100) % 11 == 0) floorString = "${floor}th";
    else floorString = "${floor}st";
  }
  else if (lastDigit == 2) floorString = "${floor}nd";
  else if (lastDigit == 3) floorString = "${floor}rd";
  else floorString = "${floor}th";

  return Text("$floorString Floor");
}

Widget facilityIcon(fid) {
  switch(fid) {
    case 1:
      return Image.asset(
        "assets/images/handsoap.png",
        width: 100,
        height: 100,
      );
      break;
    case 2:
      return Image.asset(
        "assets/images/bidet.png",
        width: 100,
        height: 100,
      );
      break;
    default:
      return Image.asset(
        "assets/images/toiletpaper.png",
        width: 100,
        height: 100,
      );
      break;
  }
}

// _genderIcon: Widget that displays the gender logo depending on the gender passed.
//   gender: gender to be used for logo.
Widget genderIcon(gender) {
  // _gender: gender but in string.
  var _gender = gender.toString();
  switch(_gender) {
    case "M":
      // return SvgPicture.asset(
      //   "assets/images/male.svg",
      //   color: Colors.blue,
      // );
      return Icon(
        Icons.person,
        color: Colors.blue,
      );
      break;
    case "F":
      // return SvgPicture.asset(
      //   "assets/images/female.svg",
      //   color: Colors.pink,
      // );
      return Icon(
        Icons.person,
        color: Colors.pink,
      );  
    default:
      return Icon(
        Icons.person,
        color: Colors.grey,
      );
  }
}

Map<int, Color> colorSwatch() {
  Map<int, Color> color = {
    50: Color.fromRGBO(15, 76, 129, .775),
    100: Color.fromRGBO(15, 76, 129, .8),
    200: Color.fromRGBO(15, 76, 129, .825),
    300: Color.fromRGBO(15, 76, 129, .85),
    400: Color.fromRGBO(15, 76, 129, .875),
    500: Color.fromRGBO(15, 76, 129, .9),
    600: Color.fromRGBO(15, 76, 129, .925),
    700: Color.fromRGBO(15, 76, 129, .95),
    800: Color.fromRGBO(15, 76, 129, .975),
    900: Color.fromRGBO(15, 76, 129, 1),
  };
  return color;
}

void showOKBox(String title, String content, BuildContext context, IconData icons, Function onpress) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            icons == null ? Container(width: 0,) : Icon(
              icons,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (onpress != null) {
                onpress();
              }
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: Color(0xFF00B7C3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
      );
    }
  );
}

class Connection {
  Connection._internal();

  static final Connection _instance = Connection._internal();

  static Connection get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get stream => controller.stream;

  void init() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      checkStatus(result);
    });
  }

  void checkStatus(ConnectivityResult result) async {
    bool _online = false;

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _online = true;
      } else
        _online = false;
    } on SocketException catch (_) {
      _online = false;
    }
    controller.sink.add({result: _online});
  }

  void closeStream() {
    controller.close();
  }
}