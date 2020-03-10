/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
  Feb 13, 2020: JP Chanchico - Initialized File
*/


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/Review.dart';

// AddReview: Stateful Widget that will contain the states for the Add Review form.
class AddReview extends StatefulWidget {
  final int crid;

  AddReview({
    Key key,
    @required this.crid,
  }) : super(key : key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

// _AddReviewState: State that will provide all the logic and UI for the Add Review form. 
class _AddReviewState extends State<AddReview> {

  // crid: will contain the ID of the CR being reviewed
  int crid = 0;

  // rating1: will contain the value of the first rating of the review
  double rating1 = 0;

  // rating2: will contain the value of the second rating of the review
  double rating2 = 0;
  
  // rating3: will contain the value of the third rating of the review
  double rating3 = 0;

  // reviewText: will contain the inputted text of the review
  String reviewText = "";

  // _reviewTextController: controller that is in charge of everything related to the review input text.
  final TextEditingController _reviewTextController =
      new TextEditingController();

  // initState: Logic to be done before Add Review build is called.
  @override
  void initState() {
    super.initState();
    crid = widget.crid;
  }

  // _addNewReview: HTTP POST request to add a new Review into the database.
  Future<void> _addNewReview() async {
    reviewText = _reviewTextController.text;

    print(rating1);
    print(rating2);
    print(rating3);
    print("'" + reviewText + "'");

    if (rating1 == 0 || rating2 == 0 || rating3 == 0) {
      print("Missing Ratings");
      return;
    }
    // Save review to database using API

    // url: the address that will be used to get the data.
    var url = 'https://crreviewapi.herokuapp.com/api/reviews';

    // newReview: A new Review class instantiated with all of the values, then turning it into a map (key:value).
    var newReview = new Review(crid, reviewText, rating1, rating2, rating3).toMap();

    // bodyEncoded: converts the newCR into a JSON encoded map.
    var bodyEncoded = convert.json.encode(newReview);

    // response: response of the POST request
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: bodyEncoded,
    );
    if (response.statusCode == 200) {
      print("Successfully Added!");
      Navigator.pop(context, true);
    } else {
      print("Error Adding Review :((");
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
        title: Text("Add Review"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewReview,
          ),
        ],
      ),
      backgroundColor: Colors.green[50],
      body: Container(
        child: ListView(
          children: <Widget>[
            // Padding(padding: EdgeInsets.all(15)),
            Center(
              child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(16.0),
                      width: 500.0,
                      child: Column(
                        children: <Widget>[
                        // Display rating bar for Rating 1
                          Text(
                            "Rating 1",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          Divider(),
                          RatingBar(
                            direction: Axis.horizontal,
                            initialRating: 0,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.cyan,
                            ),
                            onRatingUpdate: (rating) {
                              rating1 = rating;
                            },
                          ),
                          Divider(
                            indent: 50.0,
                            endIndent: 50.0,
                          ),
                          Padding(padding: EdgeInsets.all(15)),

                        // Display rating bar for Rating 2
                          Text(
                            "Rating 2",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          Divider(),
                          RatingBar(
                            direction: Axis.horizontal,
                            initialRating: 0,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.cyan,
                            ),
                            onRatingUpdate: (rating){
                              rating2 = rating;
                            },
                          ),
                          Divider(
                            indent: 50.0,
                            endIndent: 50.0,
                          ),
                          Padding(padding: EdgeInsets.all(15)),

                        // Display rating bar for Rating 3
                          Text(
                            "Rating 3",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          Divider(),
                          RatingBar(
                            direction: Axis.horizontal,
                            initialRating: 0,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.cyan,
                            ),
                            onRatingUpdate: (rating){
                              rating3 = rating;
                            },
                          ),
                          Divider(
                            indent: 50.0,
                            endIndent: 50.0,
                          )
                        ]
                      )
                    ),
                    
                    // Display text field to input review text
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Comments",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          Divider(
                            thickness: 3.0,
                          ), 
                          Container(
                            margin: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextField(
                              controller: _reviewTextController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Your thoughts on the CR...",
                              ),
                            )
                          ),
                        ],
                      )
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

}
