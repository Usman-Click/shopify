import 'package:flutter/material.dart';
import 'package:shopify/pages/favourites.dart';
import 'package:shopify/pages/movies.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;
  final List<Widget> pages = const [Movies(), Favourites()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentPage == 0 ? "Home" : "Favourites"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {},
              icon: ClipOval(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w300/j3Z3XktmWB1VhsS8iXNcrR86PXi.jpg',
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
       
        // body: pages[currentPage],
        body: IndexedStack(
          index: currentPage,
          children: pages,
        ),

      // Bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.home_max_rounded)),
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.favorite_border_rounded)),  
          ]),
      ),
    );
  }
}
