/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Feb 13, 2020: JV Afable - Initialized file. 
*/

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../utility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../forms/add_review.dart';

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

// _refreshController: controller for everything related to the pull-to-refresh widget
  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  // List reviews = cr["reviews"];

  // reviews: list that will contain the reviews retrieved from the backend
  List reviews = [];

  List facilities = [];

  // aveRating1: number variable that will contain the average rating for rating1 
  num aveRating1 = 0.0;

  // aveRating2: number variable that will contain the average rating for rating2 
  num aveRating2 = 0.0;

  // aveRating3: number variable that will contain the average rating for rating3 
  num aveRating3 = 0.0;

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
    var response = await http.get(url);

    reviews = [];
    if (response.statusCode == 200) {

      // jsonResponse: response body decoded from json
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      if (mounted)
        setState(() {
          if (jsonResponse["reviews"] != null) {
            reviews = jsonResponse["reviews"];
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
  void _getAverageRatings() {
    aveRating1 = 0;
    aveRating2 = 0;
    aveRating3 = 0;

    for (int i = 0; i < reviews.length; i++) {
      aveRating1 += reviews[i]["rating1"];
      aveRating2 += reviews[i]["rating2"];
      aveRating3 += reviews[i]["rating3"];
    }

    aveRating1 = aveRating1 / reviews.length;
    aveRating2 = aveRating2 / reviews.length;
    aveRating3 = aveRating3 / reviews.length;

    if (reviews.length == 0) {
      aveRating1 = 5.0;
      aveRating2 = 5.0;
      aveRating3 = 5.0;
    }
  }

  // initState: Logic to be done before CRList build is called.
  @override
  void initState() {
    super.initState();

    _getJSONData();
    _getCRFacilities();
    _getAverageRatings();
  }

  // build: builds the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReview(crid: widget.cr["id"]),
                )
              );
            },
            tooltip: "Add Review",
          ),
        ],
      ),
      body: _loadReviews(),
    );
  }

  // _loadReviews: Widget that deals with the presentation of the reviews
  Widget _loadReviews() {
    return SmartRefresher(
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildListView(reviews),

    );
  }

  // _onLoading: what to do when the reviews get loaded
  void _onLoading() async {
    setState(() {
        _getCRFacilities();
        _getJSONData();
        _getAverageRatings();
      }
    );
    _refreshController.loadComplete();
  }

  // _onRefresh: what to do when then the widget refreshes.
  void _onRefresh() {
    setState(() {
        _getCRFacilities();
        _getJSONData();
        _getAverageRatings();
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
          onPressed: () {
            /*...*/
          },
          child: Text(
            "EDIT",
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
  // reviews: list that should contain the reviews to display
  Widget _buildListView(reviews) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: 4,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.all(6),
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
                  // Display rating bar of the average of Rating 1
                    Text(
                      "Rating 1",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveRating1.toDouble(),
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      onRatingUpdate: (rating){},
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),

                  // Display rating bar of the average of Rating 2
                    Text(
                      "Rating 2",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveRating2.toDouble(),
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),

                  // Display rating bar of the average of Rating 3
                    Text(
                      "Rating 3",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveRating3.toDouble(),
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
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
        if (i == 1) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.all(6),
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
        if (i == 2) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(6),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget> [
                Padding(
                  padding: EdgeInsets.all(6.0),
                ),
                Text(
                  "REVIEWS",
                  style: Theme.of(context).textTheme.headline,
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

                // Display rating bar for Rating 1 of current review
                  Text(
                    "Rating 1",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["rating1"].toDouble(),
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                    ),
                    itemSize: 20.0,
                    onRatingUpdate: (rating) {},
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),

                // Display rating bar for Rating 2 of current review
                  Text(
                    "Rating 2",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["rating2"].toDouble(),
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                    ),
                    itemSize: 20.0,
                    onRatingUpdate: (rating) {},
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                
                // Display rating bar for Rating 3 of current review
                  Text(
                    "Rating 3",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["rating3"].toDouble(),
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
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
