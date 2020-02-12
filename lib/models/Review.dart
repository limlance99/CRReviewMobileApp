/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Jan 23, 2020: John Philip Chanchico - Initialized file.
*/

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Review {
  int crid;
  int reviewText;
  int rating1;
  int rating2;
  int rating3;

  Review(this.crid, this.reviewText, this.rating1, this.rating2, this.rating3);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      json['crid'];
      json['reviewText'];
      json['rating1'];
      json['rating2'];
      json['rating3'];
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["crid"] = crid;
    map["reviewText"] = reviewText;
    map["rating1"] = rating1;
    map["rating2"] = rating2;
    map["rating3"] = rating3;

    return map;
  }

}
