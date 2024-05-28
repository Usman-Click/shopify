import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopify/keys.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  late Future<Map<String, dynamic>> favs;

  Future<Map<String, dynamic>> getFavs() async{
    final req = await http.get(Uri.parse("$favBaseUrl/movies"), headers: {
      "authorization": authKey
    });

    if (req.statusCode != 200) {
      throw("Error: ${req.statusCode}");
    }

    return jsonDecode(req.body);
  }

  @override
  void initState(){
    super.initState();
    favs = getFavs();
  }


  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
     future: favs,
     builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator.adaptive(),);
      }

      if (snapshot.hasError) {
        return const Center(child: Text("Unable to load data, check your connection"));
      }

      final data = snapshot.data!;
      print(data.toString());

      return ListView.builder(
      // itemCount: [data['results'] as List].length,
      itemCount: data['total_results'],
      itemBuilder: (context, index){
        // i'll return a Map not a List, the List that i sel will return a Map, so its a Map not a List
        Map<String, dynamic> currentItem = data["results"][index];
        return ListTile(
          title: Text(currentItem["original_title"]),
          subtitle: Text('Release date ${currentItem["release_date"]}'),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imgBaseUrl + currentItem["backdrop_path"]),
          ),
          trailing: const Icon(Icons.remove),
          
        );
      });
     });
  }
}