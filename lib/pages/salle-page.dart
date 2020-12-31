import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cinema_mobile/services/cinema-service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SallePage extends StatefulWidget {
  dynamic cinema;
  SallePage(this.cinema);
  @override
  _SallePageState createState() => _SallePageState();
}

class _SallePageState extends State<SallePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomClient = TextEditingController();
  TextEditingController codeClient = TextEditingController();
  TextEditingController nbrTickets = TextEditingController();
  List<dynamic> listSalles;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSalles();
  }
  void loadSalles(){
    CinemaService().getSalles(widget.cinema['id']).then((response){
       setState(() {
         listSalles=json.decode(response.body)["_embedded"]["salles"];
       });
    }).catchError((err){
      print(err);
    });
  }
  void loadProjections(salle){

    CinemaService().getProjections(salle["id"]).then((response){
      setState(() {
        salle["projections"]=json.decode(response.body)["_embedded"]["projections"];
        salle["currentProjection"]=salle["projections"][0];
      });

    }).catchError((err){
      print(err);
    });

  }
  void loadTickets(projection,salle) {

    CinemaService().getTickets(projection["id"]).then((response){
      setState(() {
        projection["listTickets"]=json.decode(response.body)["_embedded"]["tickets"];
        print(projection["place"]);
        salle["currentProjection"]=projection;
      });

    }).catchError((err){
      print(err);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cinémas de ${widget.cinema["name"]}"),),
      body:Center(
        child: listSalles==null?CircularProgressIndicator()
            :ListView.builder(
            itemCount: (this.listSalles==null)?0:this.listSalles.length,
            itemBuilder: (context,index){
              return  Card(
                color: Colors.white,
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.orange,
                          child: Text(listSalles[index]["name"],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                          onPressed: (){
                            loadProjections(listSalles[index]);
                          },
                        ),
                      ),
                    ),
                    if(listSalles[index]["projections"]!=null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(CinemaService.host+"/imageFilm/${listSalles[index]["currentProjection"]["film"]["id"]}",width: 150,),
                          Column(
                            children: [
                              ...(listSalles[index]["projections"] as List<dynamic>).map((projection){
                               return RaisedButton(
                                   color: (listSalles[index]["currentProjection"]['id']==projection["id"])?Colors.deepOrange:Colors.green,
                                   child: Text("${projection['seance']['heureDebut']}(${projection['film']['duree']}, Prix=${projection['prix'].round()}DA)",style: TextStyle(color: Colors.white),),
                                   onPressed:(){
                                       loadTickets(projection,listSalles[index]);
                                   });
                              })
                            ],
                          )

                        ],
                      ),
                    ),
                    if(
                    listSalles[index]["currentProjection"]!=null &&
                    listSalles[index]["currentProjection"]["listTickets"]!=null
                   // && this.listSalles[index]["currentProjection"]["listTickets"].length>0
                    )

                     Column(
                       children: [
                         Form(
                           key: _formKey,
                           child: Column(
                           children: [
                             Container(
                               child: TextFormField(
                                 controller: nomClient,
                                 validator: (value) {
                                   if (value.isEmpty) {
                                     return 'Please enter some text';
                                   }
                                   return null;
                                 },
                                 decoration: InputDecoration(hintText: "your name"),
                               ),
                             ),
                             Container(
                               child: TextFormField(
                                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                 keyboardType: TextInputType.number,
                                 controller: codeClient,
                                 validator: (value) {
                                   if (value.isEmpty) {
                                     return 'Please enter some text';
                                   }
                                   return null;
                                 },
                                 decoration: InputDecoration(hintText: "code payement"),
                               ),
                             ),
                             Container(
                               child: TextFormField(
                                 keyboardType: TextInputType.number,
                                 controller: nbrTickets,
                                 validator: (value) {
                                   if (value.isEmpty) {
                                     return 'Please enter some text';
                                   }
                                   return null;
                                 },
                                 decoration: InputDecoration(hintText: "nombre de tickets "),
                               ),
                             ),
                             Container(
                               width: double.infinity,
                               padding: EdgeInsets.all(8),
                               child: RaisedButton(
                                 color: Colors.deepOrange,
                                 child: Text("Réserver",style: TextStyle(color: Colors.white),),
                                 onPressed: () {
                                   // Validate returns true if the form is valid, or false
                                   // otherwise.

                                     // If the form is valid, display a Snackbar.
                                   if(_formKey.currentState.validate()){
                                      dynamic ticketForm ={
                                        "nomClient":nomClient.text,
                                        "codePayement":codeClient.text,
                                        "nbrTickets":nbrTickets.text
                                      };
                                      setState(() {
                                        CinemaService().postTickets(ticketForm);
                                      });
                                   }


                                 },
                               ),
                             ),
                           ],
                         )),
                         Wrap(
                           children: [
                             ...(listSalles[index]["currentProjection"]["listTickets"] as List<dynamic>).map((ticket){
                               if(ticket["reserve"]==false){
                                 return Container(
                                   width: 50,
                                   padding: EdgeInsets.all(2),
                                   child: RaisedButton(
                                       color: Colors.green,
                                       child: Text("${ticket['place']['numero']}",style: TextStyle(color:Colors.white,fontSize: 10),),
                                       onPressed: (){

                                       }),
                                 );
                               }else{
                                 return Container(
                                   width: 50,
                                   padding: EdgeInsets.all(2),
                                   child: RaisedButton(
                                       color: Colors.orange,
                                       child: Text("Res",style: TextStyle(color:Colors.white,fontSize: 10),),
                                       onPressed: (){

                                       }),
                                 );
                               }

                             })
                           ],
                         )
                       ],
                     ),

                  ],
                )
              );
            }),
      ),
    );
  }



}
