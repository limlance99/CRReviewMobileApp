/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Jan 23, 2020: Lance Lim - Initialized file.
*/

import 'package:json_annotation/json_annotation.dart';


// CR: class for the main CR, who's main use is to be able to send data in JSON format.     
@JsonSerializable()
class CR {
  int locationid; 
  int floor;
  String gender;
  List facilities;

  CR(this.locationid, this.floor, this.gender, this.facilities);

  factory CR.fromJson(Map<String, dynamic> json) {
    return CR(
      json['locationid'],
      json['floor'],
      json['gender'],
      json['facilities'],
    );
  }
  
  // toMap: maps the values of the attributes of a CR into a key-value pair map.
  //       returns a map that is JSON convertable. 
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["locationid"] = locationid;
    map["floor"] = floor;
    map["gender"] = gender;
    map["facilities"] = facilities;
 
    return map;
  }
}