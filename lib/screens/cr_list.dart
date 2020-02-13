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
class CRList extends StatefulWidget {
  CRList({Key key, this.title}) : super(key: key);

  // title: Title of the screen.
  final String title;

  @override
  _CRListState createState() => _CRListState();
}

class _CRListState extends State<CRList> {
  
  // _refreshController: controller for everything related to the pull-to-refresh widget
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // data: list that will contain the CRs retrieved from the backend.
  List data = [];

  // build: builds the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text("Locations"),
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Map",)
          ),
        ],
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
    await getJSONData();
    
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // _buildListView: Widget that deals with the presenting of the List itself.
  //   data: list that should contain all the data to display. 
  Widget _buildListView(data) => ListView.builder(
    padding: EdgeInsets.all(16.0),
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _buildImageColumn(data[index]);
    },
  );
  
  // _buildImageColumn: Widget that deals with building each specific row of the list.
  //   item: the data to display for one specific column.
  Widget _buildImageColumn(item) => Container(
    
    decoration: BoxDecoration(
      color: Colors.white,
    ),

    margin: EdgeInsets.all(8),
    child: Column(
      children: <Widget>[
        ListTile(
          title: Text(item["location"]["address"].toString()), 
          subtitle: floorOfCR(item["floor"]),
          trailing: genderIcon(item["gender"]),
          onTap: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewCR(title: "View CR", cr: item), 
              )
            );
            if (result) {
              getJSONData();
            }
          }
        ),
      ],
    ),
  );

  // initState: Logic to be done before CRList build is called.
  @override 
  void initState() {
    super.initState();
    // call get json data function
    this.getJSONData();
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
      setState(() {
        data = jsonResponse;
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    print("Get JSON got called");
  }

}