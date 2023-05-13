import 'dart:ui';

import 'package:capstone/screens/BottomNavBArScreens/Details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/Category.dart';
import '../../modules/HomeApi.dart';
import 'Home.dart';

class Search extends StatefulWidget {
  SharedPreferences prefs;
  Search({super.key, required this.prefs});

  @override
  _SearchState createState() => _SearchState(prefs);
}

class _SearchState extends State<Search> {
  SharedPreferences prefs;
  _SearchState(this.prefs);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              title: const Text(
                "SEARCH",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w500,
                    fontSize: 28.0),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(16.0)),
            Center(child: SearchBar()),
            FutureBuilder<List<HomeItem>>(
              future: HomeApi().randomFetch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center();
                } else {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final HomeItem item = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(
                                    data: item,
                                    prefs: prefs,
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 180,
                            height: 220,
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(item.strMealThumb),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 4.0,
                                ),
                                child: Container(
                                  height: 80,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black.withOpacity(0.26),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.strMeal,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            height: 150 / 100,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'inter'),
                                      ),
                                      // Recipe Calories and Time
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              item.strMealThumb,
                                              color: Colors.white,
                                              width: 12,
                                              height: 12,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                item.strCategory,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(Icons.alarm,
                                                size: 12, color: Colors.white),
                                            // Container(
                                            //   margin: EdgeInsets.only(left: 5),
                                            //   child: Text(
                                            //     data.time,
                                            //     style: TextStyle(
                                            //         color: Colors.white,
                                            //         fontSize: 10),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0, // specify the desired width here
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.orange, // specify the color of the border here
            width: 2.0, // specify the width of the border here
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
