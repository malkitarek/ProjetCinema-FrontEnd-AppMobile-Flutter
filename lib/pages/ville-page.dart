import 'dart:convert';

import 'package:cinema_mobile/services/cinema-service.dart';
import 'package:cinema_mobile/pages/cinema-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;


class VillePage extends StatefulWidget {

  @override
  _VillePageState createState() => _VillePageState();
}

class _VillePageState extends State<VillePage> {
  CinemaService get service => GetIt.I<CinemaService>();

  List<dynamic> listVilles  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      loadVilles();
  }
  void loadVilles() async{
    CinemaService().getVilles().then((response){
          setState(() {
            listVilles=json.decode(response.body)["_embedded"]["villes"];
          });
        }).catchError((err){
          print(err);
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Villes"),),
      body: Center(
        child: listVilles==null?CircularProgressIndicator()
        :ListView.builder(
            itemCount: (this.listVilles==null)?0:this.listVilles.length,
            itemBuilder: (context,index){
              return  Card(
                    color: Colors.orange,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.white,
                        child: Text(listVilles[index]["name"],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CinemaPage(listVilles[index])));
                        },
                      ),
                    ),
              );
            }),
      ),
    );
  }
}
