/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Jan 20, 2020: Lance Lim - Initialized file.
  Jan 23, 2020: Lance Lim - Linked the add_cr.dart to the page.
*/


import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../forms/add_cr.dart';
import './view_cr.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utility.dart';

// CRList: Stateful Widget that will contain all the logic and UI for the CR List screen.
class CRList extends StatefulWidget{

  final ScrollController scrollControl;

  CRList({
    Key key,
    @required this.scrollControl,
  }) : super(key: key);

  // title: Title of the screen.

  @override
  _CRListState createState() => _CRListState();
}

class _CRListState extends State<CRList> with AutomaticKeepAliveClientMixin {
  
  // _refreshController: controller for everything related to the pull-to-refresh widget
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _scrollControl;

  // data: list that will contain the CRs retrieved from the backend.
  List data = [];
  List locations = [];


  // build: builds the screen.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _refreshableList(data),
      backgroundColor: Colors.green[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCR(),
            ),
          );
          if (result) {
            getJSONData();
          }

        },
        child: Icon(Icons.add),
      ),
    );

  }

  // _refreshableList: Widget that deals with the pull-to-refresh UI. 
  //   data: list that should contain the data to display.
  Widget _refreshableList(data) => SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: _buildListView(data),
  );

  // _onRefresh: what to do when then the widget refreshes.
  void _onRefresh() async {
    setState(() {
      getJSONData();
      getLocations();
    });
    
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // _buildListView: Widget that deals with the presenting of the List itself.
  //   data: list that should contain all the data to display. 
  Widget _buildListView(data) => ListView.builder(
    padding: EdgeInsets.all(16.0),
    controller: _scrollControl,
    itemCount: locations.length,
    itemBuilder: (context, index) {
      return _buildImageColumn(locations[index]);
    },
  );
  
  // _buildImageColumn: Widget that deals with building each specific row of the list.
  //   item: the data to display for one specific column.
  Widget _buildImageColumn(item) {
    List crs = [];
    for (var cr in data) {
      if (cr["location"]["address"] == item["address"]) {
        crs.add(cr);
      }
    }

    return Container(

      /*decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),*/

      margin: EdgeInsets.all(3),
      child: Column(
        children: <Widget>[
          Card(child: ExpansionTile(
            title: Text(
              item["address"].toString(),
              style: TextStyle(
                  fontSize: 20.0
              ),
            ),
            children: _expandLocation(crs),
          )),
        ],
      ),
    );
  }

  List<Widget> _expandLocation(crs) {
    List<Widget> ret = [];
    ret.add(
        Container(
          color: Color(0xFFEAEAEA),
          height: 1.5,
        )
    );
    if (crs.length == 0) {
      ret.add(
        ListTile(
          title: Text(
            'No available CRs.',
            style: TextStyle(
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          )
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

    // initState: Logic to be done before CRList build is called.
    @override
    void initState() {
      super.initState();
      // call get json data function
      this.getJSONData();
      this.getLocations();
      _scrollControl = widget.scrollControl;
    }

    // getJSONData: HTTP GET request to get the list of CRs from the database.
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

    @override
    bool get wantKeepAlive => true;
  }
