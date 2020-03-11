/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Feb 13, 2020: John Philip Chanchico - Initialized file.
*/

import 'package:json_annotation/json_annotation.dart';

// Review: class for the reviews, who's main use is to be able to send data in JSON format.     
@JsonSerializable()
class Review {
  int crid;
  String reviewText;
  double cleanliness;
  double comfort;
  double facilities;

  Review(this.crid, this.reviewText, this.cleanliness, this.comfort, this.facilities);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      json['crid'],
      json['reviewtext'],
      json['cleanliness'],
      json['comfort'],
      json['facilities'],
    );
  }

  // toMap: maps the values of the attributes of a Review into a key-value pair map.
  //       returns a map that is JSON convertable. 
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["crid"] = crid;
    map["reviewtext"] = reviewText;
    map["cleanliness"] = cleanliness.toInt();
    map["comfort"] = comfort.toInt();
    map["facilities"] = facilities.toInt();

    return map;
  }

}
