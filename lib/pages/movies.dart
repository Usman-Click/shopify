import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopify/keys.dart';
import 'package:shopify/pages/movie.dart';
class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {

  late Future<Map<String, dynamic>> trendingMovies;

  int selChip = 0;

  final List<Map<String, dynamic>> filters = [
    {"name": "Popular", "isSelected": false},
    {"name": "Trending", "isSelected": false},
    {"name": "Recommended", "isSelected": false},
    {"name": "New", "isSelected": false},
    {"name": "Old", "isSelected": false},
    {"name": "More", "isSelected": false},
  ];

  @override
  void initState() {
    super.initState();
    try {
      trendingMovies = getTrending();
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> getTrending() async {
    final Map<String, String> headers = {
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNjVjMWNlMWJjOTE2YTVmYzgyODEwYWM3NTllMjljZSIsInN1YiI6IjY2NGE2YzIxN2E0ZmJhOTBlZjc5NTg4YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._fI7hQFdREpxGeGcA5JqPNNc_b1a31R3C6PLoyEHRdY"
    };

    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw ("Error reading data: $e");
      }
    } else {
      throw ("Invalid Request");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chips
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FilterChip(
                              onSelected: (isSelected){
                                setState(() {
                                  selChip = index;
                                });
                              },
                              label: Text(filters[index]["name"]),
                              labelStyle: TextStyle(
                                color: index == selChip ? Colors.white : null,
                              ),
                              selectedColor:
                                  index == selChip ? Colors.red : null,
                              selected: index == selChip ? true : false,
                              showCheckmark: false,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                          );
                        }),
                  ),

                  // Trending movies
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                      future: trendingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text(
                                  "Unable to load movies, try again letter"));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        }

                        final Map<String, dynamic> data = snapshot.data!;
                        final trending = data["results"][4];
                        final String img =
                            imgBaseUrl + trending["backdrop_path"];

                        final List<String> contents = [
                          trending["adult"] == true ? "18+" : "10+",
                          "Action",
                          trending["vote_average"].toString(),
                        ];
                        print(data.toString());

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // main img
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return MoviePage(
                                      id: trending["id"],
                                        imgUrl: imgBaseUrl +
                                            trending["poster_path"],
                                        actorsImgUrl:
                                            trending["original_title"],
                                        overview: trending["overview"],
                                        name: trending["original_title"],
                                        releaseData: trending["release_date"],
                                        contentList: contents);
                                  }));
                                },
                                child: Container(
                                    height: 230,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          img,
                                          width: double.infinity,
                                          height: 230,
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              trending["original_title"],
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),

                              // this week
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "this week",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: GestureDetector(
                                                onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context){
                                                        return MoviePage(
                                                          id:  data["results"][index]["id"],
                                                        imgUrl: imgBaseUrl +
                                                            data["results"][index]["poster_path"],
                                                        actorsImgUrl:
                                                            data["results"][index]["original_title"],
                                                        overview: data["results"][index]["overview"],
                                                        name: data["results"][index]["original_title"],
                                                        releaseData: data["results"][index]["release_date"],
                                                        contentList: contents);
                                                      } ));
                                                      
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.network(
                                                      imgBaseUrl +
                                                          data["results"][index]
                                                              ["backdrop_path"],
                                                      width: 100,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      data["results"][index]
                                                              ["original_title"]
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]);
                                  },
                                ),
                              ),


                              // this week
                              const Text(
                                "this week",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    index += 10;
                                    return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: GestureDetector(
                                                onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context){
                                                        return MoviePage(
                                                          id: data["results"][index]["id"],

                                                        imgUrl: imgBaseUrl +
                                                            data["results"][index]["poster_path"],
                                                        actorsImgUrl:
                                                            data["results"][index]["original_title"],
                                                        overview: data["results"][index]["overview"],
                                                        name: data["results"][index]["original_title"],
                                                        releaseData: data["results"][index]["release_date"],
                                                        contentList: contents);
                                                      } ));
                                                      
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.network(
                                                      imgBaseUrl +
                                                          data["results"]
                                                                  [index]
                                                              ["backdrop_path"],
                                                      width: 100,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      data["results"][index]
                                                              ["original_title"]
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]);
                                  },
                                ),
                              )
                            ]);
                      }),
                ],
              )),
        );
  }
}