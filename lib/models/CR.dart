import 'package:json_annotation/json_annotation.dart';

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
      json['id'],
      json['title'],
      json['body'],
    );
  }
 
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["locationid"] = locationid;
    map["floor"] = floor;
    map["gender"] = gender;
    map["facilities"] = facilities;
 
    return map;
  }
}