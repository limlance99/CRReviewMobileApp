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
import 'location.dart';

class CRMap extends StatefulWidget {
  CRMap({
    Key key
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
  var mapControl = MapController();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  Widget locationToload;

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
    this.getLocations();
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
        point: LatLng(14.654918, 121.064688),
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
              Anchor(25, 0)
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
                  locationToload = Location(location: location,);
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
          //_getLocation();
          getMarkers();
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
        if (firstload) {
          mapControl.move(
              LatLng(currPos.latitude, currPos.longitude),
              18
          );
          firstload = false;
        }
        getMarkers();
      });
    });
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
                  locationToload = null;
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
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 500),
            height: _show ? 200.0 : 0.0,
            child: Container(
              child: locationToload,
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
              margin: EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
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