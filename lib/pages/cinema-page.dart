import 'dart:convert';
import 'package:cinema_mobile/pages/salle-page.dart';
import 'package:cinema_mobile/services/cinema-service.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class CinemaPage extends StatefulWidget {
  dynamic ville;
  CinemaPage(this.ville);
  @override
  _CinemaPageState createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  List<dynamic> listCinemas;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCinemas();
  }
  void loadCinemas() {
      print(widget.ville['name']);
       CinemaService().getCinemas(widget.ville['id']).then((response){
       setState(() {
         listCinemas=json.decode(response.body)["_embedded"]["cinemas"];
         print(listCinemas[1]["name"]);
       });
     }).catchError((err){
       print(err);
      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cinémas de ${widget.ville["name"]}"),),
      body:Center(
        child: listCinemas==null?CircularProgressIndicator()
            :ListView.builder(
            itemCount: (this.listCinemas==null)?0:this.listCinemas.length,
            itemBuilder: (context,index){
              return  Card(
                color: Colors.orange,
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.white,
                    child: Text(listCinemas[index]["name"],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SallePage(listCinemas[index])));
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}
