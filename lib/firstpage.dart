import 'dart:async';

import 'package:flutter/material.dart';
import "package:testelpi/main.dart" as main;
import "package:flutter/services.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';


class FirstPage extends StatefulWidget {

    FirstPage() : super();
    

    @override
  _FirstPage createState() => _FirstPage();

}

class _FirstPage extends State<FirstPage> {
   GoogleMapController mapController;
   Location location = new Location();

   Firestore firestore = Firestore.instance;
   Geoflutterfire geo = Geoflutterfire();

   BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100.0);
   Stream<dynamic> query;

   StreamSubscription subscription;

/*  final StreamController<Position> _streamController = StreamController<Position>();

  @override
  void dispose(){ 
    _streamController.close();
    super.dispose();
}

Position position;

 Future<Position> locateUser() async  {
  
   position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   _streamController.add(position);
   print(position.toString());
   return position; 
}

  // const oneSec = const Duration(seconds:5);
 //new Timer.periodic(oneSec, (Timer t) => locateUser();
*/
  @override
  Widget build(BuildContext context) {

     

    return Stack(children: [
        
           GoogleMap(
             initialCameraPosition: CameraPosition(
               
              target: LatLng(41.136133, -8.618323),
              zoom:10
             ),
             onMapCreated: _onMapCreated, 
             myLocationEnabled: true,
             mapType: MapType.hybrid,
             trackCameraPosition: true,
           ),
          Positioned(
            bottom: 50,
            right: 10,
            child: 
            FlatButton(child: Icon(Icons.pin_drop,color: Colors.white),
            color: Colors.green,
            onPressed: _addGeoPoint,
            
            ),
          ),  
          Positioned(
            bottom: 50,
            left: 10,
            child: Slider(
              min: 100.0,
              max: 500.0,
              divisions: 4,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.green,
              inactiveColor: Colors.green.withOpacity(0.2),
              onChanged: _updateQuery,
            ),
          )
    ]);


       // new Text(main.getLocation().latitude.toString()),

     /*   child: StreamBuilder<Position>(
        stream: _streamController.stream,
        initialData: position,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot){
            locateUser();
            if(snapshot.data.toString()==null)
            {
              return Text("Loading...");
            }
            else
            return Text(snapshot.data.toString());
          }
          
            ),*/
   
   
   
   
   
   //    child:  main.getLocation().latitude==null ? Container() : new Text("${main.getLocation().latitude.toString()}")
        
  }


  _updateMarkers(List<DocumentSnapshot> documentList)
  {
    print("TESTE");
    print(documentList);
    mapController.clearMarkers();
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['coordenadas']['geopoint'];
      double distance = document.data['distance'];
      var marker = MarkerOptions(
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindowText: InfoWindowText('Magic Marker', '$distance kilometers from query center')
      );
      mapController.addMarker(marker);
    });
  }

 

  _onMapCreated(GoogleMapController controller){
    _startQuery();
    setState((){
      mapController = controller; 
    });
  }

  _addMarker(){
    var marker = MarkerOptions(
      position: mapController.cameraPosition.target,
      icon: BitmapDescriptor.defaultMarker,
      infoWindowText: InfoWindowText('Isabel Maia','PUNTS PEIM '),
    );
    mapController.addMarker(marker);
  }    

  _animateToUser() async {
    var position= await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 17.0,
      )
    )
    );
  }

   _addGeoPoint() async {
    
    print("ENTROU");
   // var pos = await location.getLocation();
 //   GeoFirePoint point =  geo.point(latitude: pos.latitude, longitude: pos.longitude);

/*  DocumentReference documentReference= Firestore.instance.collection("users").document("test@gmail.com");
          documentReference.get().then((datasnapshot){
            if(datasnapshot.exists){
              print(datasnapshot.data['teste'].toString());
            }
            else
            {
              print("No Such User");
            }
          });
    
*/





  //  doc.documents[0].data.update('coordenadas''geopoint', );

   // Firestore.instance.collection('users')
    //  .document(doc.documents[0].data.toString()
          


    /*if(doc.documents[0].exists)
    {
      print(doc.documents[0]['name']);
      print(id);
    }
    else
    {
      print('Nao encontrado');
    }

    });
*/
    

    
    print("asdasd");
    location.onLocationChanged().listen((LocationData currentLocation){
      print("asdasd2");
      print(currentLocation.latitude);
      print(currentLocation.longitude);
        
    Firestore.instance.collection('users')
    .where('name', isEqualTo: 'Isabel')
    .getDocuments()
    .then((doc){
        print("\n"+doc.documents[0].documentID);
        GeoFirePoint point = geo.point(latitude: currentLocation.latitude, longitude: currentLocation.longitude);    
       // print(id+docref.toString());
        Firestore.instance.collection('users').document(doc.documents[0].documentID)
          .updateData({
            'coordenadas' : point.data,  
          });

        });
    

    });





  }

  _startQuery() async{
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    var ref = firestore.collection('users');
    GeoFirePoint  center = geo.point(latitude: lat, longitude: lng);

    subscription= radius.switchMap((rad) {
      return geo.collection(collectionRef:ref).within(
        center: center,
        radius: rad,
        field: 'coordenadas',
        //strictMode: true
      );
    }).listen(_updateMarkers);
  }
  
  _updateQuery(value){
        final zoomMap= {
            100.0: 12.0,
            200.0: 10.0,
            300.0: 7.0,
            400.0: 6.0,
            500.0: 5.0
        };
        final zoom = zoomMap[value];         
        mapController.moveCamera(CameraUpdate.zoomTo(zoom));

        setState(() {
          radius.add(value);
        });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

}





/*
        padding: const EdgeInsets.all(7.0),
        itemBuilder: (context,i){
          return new ListTile(
            title: new Text("Some Random Username"),
             subtitle: new Text("Online", style: new  TextStyle(fontStyle: FontStyle.normal, color: Colors.green)),
            leading: const Icon(Icons.face),
            trailing: new RaisedButton(
              child: new Text("Remove"),
              onPressed: (){
                deleteDialog(context).then((value){
                  if(value == true)
                  {
                    randomDialog(context,"Apagado! :>");
                  }
                });
              },
            )
          );
        },
        */


