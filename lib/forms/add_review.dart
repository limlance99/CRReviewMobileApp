import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/Review.dart';

class AddReview extends StatefulWidget {
  final int crid;

  AddReview({
    Key key,
    @required this.crid,
  }) : super(key : key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  int crid = -1;
  double rating1 = 0;
  double rating2 = 0;
  double rating3 = 0;
  String reviewText = "";
  final TextEditingController _reviewTextController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    crid = widget.crid;
  }


  Future<void> _addNewReview() async {
    // [STUB] SOMEONE PLEASE FINISH THIS
    reviewText = _reviewTextController.text;
    print(rating1);
    print(rating2);
    print(rating3);
    print("'" + reviewText + "'");

    if (rating1 + rating2 + rating3 < 3) {
      print("Missing Ratings");
      return;
    }
    // Save review to database using API

    var url = 'https://crreviewapi.herokuapp.com/api/reviews';

    var newReview = new Review(crid, reviewText, rating1, rating2, rating3).toMap();

    var bodyEncoded = convert.json.encode(newReview);
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
                      allowHalfRating: false,
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
                      allowHalfRating: false,
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
                      allowHalfRating: false,
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
