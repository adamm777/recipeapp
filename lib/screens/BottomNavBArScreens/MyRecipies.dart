import 'dart:convert';
import 'dart:ui';

import 'package:capstone/screens/BottomNavBArScreens/Add.dart';
import 'package:capstone/screens/BottomNavBArScreens/Details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/HomeApi.dart';

class MyRecipies extends StatefulWidget {
  SharedPreferences prefs;
  List<Recipe> mylist;
  // ignore: prefer_const_constructors_in_immutables
  MyRecipies({super.key, required this.prefs, required this.mylist});

  @override
  _MyRecipiesState createState() => _MyRecipiesState(prefs, mylist);
}

class _MyRecipiesState extends State<MyRecipies> {
  SharedPreferences prefs;
  List<Recipe> mylist;
  _MyRecipiesState(this.prefs, this.mylist);

  @override
  void initState() {
    super.initState();
    // loadData();
  }

  // void loadData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? serializedObjects = prefs.getStringList('savedObjects');

  //   if (serializedObjects != null) {
  //     List<Recipe> loadedData = [];
  //     for (String serializedObject in serializedObjects) {
  //       Recipe item = Recipe.fromJson(json.decode(serializedObject));
  //       loadedData.add(item);
  //     }
  //     setState(() {
  //       mylist = loadedData;
  //     });
  //   }
  // }

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
                "My Recipes",
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
      body: mylist.isEmpty
          ? const Center(
              child: Text(
              'Add You Recipe Now!',
              style: TextStyle(
                  color: Colors.grey, fontFamily: "Sans", fontSize: 24.0),
              textAlign: TextAlign.center,
            ))
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mylist.length,
              itemBuilder: (BuildContext context, int index) {
                Recipe item = mylist[index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => RecipeDetailPage(
                    //           data: item,
                    //           prefs: prefs,
                    //         )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 180,
                      height: 180,
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                              height: 80,
                              child: Image.asset("assets/images/Logo.png")),
                          Container(
                            height: 80,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange.shade200,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    item.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        height: 150 / 100,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'inter'),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    item.category,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        height: 150 / 100,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'inter'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
