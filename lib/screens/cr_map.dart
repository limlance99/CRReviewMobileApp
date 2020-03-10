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

  Future<void> _getPosition() async {
    Position temp = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    setState(() {
      currPos = temp;
    });
  }

  void _getLocation() {
    positionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      print(position);
      setState(() {
        currPos = position;
        mapControl.move(
            LatLng(currPos.latitude, currPos.longitude),
            17.5
        );
      });
    });
  }

  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          center: LatLng(currPos.latitude, currPos.longitude),
          zoom: 17.5,
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
              width: 50,
              height: 50,
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