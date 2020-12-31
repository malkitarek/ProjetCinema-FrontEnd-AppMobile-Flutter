import 'file:///E:/projets-Flutter/projet_cinema/cinema_mobile/lib/services/cinema-service.dart';
import 'package:cinema_mobile/pages/menu-itme.dart';
import 'package:cinema_mobile/pages/setting-page.dart';
import 'package:cinema_mobile/pages/ville-page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void setupLocator(){
  GetIt.I.registerLazySingleton(() => CinemaService());

}

void main(){
   setupLocator();
  runApp(MaterialApp(
    theme: ThemeData(
      appBarTheme: AppBarTheme(color: Colors.orange),

    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var menus=[
    {"title":"Home","icon":Icon(Icons.home),"page":MyApp()},
    {"title":"Ville","icon":Icon(Icons.location_city),"page":VillePage()},


  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("./images/profile.jpg"),
                    radius: 30,
                  ),
                ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white,Colors.orange]
                )
              ),
            ),
            ...menus.map((item) {
             return Column(
               children: [
                 MenuItem(item["title"], item["icon"], item["page"]),
                 Divider(color: Colors.orange,)
               ],
             );
            })
          ],
        ),
      ),
      appBar: AppBar(title: Text("Cinema page")),
      body: Center(child: Text("Home Cinema ..."),),
    );
  }
}

