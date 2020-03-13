/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Feb 13, 2020: JV Afable - Initialized file. 
  Mar 12, 2020: JV Afable - Improved UI.
*/

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../utility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../forms/add_review.dart';
import '../forms/edit_facilities.dart';
import 'package:flutter_parallax/flutter_parallax.dart';

// ViewCR: Stateful Widget that will contain all the logic and UI for the View CR screen
class ViewCR extends StatefulWidget {
  ViewCR({Key key, this.title, this.cr}) : super(key: key);

  // title: Title of the screen.
  final String title;

  // cr: cr being viewd
  final Map cr;

  @override
  _ViewCRState createState() => _ViewCRState();
}

class _ViewCRState extends State<ViewCR> {
  ScrollController _scrollController;

// _refreshController: controller for everything related to the pull-to-refresh widget
  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  // List reviews = cr["reviews"];

  // reviews: list that will contain the reviews retrieved from the backend
  List reviews = [];

  List facilities = [];

  // aveCleanliness: number variable that will contain the average rating for cleanliness 
  num aveCleanliness = 0.0;

  // aveComfort: number variable that will contain the average rating for comfort 
  num aveComfort = 0.0;

  // aveFacilities: number variable that will contain the average rating for facilities 
  num aveFacilities = 0.0;

  Future<void> _getCRFacilities() async {
    var url = "https://crreviewapi.herokuapp.com/api/facilities/${widget.cr["id"]}";
    var response = await http.get(url);

    facilities = [];

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (mounted)
        setState(() {
          if (jsonResponse.length != 0) {
            facilities = jsonResponse;
          }
        });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    print("Facilities called");
    print(response);
  }

  // getJSONData: HTTP GET request to get the list of reviews from the database.
  Future<void> _getJSONData() async {

    // url: the address that will be used to get the data.
    var url = "https://crreviewapi.herokuapp.com/api/reviews/${widget.cr["id"]}";

    // response: response of the GET request
    var response = await http.get(url).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          showOKBox('Request timed out.', 'Check your internet connection.', context, Icons.timer_off, null);
          print('timeout');
          return;
        }
    );

    reviews = [];
    if (response.statusCode == 200) {

      // jsonResponse: response body decoded from json
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      if (mounted)
        setState(() {
          if (jsonResponse["reviews"] != null) {
            reviews = jsonResponse["reviews"];
            _getAverageRatings();
          }
        });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }

    print("Get JSON got called");

    // For debugging purposes
    // for (int i = 0; i < 5; i++) {
    //   var temp = new Map<String, dynamic>();
    //   temp["rating1"] = 3.0;
    //   temp["rating2"] = 3.0;
    //   temp["rating3"] = 3.0;
    //   temp["reviewtext"] = "THIS IS AN AMAZIN CR Lorem Ipsum my dude ${i+1}";
    //   reviews.add(temp);
    // }
  }

  // _getAverageRatings: function to get the average for each of the 3 ratings
  void _getAverageRatings() async {
    aveCleanliness = 0;
    aveComfort = 0;
    aveFacilities = 0;

    for (int i = 0; i < reviews.length; i++) {
      aveCleanliness += reviews[i]["cleanliness"];
      aveComfort += reviews[i]["comfort"];
      aveFacilities += reviews[i]["facilities"];
    }

    aveCleanliness = aveCleanliness / reviews.length;
    aveComfort = aveComfort / reviews.length;
    aveFacilities = aveFacilities / reviews.length;

    if (reviews.length == 0) {
      aveCleanliness = 5.0;
      aveComfort = 5.0;
      aveFacilities = 5.0;
    }
  }

  // initState: Logic to be done before CRList build is called.
  @override
  void initState() {
    super.initState();
    _getJSONData();
    _getCRFacilities();
    _scrollController = ScrollController();
    print("This is the scroll_controller");
    print(_scrollController);
  }

  // Navigates to the Add Review form
  void gotoAddReview() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReview(crid: widget.cr["id"]),
      )
    );
    if (result) {
      _getCRFacilities();
      _getJSONData();
    }
  }
  // build: builds the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
      ),
      body: Stack(children: <Widget> [
          Parallax.outside(
            controller: _scrollController,
            child: Column(
              children: <Widget> [
                Image.asset("assets/images/cr_placeholder.png"),
                Container(
                  color: Colors.green[50],
                  height: 200.0
                ),
                Container(
                  color: Colors.green[51],
                  height: 200.0
                ),
                Container(
                  color: Colors.green[52],
                  height: 200.0
                ),
                Container(
                  color: Colors.green[53],
                  height: 200.0
                ),
                Container(
                  color: Colors.green[54],
                  height: 200.0
                ),
                Container(
                  color: Colors.green[55],
                  height: 200.0
                ),
                // Container(
                //   color: Colors.green[56],
                //   height: 200.0
                // ),
                // Container(
                //   color: Colors.green[57],
                //   height: 200.0
                // ),
                // Container(
                //   color: Colors.green[58],
                //   height: 200.0
                // ),
                // Container(
                //   color: Colors.green[59],
                //   height: 200.0
                // ),
                // Container(
                //   color: Colors.green[60],
                //   height: 200.0
                // ),

              ]
            ),
          ),
          // Positioned.fill(child: Image.asset(".../assets/images/cr_placeholder.jpg")),
          
          _loadReviews(),
        ]
      ), 
      // body: _loadReviews(),     
    );
  }

  // _loadReviews: Widget that deals with the presentation of the reviews
  Widget _loadReviews() {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildListView(reviews),
      header: WaterDropHeader(),
    );
  }

  // _onLoading: what to do when the reviews get loaded
  void _onLoading() async {
    setState(() {
        _getCRFacilities();
        _getJSONData();
      }
    );
    _refreshController.loadComplete();
  }

  // _onRefresh: what to do when then the widget refreshes.
  void _onRefresh() {
    setState(() {
        _getCRFacilities();
        _getJSONData();
      }
    );
    _refreshController.refreshCompleted();
  }

  List<Widget> _buildFacilityIcons(facilities) {
    List<Widget> ret = [];

    if (facilities.length == 0) {
      ret.add(
        Text(
          "No facilities available",
          style: TextStyle(
            color: Colors.black54
          ),
        )
      );
    }

    for (int i = 0; i < facilities.length; i++) {
      ret.add(
        facilityIcon(facilities[i]["fid"])
      );
    }
    return ret;
  }

  Widget _buildFacilities(facilities) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildFacilityIcons(facilities),
        ),
        FlatButton(
          onPressed: () async {
            bool result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditFacilities(facilitiesCR: facilities, crid: widget.cr["id"]),
                ),
            );
            if (result) {
              _getCRFacilities();
              _getJSONData();
            }
          },
          child: Icon(
            Icons.edit,
            color: Colors.black,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Color(0xff333333)
            ),
          ),
        )
      ]
    );
  }

  // _buildListView: deals with the list formatting of the screen
  // reviews: list that should contain the kjbDFSLKJfsdLKhcasklcmhbreviews to display
  Widget _buildListView(reviews) {
    return ListView.builder(
      // padding: EdgeInsets.all(16.0),
      controller: _scrollController,
      itemCount: 4,
      itemBuilder: (context, i) {
        // if (i == 0) {
        //   return Parallax.inside(
        //     child: Image.asset("assets/images/cr_placeholder.png"),
        //     mainAxisExtent: 175.0,
        //   );
        // }
        if (i == 0) {
          return Container(
            height: 200.0,
          );
        }
        if (i == 1) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: Column(
                children: <Widget>[

                  // Display CR Location, Floor, and Gender
                    ListTile(
                      title: Text(widget.cr["location"]["address"], style: Theme.of(context).textTheme.headline,),
                      subtitle: floorOfCR(widget.cr["floor"]),
                      trailing: genderIcon(widget.cr["gender"]),
                    ),
                    Divider(
                      thickness: 3.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),
                  // Display rating bar of the average of Cleanliness
                    Text(
                      "Cleanliness",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveCleanliness.toDouble(),
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.cyan,
                      ),
                      onRatingUpdate: (rating){},
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),

                  // Display rating bar of the average of Comfort
                    Text(
                      "Comfort",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveComfort.toDouble(),
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.cyan,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),

                  // Display rating bar of the average of Facilities
                    Text(
                      "Facilities",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveFacilities.toDouble(),
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.cyan,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),
                  ]
              )
            )
          );
        }
        if (i == 2) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.all(6),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget> [
                  Padding(
                    padding: EdgeInsets.all(6.0),
                  ),
                  Text(
                    "FACILITIES",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                  ),
                  Divider(
                    thickness: 3.0,
                  ),
                  _buildFacilities(facilities),
                ]
            ),
          );
        }

      // Logic for building review list
        if (i == 3) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.symmetric(vertical: 6),
            padding: EdgeInsets.all(6),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget> [
                Padding(
                  padding: EdgeInsets.all(6.0),
                ),
                Row(
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    Text(
                      "REVIEWS",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                    ),
                    FlatButton(
                      color: Colors.green,
                      onPressed: gotoAddReview, 
                      child: Text(
                        "Give a Review",
                        style: TextStyle(color: Colors.white)
                      )
                    ),
                  ]
                ),
                
                
                Padding(
                  padding: EdgeInsets.all(6.0),
                ),
                Divider(
                  thickness: 3.0,
                ),
              ] + _buildReviews(reviews)
            ),
          );


        }

        return Container();
      },
    );
  }

  // _buldReviews: deals with the review formatting on the screen
  // reviews: list that should contain the reviews to display
  List<Widget> _buildReviews(reviews) {
    List<Widget> ret = [];
    if (reviews.length == 0) {
      ret.add(
        Padding(
          padding: EdgeInsets.all(3.0),
        )
      );
      ret.add(
        Center(
          child: Text("No reviews yet, be the first!", style: TextStyle(fontSize: 16.0)),
        )
      );
      ret.add(
        Padding(
          padding: EdgeInsets.all(3.0),
        )
      );
    }

    for (int i = 0; i < reviews.length; i++) {
      ret.add(
        Padding(
          padding: EdgeInsets.all(3.0),
        )
      );
      ret.add(
        Row(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[

                // Display rating bar for Cleanliness of current review
                  Text(
                    "Cleanliness",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["cleanliness"].toDouble(),
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.cyan,
                    ),
                    itemSize: 20.0,
                    onRatingUpdate: (rating) {},
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),

                // Display rating bar for Comfort of current review
                  Text(
                    "Comfort",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["comfort"].toDouble(),
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.cyan,
                    ),
                    itemSize: 20.0,
                    onRatingUpdate: (rating) {},
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                
                // Display rating bar for Facilities of current review
                  Text(
                    "Facilities",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["facilities"].toDouble(),
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.cyan,
                    ),
                    itemSize: 20.0,
                    onRatingUpdate: (rating) {},
                  ),
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),

          // Display review text for current review
            Container(
              alignment: Alignment.centerRight,
              width: 175.0,
              child: Column(
                children: <Widget>[
                  Text(reviews[i]["reviewtext"], textAlign: TextAlign.right,)
                ],
              )
            ),
          ],
        )
      );
      ret.add(
        Padding(
          padding: EdgeInsets.all(3.0),
        )
      );
      ret.add(Divider(
        indent: 40.0,
        endIndent: 40.0,
        thickness: 2.0,
      ));
    }
    return ret;
  }
}
