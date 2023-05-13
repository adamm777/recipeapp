import 'dart:convert';
import 'dart:ui';

import 'package:capstone/screens/BottomNavBArScreens/Details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/HomeApi.dart';

class Saved extends StatefulWidget {
  SharedPreferences prefs;

  // ignore: prefer_const_constructors_in_immutables
  Saved({super.key, required this.prefs});

  @override
  _SavedState createState() => _SavedState(prefs);
}

class _SavedState extends State<Saved> {
  SharedPreferences prefs;
  List<HomeItem> savedData = [];
  _SavedState(this.prefs);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? serializedObjects = prefs.getStringList('savedObjects');

    if (serializedObjects != null) {
      List<HomeItem> loadedData = [];
      for (String serializedObject in serializedObjects) {
        HomeItem item = HomeItem.fromJson(json.decode(serializedObject));
        loadedData.add(item);
      }
      setState(() {
        savedData = loadedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              title: const Text(
                "SAVED",
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
      body: savedData.isEmpty
          ? const Center(
              child: Text(
              'No saved data',
              style: TextStyle(
                  color: Colors.grey, fontFamily: "Sans", fontSize: 24.0),
              textAlign: TextAlign.center,
            ))
          : Column(
              children: [
                Padding(padding: EdgeInsets.all(16.0)),
                SingleChildScrollView(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                      ),
                      itemCount: savedData.length,
                      itemBuilder: (BuildContext context, int index) {
                        HomeItem item = savedData[index];
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
                      }),
                )
              ],
            ),
    );
  }
}
