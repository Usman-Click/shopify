import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index){
        return ListTile(
          title: Text("Test"),
          subtitle: Text("data"),
        );
      });
  }
}