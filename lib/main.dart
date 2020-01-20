import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CR Review',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'CR Review'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _buildListView(data),
      backgroundColor: Colors.green[50],
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
          title: Text(item["Address"].toString()), 
          subtitle: Text(item["LocationID"].toString())),
      ],
    ),
  );

  @override 
  void initState() {
    super.initState();
    // call get json data function
    this.getJSONData();
  }

  Future<String>getJSONData() async {
    var url = 'https://crreviewapi.herokuapp.com/get/locations';
    var response  = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        data = jsonResponse;
      });
      return "successful";
    } else {
      print("Request failed with status: ${response.statusCode}");
      return "fail";
    }
  }
}
