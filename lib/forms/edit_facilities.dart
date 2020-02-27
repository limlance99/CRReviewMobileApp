import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


class EditFacilities extends StatefulWidget {
  final List facilitiesCR;

  EditFacilities({
    Key key,
    @required this.facilitiesCR,
  }) : super(key : key);

  @override
  _EditFacilitiesState createState() => _EditFacilitiesState();
}

class _EditFacilitiesState extends State<EditFacilities> {
  List facilities = [];

  List facilitiesCR = [];

  List<bool> facilityBoxes = [];

  @override
  void initState() {
    super.initState();
    facilitiesCR = widget.facilitiesCR;

    _getFacilities();
  }

  Future<void> _getFacilities() async {

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
          for (int i = 0; (i < facilitiesCR.length && i < facilityBoxes.length); i++) {
            facilityBoxes[facilitiesCR[i]["fid"]] = true;
          }
        });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }

  void _updateFacilityBoxes() {
    for (int i = 0; (i < facilitiesCR.length && i < facilityBoxes.length); i++) {
      facilityBoxes[facilitiesCR[i]["fid"]] = true;
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text("Edit Facilities"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => {},
          ),
        ],
      ),
      backgroundColor: Colors.green[50],
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: _listOfFacilities(),
        ),
      ),
    );
  }
  Widget _listOfFacilities() {
    List<Widget> facilitycheckboxes = [];

    if (facilities.isEmpty) {
      facilitycheckboxes.add(Text("Loading", style: TextStyle(color: Colors.black54,),));
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