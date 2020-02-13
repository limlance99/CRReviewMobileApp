import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../utility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../forms/add_review.dart';

class ViewCR extends StatefulWidget {
  ViewCR({Key key, this.title, this.cr}) : super(key: key);

  final String title;
  final Map cr;

  @override
  _ViewCRState createState() => _ViewCRState();
}

class _ViewCRState extends State<ViewCR> {
  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  // List reviews = cr["reviews"];
  List reviews = [];
  num aveRating1 = 0.0;
  num aveRating2 = 0.0;
  num aveRating3 = 0.0;

  Future<void> _getJSONData() async {
    var url = "https://crreviewapi.herokuapp.com/api/reviews/${widget.cr["id"]}";
    var response = await http.get(url);

    reviews = [];
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
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
    for (int i = 0; i < 5; i++) {
      var temp = new Map<String, dynamic>();
      temp["rating1"] = 3.0;
      temp["rating2"] = 3.0;
      temp["rating3"] = 3.0;
      temp["reviewtext"] = "THIS IS AN AMAZIN CR Lorem Ipsum my dude ${i+1}";
      reviews.add(temp);
    }
  }

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

  @override
  void initState() {
    super.initState();

    _getJSONData();
    _getAverageRatings();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
              // Add review here
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

  Widget _loadReviews() {
    return SmartRefresher(
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildListView(reviews),

    );
  }

  void _onLoading() async {
    setState(() {
        _getJSONData();
        _getAverageRatings();
      }
    );
    _refreshController.loadComplete();
  }

  void _onRefresh() {
    setState(() {
        _getAverageRatings();
      }
    );
    _refreshController.refreshCompleted();
  }

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
                    Text(
                      "Rating 1",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveRating1,
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
                    Text(
                      "Rating 2",
                      style: Theme.of(context).textTheme.headline,
                    ),

                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveRating2,
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
                    Text(
                      "Rating 3",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RatingBar(
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      initialRating: aveRating3,
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
                  Text(
                    "Rating 1",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["rating1"],
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
                  Text(
                    "Ratings 2",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["rating2"],
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
                  Text(
                    "Rating 3",
                  ),
                  RatingBar(
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    initialRating: reviews[i]["rating3"],
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
