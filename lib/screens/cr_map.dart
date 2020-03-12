/*
Authors: JV Afable, JP Chanchico, Lance Lim
This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.
Code History:
	Mar 10, 2020: JP Chanchico - Initialized file.
*/

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../utility.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'view_cr.dart';

class CRMap extends StatefulWidget {
  final mapControl;
  final Function func;
  CRMap({
    Key key,
    this.func,
    @required this.mapControl,
  }) : super(key: key);

  @override
  _CRMapState createState() => _CRMapState();
}

class _CRMapState extends State<CRMap> with AutomaticKeepAliveClientMixin {
  String title = "";

  List<Marker> markers = [];
  List locations = [];
  bool _show = false;

  var geolocator = Geolocator();
  var mapControl;
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  List data = [];

  var currMarker;

  bool firstload = true;

  Position currPos = Position(
    latitude: 14.654918,
    longitude: 121.064688,
  );


  StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    mapControl = widget.mapControl;
    this.getLocations();
    this.getJSONData();
  }

  void getMarkers() {
    print('getting markers');
    markers.add(
      Marker(
        anchorPos: AnchorPos.exactly(
            Anchor(25, 0)
        ),
        width: 50,
        height: 50,
        point: LatLng(currPos.latitude, currPos.longitude),
        builder: (ctx) =>
            Container(
              key: Key('blue'),
              child: Icon(
                Icons.location_on,
                color: MaterialColor(0xFF0F4C81, colorSwatch()),
                size: 50.0,
              ),
            ),
      ),
    );
    print(locations);
    for (var location in locations) {
      markers.add(
        Marker(
          anchorPos: AnchorPos.exactly(
              Anchor(25, 5)
          ),
          width: 50,
          height: 50,
          point: LatLng(location["latitude"], location["longitude"]),
          builder: (ctx) => Container(
            key: Key('blue'),
            child: IconButton(
              icon: Icon(
                Icons.location_on,
                color: MaterialColor(0xFF0F4C81, colorSwatch()),
                size: 50.0,
              ),
              onPressed: () {
                setState(() {
                  currMarker = location;
                  _show = true;
                });
              },
            ),
          ),
        ),
      );
    }
    print(markers.length);
  }

  Future<void> getLocations() async {

    // url: the address that will be used to get the data.
    var url = 'https://crreviewapi.herokuapp.com/api/locations';

    // response: response of the GET request
    var response = await http.get(url).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          showOKBox('Request timed out.', 'Check your internet connection.', context, Icons.timer_off, null);
          print('timeout');
          return;
        }
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (mounted)
        setState(() {
          locations = jsonResponse;
          _getLocation();
        });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }

  void _getLocation() {
    positionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      print(position);
      setState(() {
        currPos = position;
        widget.func(currPos);
        if (firstload) {
          mapControl.move(
              LatLng(currPos.latitude, currPos.longitude),
              //LatLng(14.654918, 121.064688),
              18.0
          );
          getMarkers();
          firstload = false;
        }
        markers[0] = Marker(
          anchorPos: AnchorPos.exactly(
              Anchor(25, 5)
          ),
          width: 50,
          height: 50,
          point: LatLng(currPos.latitude, currPos.longitude),
          builder: (ctx) =>
              Container(
                key: Key('blue'),
                child: Icon(
                  Icons.location_on,
                  color: MaterialColor(0xFF0F4C81, colorSwatch()),
                  size: 50.0,
                ),
              ),
        );
      });
    });
  }

  Widget buildLocation(location) {
    List crs = [];
    for (var cr in data) {
      if (cr["location"]["address"] == location["address"]) {
        crs.add(cr);
      }
    }


    return ListView(
      children: <Widget>[
        Column(
          children: buildCRList(crs),
        ),
      ],
    );
  }

  List<Widget> buildCRList(crs) {
    List<Widget> ret = [];
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
    super.build(context);
    return Stack(
      children: <Widget>[
        FlutterMap(
          options: MapOptions(
              center: LatLng(currPos.latitude, currPos.longitude),
              zoom: 18,
              maxZoom: 19,
              minZoom: 15,
              onTap: (value) {
                print(value);
                setState(() {
                  _show = false;
                });
              },
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: markers,
            ),
          ],
          mapController: mapControl,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
            height: _show ? 200.0 : 0.0,
            child: Container(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: currMarker == null ? Text("") : Text(
                    currMarker["address"],
                    style: TextStyle(
                      color: MaterialColor(0xFF0F4C81, colorSwatch()),
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  leading: Icon(
                    Icons.pin_drop,
                    size: 35,
                    color: MaterialColor(0xFF0F4C81, colorSwatch()),
                  ),
                ),
                body: currMarker == null ? null : buildLocation(currMarker),
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20.0, // has the effect of softening the shadow
                    spreadRadius: 5.0, // has the effect of extending the shadow
                    offset: Offset(
                      10.0, // horizontal, move right 10
                      10.0, // vertical, move down 10
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(6),
            ),
          ),
        ),
      ],
    );
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

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    print('*disposed');
    positionStream?.cancel();
    super.dispose();
  }
}