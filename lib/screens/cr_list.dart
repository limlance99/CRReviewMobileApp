import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../forms/add_cr.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CRList extends StatefulWidget {
  CRList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CRListState createState() => _CRListState();
}

class _CRListState extends State<CRList> {
  
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List data = [];

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

  Widget _refreshableList(data) => SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: _buildListView(data),
  );

  void _onRefresh() async {
    await getJSONData();
    
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
  void _onLoading() async{
    // monitor network fetch
    await getJSONData();
    print("Im on loading");
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if(mounted)
    setState(() {

    });
    _refreshController.loadComplete();

  }

  Widget _buildListView(data) => ListView.builder(
    padding: EdgeInsets.all(16.0),
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _buildImageColumn(data[index]);
      // 
    },
  );
  
  Widget _buildImageColumn(item) => Container(
    
    decoration: BoxDecoration(
      color: Colors.white,
    ),

    margin: EdgeInsets.all(8),
    child: Column(
      children: <Widget>[
        ListTile(
          title: Text(item["location"]["address"].toString()), 
          subtitle: _floorOfCR(item["floor"]),
          trailing: _genderIcon(item["gender"]),
        ),
      ],
    ),
  );

  @override 
  void initState() {
    super.initState();
    // call get json data function
    this.getJSONData();
  }

  Widget _floorOfCR(floor) {
    String floorString = "";
    int lastDigit = floor % 10;
    if (lastDigit == 1) {
     if (floor < 10) floorString = "${floor}st";
     else floorString = "${floor}th";
    }
    else if (lastDigit == 2) floorString = "${floor}nd";
    else if (lastDigit == 3) floorString = "${floor}rd";
    else floorString = "${floor}th";

    return Text("$floorString Floor");
  }

  Widget _genderIcon(gender) {
    var _gender = gender.toString();
    switch(_gender) {
      case "M":
        // return SvgPicture.asset(
        //   "assets/images/male.svg",
        //   color: Colors.blue,
        // );
        return Icon(
          Icons.person,
          color: Colors.blue,
        );
        break;
      case "F":
        // return SvgPicture.asset(
        //   "assets/images/female.svg",
        //   color: Colors.pink,
        // );
        return Icon(
          Icons.person,
          color: Colors.pink,
        );  
      default:
        return Icon(
          Icons.person,
          color: Colors.grey,
        );
    }
  }

  Future<void> getJSONData() async {
    var url = 'https://crreviewapi.herokuapp.com/api/crs';
    var response  = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        data = jsonResponse;
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    print("Get JSON got called");
  }
}
