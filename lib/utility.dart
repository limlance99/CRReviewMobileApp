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