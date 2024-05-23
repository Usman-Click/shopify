import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MoviePage extends StatefulWidget {
  final String imgUrl, name, overview, releaseData, actorsImgUrl;
  final List<String> contentList;
  const MoviePage({super.key, required this.imgUrl, required this.name, required this.overview, required this.releaseData, required this.actorsImgUrl, required this.contentList});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  bool isfav = false;
  final String imgBaseUrl = 'https://image.tmdb.org/t/p/w500';
  late Future<Map<String, dynamic>> Casts;

  @override
  void initState() {
    super.initState();
    Casts = getCasts();
  }


  Future<Map<String, dynamic>> getCasts () async{
     final Map<String, String> headers = {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNjVjMWNlMWJjOTE2YTVmYzgyODEwYWM3NTllMjljZSIsInN1YiI6IjY2NGE2YzIxN2E0ZmJhOTBlZjc5NTg4YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._fI7hQFdREpxGeGcA5JqPNNc_b1a31R3C6PLoyEHRdY"
    };
    final res = await http.get(Uri.parse("https://api.themoviedb.org/3/trending/person/day"), headers: headers);

    if (res.statusCode != 200) {
      throw(); 
    }else{
      return jsonDecode(res.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main img
            ClipRRect(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
              child: Image.network(widget.imgUrl, width: double.infinity, height: 500, fit: BoxFit.cover,)
              ),
        
        
              // chips
              const SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // first row
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for(int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: ActionChip(label: Text(widget.contentList[i], style: const TextStyle(fontSize: 12),),
                        side: BorderSide.none,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        disabledColor: Colors.white10),
                      ),
                    ],
                    ),
                
                    // sec row
                     Row(
                       // make it take the only width of its children else i'll take whole pf it
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         const Icon(Icons.play_circle_outlined, color: Colors.white54, size: 30,),
                         const SizedBox(width: 8,),
                         GestureDetector(
                           onTap: () {
                             setState(() {
                               if (isfav) {
                                 // TODO
                                 isfav = false;
                               }else{
                                 // TODO
                                 isfav = true;
                               }
                             });
                             
                           },
                           child: isfav ? const Icon(Icons.favorite, color: Colors.red, size: 30,) 
                           : const Icon(Icons.favorite_outline_rounded, color: Colors.white54, size: 30,),
                         ),
                         const SizedBox(width: 15,)
                       ],
                     )
                
                  ],
                ),
        
                
              const SizedBox(height: 10),
              Text(widget.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        
        
               const SizedBox(height: 5),
              Text(widget.overview, style: const TextStyle(color: Colors.white54),),
        
              const SizedBox(height: 15,),
              const Text("Cast", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        
              const SizedBox(height: 5,),
              FutureBuilder(
              future: Casts,
               builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
        
                if (snapshot.hasError) {
                  return const Text("Error");
                }
        
                final data = snapshot.data!;
        
                return SizedBox(
                  height: 115,
                  child: ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
      
                     return Container(
                      width: 60,
                      margin: const EdgeInsets.all(5),
                       child: Column(
                         children: [
                           ClipOval(child: Image.network(imgBaseUrl + data["results"][index]["profile_path"], width: 60, height: 60, fit: BoxFit.cover,),),
                           Text(data["results"][index]["name"].toString(), overflow: TextOverflow.ellipsis, maxLines: 1,)
                         ],
                       ),
                     );
                          
                    }
                    ),
                );
        
        
               })
                  ],
                ),
                )
              
        
        
        
        
        
          ],
        ),
      ),
    );
  }
}