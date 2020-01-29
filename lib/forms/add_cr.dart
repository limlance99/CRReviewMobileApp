/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Jan 23, 2020: Lance Lim - Initialized file.
*/

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/CR.dart';

// AddCR: Stateful Widget that will contains the states for the Add CR form.
class AddCR extends StatefulWidget {
  @override
  _AddCRState createState() => _AddCRState();
}

// _AddCRState: State that will provide all the logic and UI for the ADD CR form. 
class _AddCRState extends State<AddCR> {
  
  // locations: will contain the list of locations to be presented in the drop down.
  List locations = [];

  // facilities: will contain the list of facilities to be presented by the list of checkboxes.
  List facilities = [];

  // facilityBoxes: will contain the logic for every single checkbox in the list of facilities. 
  List<bool> facilityBoxes = [];

  // locationDropdown: initial value of the location dropdown (needs to be initialized).
  int locationDropdown = 1;

  // genderDropdown: initial value of the gender dropdown (needs to be initialized). 
  String genderDropdown = "M";

  // _floorNumberController: controller that is in charge of everything related to the floor input text.
  final TextEditingController _floorNumberController =
      new TextEditingController();

  // initState: Logic to be done before Add CR build is called.
  @override
  void initState() {
    super.initState();

    // get the locations
    this.getLocations();
    this.getFacilities();
  }

  // getLocations: HTTP request to get the list of locations from the database.
  Future<void> getLocations() async {
    
    // url: the address that will be used to get the data.
    var url = 'https://crreviewapi.herokuapp.com/api/locations';

    // response: response of the GET request
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

  // getFacilities: HTTP request to get the list of facilities from the database.
  Future<void> getFacilities() async {
    
    // url: the address that will be used to get the data.
    var url = 'https://crreviewapi.herokuapp.com/api/facilities';

    // response: response of the GET request
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

  // _addNewCR: HTTP POST request to add a new CR into the database.
  Future<void> _addNewCR() async {
    
    // url: the address that will be used to get the data.
    var url = 'https://crreviewapi.herokuapp.com/api/crs';

    // locationid: gets the current value of the location dropdown.
    var locationid = locationDropdown;

    // floor: gets the current value of the floor input (parsed into int)
    var floor = int.parse(_floorNumberController.text);

    if (floor < 1) return;
    
    // gender: gets the current value of the gender dropdown.
    var gender = genderDropdown;

    // availableFacilities: will contain the list of facilities (id) that the new CR will have.
    var availableFacilities = [];

    var i = 0;
    for (var facility in facilities) {
      if (facilityBoxes[i] == true) availableFacilities.add(facility["fid"]);
      i++;
    }
    print(availableFacilities);

    // newCR: A new CR class instantiated with all of the values, then turning it into a map (key:value).
    var newCR = new CR(locationid, floor, gender, availableFacilities).toMap();

    // bodyEncoded: converts the newCR into a JSON encoded map.
    var bodyEncoded = convert.json.encode(newCR);

    // response: response of the POST request
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: bodyEncoded,
    );
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  // build: builds the screen.
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

  // _genderString: Widget that returns gender text depending on the gender passed.
  //   gender: string that will be used to check what the gender is.
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

  //  _listOfFacilities: Widget that shows the list of Facilities for the checkbox list.
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

  // _buildRow: Widget that is in charge of building every specific row for the facility list.
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
