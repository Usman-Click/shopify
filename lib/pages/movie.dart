import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopify/keys.dart';

class MoviePage extends StatefulWidget {
  final String imgUrl, name, overview, releaseData, actorsImgUrl;
  final int id;
  final List<String> contentList;
  const MoviePage(
      {super.key,
      required this.imgUrl,
      required this.name,
      required this.overview,
      required this.releaseData,
      required this.actorsImgUrl,
      required this.contentList, required this.id});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  bool isfav = false;

  late Future<Map<String, dynamic>> casts;
  late Future<Map<String, dynamic>> favourites;

    final Map<String, String> headers = {
    "accept": "application/json",
    "content-type": "application/json",
    "authorization": authKey,   
  };


  @override
  void initState() {
    super.initState();
    casts = getCasts();
  }


void addToFavourites () async {

  final Map<String, dynamic> body = {
     "media_type": "movie",
    "media_id": widget.id,
    "favorite": true
  };

  final req = await http.post(Uri.parse(favBaseUrl), headers: headers, body: jsonEncode(body) );

  if (req.statusCode != 201) {
      throw("Error ${req.statusCode}");
  }else{
      throw("Sucess");
  }


}
  Future<Map<String, dynamic>> getCasts() async {
       final res = await http.get(
        Uri.parse("https://api.themoviedb.org/3/trending/person/day"),
        headers: headers);

    if (res.statusCode != 200) {
      throw ();
    } else {
      return jsonDecode(res.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main img
            ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(20)),
                child: Image.network(
                  widget.imgUrl,
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                )),

            // chips
            const SizedBox(
              height: 5,
            ),
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
                          for (int i = 0; i < 3; i++)
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: ActionChip(
                                  label: Text(
                                    widget.contentList[i],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  side: BorderSide.none,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  disabledColor: Colors.white10),
                            ),
                        ],
                      ),

                      // sec row
                      Row(
                        // make it take the only width of its children else i'll take whole pf it
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle_outlined,
                            color: Colors.white54,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!isfav) {
                                  try{
                                    addToFavourites();
                                    ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text("Added")));
                                  }catch(e){
                                      print(e);
                                  }                                  
                                  isfav = true;
                                } else {
                                  // TODO
                                  isfav = false;
                                }
                              });
                            },
                            child: isfav
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.favorite_outline_rounded,
                                    color: Colors.white54,
                                    size: 30,
                                  ),
                          ),
                          const SizedBox(
                            width: 15,
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                    widget.overview,
                    style: const TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Cast",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder(
                      future: casts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
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
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 60,
                                  margin: const EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          imgBaseUrl +
                                              data["results"][index]
                                                  ["profile_path"],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        data["results"][index]["name"]
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                );
                              }),
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
