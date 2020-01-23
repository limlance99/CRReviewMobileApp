import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/CR.dart';

class AddCR extends StatefulWidget {
  @override
  _AddCRState createState() => _AddCRState();
}

class _AddCRState extends State<AddCR> {
  List locations = [];
  List facilities = [];
  List<bool> facilityBoxes = [];

  int locationDropdown = 1;
  String genderDropdown = "M";

  final TextEditingController _floorNumberController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();

    // get the locations
    this.getLocations();
    this.getFacilities();
  }

  Future<void> getLocations() async {
    var url = 'https://crreviewapi.herokuapp.com/api/locations';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (mounted)
      setState(() {
        locations = jsonResponse;
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }

  Future<void> getFacilities() async {
    var url = 'https://crreviewapi.herokuapp.com/api/facilities';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (mounted)
      setState(() {
        facilities = jsonResponse;
        for (var i = 0; i < facilities.length; i++) facilityBoxes.add(false);
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }

  Future<void> _addNewCR() async {
    var url = 'https://crreviewapi.herokuapp.com/api/crs';
    var locationid = locationDropdown;
    var floor = int.parse(_floorNumberController.text);
    var gender = genderDropdown;
    var availableFacilities = [];

    var i = 0;
    for (var facility in facilities) {
      if (facilityBoxes[i] == true) availableFacilities.add(facility["fid"]);
      i++;
    }
    print(availableFacilities);
    var newCR = new CR(locationid, floor, gender, availableFacilities).toMap();
    var bodyEncoded = convert.json.encode(newCR);

    print(bodyEncoded);
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: bodyEncoded,
    );
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text("Add CR"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addNewCR();
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            // padding
            Padding(padding: EdgeInsets.all(15)),

            // location dropdown
            Text("Location:"),
            locations.isNotEmpty
                ? DropdownButton<int>(
                    isExpanded: true,
                    value: locationDropdown,
                    onChanged: (int newValue) {
                      setState(() {
                        locationDropdown = newValue;
                      });
                    },
                    items: locations.map<DropdownMenuItem<int>>((location) {
                      return DropdownMenuItem<int>(
                        value: location["locationid"],
                        child: Text("${location["address"]}"),
                      );
                    }).toList(),
                  )
                : Text("Loading"),

            // padding
            Padding(padding: EdgeInsets.all(5)),

            // gender dropdown
            Text("Gender:"),
            DropdownButton<String>(
              isExpanded: true,
              value: genderDropdown,
              onChanged: (String newValue) {
                setState(() {
                  genderDropdown = newValue;
                });
              },
              items: <String>["M", "F", "N"]
                  .map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: _genderString(value),
                );
              }).toList(),
            ),

            // Floor number
            TextField(
              controller: _floorNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Floor",
                hintText: "What floor is it in?",
              ),
            ),

            // more padding
            Padding(
              padding: EdgeInsets.all(20),
            ),

            // List of Facilities
            Text("Facilities:"),
            _listOfFacilities(),
          ],
        ),
      ),
    );
  }

  Widget _genderString(gender) {
    String fullgender;
    switch (gender) {
      case "M":
        fullgender = "Male";
        break;
      case "F":
        fullgender = "Female";
        break;
      case "N":
        fullgender = "Gender Neutral";
        break;
    }

    return Text("$fullgender");
  }

  Widget _listOfFacilities() {
    List<Widget> facilitycheckboxes = [];

    if (facilities.isEmpty) {
      facilitycheckboxes.add(Text("Loading"));
    } else {
      var i = 0;
      for (var facility in facilities) {
        facilitycheckboxes.add(_buildRow(facility, i));
        i++;
      }
    }
    var container = Column(
      children: facilitycheckboxes,
    );
    return container;
  }

  Widget _buildRow(item, int index) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("${item["facilityname"]}")),
        Checkbox(
          value: facilityBoxes[index],
          onChanged: (value) {
            setState(() {
              facilityBoxes[index] = value;
            });
          },
        ),
      ],
    );
  }
}
