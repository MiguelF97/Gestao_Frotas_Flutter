import 'package:flutter/material.dart';
import "dart:async";
import "./firstpage.dart" as firstpage;
import "./secondpage.dart" as secondpage; 
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LPI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TESTE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
   with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState(){
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }
  
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("TesteLpi"),
        backgroundColor: Colors.red,
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
             new Tab(icon: new Icon(Icons.wifi)),
             new Tab(icon: new Icon(Icons.access_time)),  
          ],
        ),  
      ),
      body: new TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
                    new secondpage.ListPage(),
          new firstpage.FirstPage(),


        ],
      )
    );
  }
}


Future<bool> deleteDialog(BuildContext context) {
return showDialog(
  context: context,
  builder: (BuildContext context) {
    return new  AlertDialog(
      title: new Text("Are you sure?"),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Yes"),
          onPressed: (){
            Navigator.of(context).pop(true);
          },
        ),
        new FlatButton(
          child: new Text("No"),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
);
}


Future<bool> randomDialog(BuildContext context,String nome) {
return showDialog(
  context: context,
  builder: (BuildContext context) {
    return new  AlertDialog(
      title: new Text(nome),
    );
  }
);
}

Position getLocation(){   

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 0, timeInterval: 3); 

    geolocator.getPositionStream(locationOptions).listen(
    (result) {
        print(result == null ? 'Unknown' : result.latitude.toString() + ', ' + result.longitude.toString());
          return result;
        });
  return null;
}



