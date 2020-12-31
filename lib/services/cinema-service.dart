import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CinemaService {
  static String host = "http://192.168.1.35:8080";

  Future getVilles() {
    String url = host + '/villes';
    return http.get(url);
  }

  Future getCinemas(villeId) {
    String url = host + '/villes/$villeId/cinemas';
    return http.get(url);
  }

  Future getSalles(cinemaId) {
    String url = host + '/cinemas/$cinemaId/salles';
    return http.get(url);
  }
  Future getProjections(salleId) {
    String url = host + '/salles/$salleId/projections?projection=p1';
    return http.get(url);
  }

  getTickets(projectionId) {
    String url = host + '/projections/$projectionId/tickets?projection=ticketProj';
    return http.get(url);
  }
  Future postTickets(ticketFrom) async{
    String url = host + '/payerTickets2';

    final http.Response response = await http.post(url,
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(ticketFrom));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }

    }

}
