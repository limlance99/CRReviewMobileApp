import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AddReview extends StatefulWidget {
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  
  double rating1 = 0;
  double rating2 = 0;
  double rating3 = 0;
  String reviewText = "";
  final TextEditingController _reviewTextController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  void _addNewReview() {
    // [STUB] SOMEONE PLEASE FINISH THIS
    reviewText = _reviewTextController.text;
    print(rating1);
    print(rating2);
    print(rating3);
    print("'" + reviewText + "'");

    if (rating1 == 0 || rating2 == 0 || rating3 == 0) {
      // If missing a rating, do nothing
      return;
    }

    // Save review to database using API



    // Return to previous screen
    Navigator.pop(context, true);
  }

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
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(15)),
            Center(
              child: Column(
                  children: <Widget>[
                    Text(
                      "Rating 1", 
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      initialRating: 0,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        rating1 = rating;
                      },
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      "Rating 2", 
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      initialRating: 0,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      onRatingUpdate: (rating){
                        rating2 = rating;
                      },
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      "Rating 3", 
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      initialRating: 0,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      onRatingUpdate: (rating){
                        rating3 = rating;
                      },
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      "Comments", 
                      style: Theme.of(context).textTheme.headline,
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

                    Padding(
                      padding: EdgeInsets.all(20),
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
