import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../forms/add_cr.dart';
import '../utility.dart';
import './view_cr.dart';

class Location extends StatefulWidget {
  final location;
  Location({
    Key key,
    @required this.location,
  }) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}


class _LocationState extends State<Location> {
  var location;

  List data = [];

  @override
  void initState() {
    super.initState();
    location = widget.location;
    this.getJSONData();
  }

  List<Widget> buildLocationCRs() {
    List<Widget> ret = [];
    List crs = [];


    for (var cr in data) {
      if (cr["location"]["address"] == location["address"]) {
        crs.add(cr);
      }
    }

    if (crs.length == 0) {
      ret.add(
          ListTile(
            title: Text(
              'No available CRs.',
              style: TextStyle(
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          )
      );
    }
    for (var i = 0; i < crs.length; i++) {
      ret.add(
          ListTile(
              title: floorOfCR(crs[i]["floor"]),
              trailing: genderIcon(crs[i]["gender"]),
              onTap: () async {
                bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewCR(title: "View CR", cr: crs[i]),
                    )
                );
                if (result) {
                  getJSONData();
                }
              }
          )
      );
      if (i != crs.length - 1) {
        ret.add(Divider(
          indent: 20.0,
          endIndent: 20.0,
          thickness: 1.0,
        ));
      }
    }


    return ret;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location["address"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: buildLocationCRs(),
        )
      ),
    );
    /*return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: MaterialColor(0xFF0F4C81, colorSwatch()),
          ),
          child: Text(
            location["address"],
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.all(4),
        )
      ] + SingleChildScrollView(child: buildLocationCRs()),
    );*/
  }

  Future<void> getJSONData() async {

    // url: the address that will be used to get the data.
    var url = 'https://crreviewapi.herokuapp.com/api/crs';

    // response: response of the GET request
    var response  = await http.get(url);
    print(response);
    if (response.statusCode == 200) {

      // jsonResponse: response body decoded from json
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      if (mounted)
        setState(() {
          data = jsonResponse;
        });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    print("Get JSON got called");
  }


}