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


class CRMap extends StatefulWidget {
  CRMap({
    Key key
  }) : super(key: key);

  @override
  _CRMapState createState() => _CRMapState();
}

class _CRMapState extends State<CRMap> {
  String title = "";

  var geolocator = Geolocator();
  var mapControl = MapController();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  bool firstload = true;

  Position currPos = Position(
    latitude: 14.654918,
    longitude: 121.064688,
  );


  StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    this._getLocation();
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
      });
    });
  }

  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          center: LatLng(currPos.latitude, currPos.longitude),
          zoom: 18,
          maxZoom: 19,
          minZoom: 15,
          onTap: (value) => (print(value))
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
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
            Marker(
              anchorPos: AnchorPos.exactly(
                  Anchor(25, 0)
              ),
              point: LatLng(14.653538, 121.069832),
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
          ],
        ),
      ],
      mapController: mapControl,
    );
  }
  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
}