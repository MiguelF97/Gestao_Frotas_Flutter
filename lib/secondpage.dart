import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import "./main.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/services.dart";


class SecondPage extends StatelessWidget {

   @override
  Widget build(BuildContext context) {
    
    return  new Scaffold(
      body: ListPage(),
    );
}
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Future getPosts() async{

    var firestore = Firestore.instance;
    QuerySnapshot qn =await firestore.collection("users").orderBy("id",descending:false).getDocuments();
    return qn.documents; 
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getPosts(),
        builder: (_,snapshot) {
         if(snapshot.connectionState == ConnectionState.waiting){
        return Center(
          child: Text("Loading..."),
        );
      } else{

          }
         return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index){

              return ListTile(
                title: Text(snapshot.data[index].data.toString()),
                 
              //  onTap:() => navigateToDetail(snapshot.data[index ]), 
              );

          });
          
          }),
    );
  }
}


class DetailPage extends StatefulWidget {

  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: Text(widget.post.data["title"]),
          subtitle: Text(widget.post.data["content"]),
        ),
      ),

    );
  }
}




/* body: StreamBuilder(
          stream:Firestore.instance.collection('Users').snapshots(),
            builder:(context, snapshot) {
              if(!snapshot.hasData) return const Text('Loading..');
                return new  AlertDialog(
                title: new Text(snapshot.data.documents[0]['Nome']),
                );
              }
          );*/


/*
  @override
  Widget build(BuildContext context) {
     return new Center(
      child: new RaisedButton(
      child: new Text("Make Request"),
      onPressed: (){
        requestDataBase(context);
      }
      
    )
   );
  }*/
