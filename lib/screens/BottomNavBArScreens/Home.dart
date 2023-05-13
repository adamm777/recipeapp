import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone/modules/HomeApi.dart';
import 'package:capstone/screens/BottomNavBArScreens/Add.dart';
import 'package:capstone/screens/BottomNavBArScreens/MyRecipies.dart';
import 'package:capstone/screens/BottomNavBArScreens/Settings.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:capstone/screens/BottomNavBArScreens/Details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  SharedPreferences prefs;
  Home({required this.prefs});
  @override
  _HomeState createState() => _HomeState(prefs: prefs);
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  SharedPreferences prefs;
  _HomeState({required this.prefs});
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              title: const Text(
                "HOME",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w500,
                    fontSize: 28.0),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0.5,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        prefs: prefs,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Browse Some of Our Chef's Recipes",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
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
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  item.strCategory,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(Icons.alarm,
                                                  size: 12,
                                                  color: Colors.white),
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

class CustomDrawer extends StatelessWidget {
  SharedPreferences prefs;
  CustomDrawer({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      prefs.get("photo").toString(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    prefs.get("name").toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    prefs.get("email").toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Image.asset("assets/images/hat.png"),
            title: Text('My Recipes'),
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => MyRecipies(
                        prefs: prefs,
                        mylist: [],
                      )));
              // TODO: Implement account screen
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/images/image 8.png",
              height: 40,
            ),
            title: Text('  Grocery List'),
            onTap: () {
              // TODO: Implement settings screen
            },
          ),
          ListTile(
            leading: Image.asset("assets/images/image 9.png"),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SettingsPage(
                        prefs: prefs,
                      )));

              // TODO: Implement settings screen
            },
          ),
        ],
      ),
    );
  }
}
