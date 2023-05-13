import 'dart:convert';

import 'package:capstone/screens/BottomNavBArScreens/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../modules/HomeApi.dart';

import 'package:url_launcher/url_launcher.dart';

class RecipeDetailPage extends StatefulWidget {
  final HomeItem? data;
  SharedPreferences prefs;
  RecipeDetailPage({required this.data, required this.prefs});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState(data, prefs);
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with TickerProviderStateMixin {
  HomeItem? data;
  SharedPreferences prefs;
  _RecipeDetailPageState(this.data, this.prefs);
  late TabController _tabController;
  late ScrollController _scrollController;
  void saveObject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing list of saved objects from SharedPreferences
    List<String>? savedObjects = prefs.getStringList('savedObjects');

    // Create a new list or initialize an empty list if it doesn't exist
    List<String> updatedList = savedObjects ?? [];

    // Check if the current object already exists in the list
    bool alreadySaved = updatedList.contains(json.encode(data!.toJson()));

    if (alreadySaved) {
      // If the object is already saved, remove it from the list
      updatedList.remove(json.encode(data!.toJson()));

      Fluttertoast.showToast(
        msg: "This Recipe is Removed",
        backgroundColor: Colors.orange.shade300,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      // If the object is not saved, add it to the list
      updatedList.add(json.encode(data!.toJson()));

      Fluttertoast.showToast(
        msg: "This Recipe is Saved",
        backgroundColor: Colors.orange.shade300,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('savedObjects', updatedList);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      changeAppBarColor(_scrollController);
    });
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {
          appBarColor = AppColor.primary;
        });
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  // fab to write review
  showFAB(TabController tabController) {
    int reviewTabIndex = 2;
    if (tabController.index == reviewTabIndex) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<String> lines = data!.strInstructions
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AnimatedContainer(
          color: appBarColor,
          duration: Duration(milliseconds: 200),
          child: AppBar(
            backgroundColor: Colors.transparent,
            brightness: Brightness.dark,
            elevation: 0,
            title: Text(widget.data!.strMeal),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    saveObject();
                  },
                  icon: Image.asset('assets/images/save.png',
                      color: Colors.white)),
            ],
          ),
        ),
      ),
      // floatingActionButton: Visibility(
      //   visible: showFAB(_tabController),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       showDialog(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return AlertDialog(
      //               content: Container(
      //                 width: MediaQuery.of(context).size.width,
      //                 height: 150,
      //                 color: Colors.white,
      //                 child: TextField(
      //                   keyboardType: TextInputType.multiline,
      //                   minLines: 6,
      //                   decoration: InputDecoration(
      //                     hintText: 'Write your review here...',
      //                   ),
      //                   maxLines: null,
      //                 ),
      //               ),
      //               actions: [
      //                 Row(
      //                   children: [
      //                     Container(
      //                       width: 120,
      //                       child: TextButton(
      //                         onPressed: () {
      //                           Navigator.of(context).pop();
      //                         },
      //                         child: Text('cancel'),
      //                         style: TextButton.styleFrom(
      //                           primary: Colors.grey[600],
      //                         ),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: Container(
      //                         child: ElevatedButton(
      //                           onPressed: () {},
      //                           child: Text('Post Review'),
      //                           style: ElevatedButton.styleFrom(
      //                             primary: AppColor.primary,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 )
      //               ],
      //             );
      //           });
      //     },
      //     child: Icon(Icons.edit),
      //     backgroundColor: AppColor.primary,
      //   ),
      // ),

      body: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Recipe Image
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => FullScreenImage(
              //         image:
              //             Image.asset(widget.data.photo, fit: BoxFit.cover))));
            },
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(data!.strMealThumb),
                      fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(gradient: AppColor.linearBlackTop),
                height: 280,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Section 2 - Recipe Info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
            color: AppColor.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/chefhat.png',
                      color: Colors.white,
                      width: 16,
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: const Text(
                        "chefs name",
                        style: TextStyle(
                          fontFamily: "Popins",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12, top: 16),
                  child: Text(
                    data!.strMeal,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter'),
                  ),
                ),
                Text(
                  data!.strCategory,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 150 / 100),
                ),
              ],
            ),
          ),

          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: Colors.orange.shade200,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
              labelStyle:
                  TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w500),
              indicatorColor: Colors.black54,
              tabs: const [
                Tab(
                  text: 'Ingridients',
                ),
                Tab(
                  text: 'Instructions',
                ),
                Tab(
                  text: 'Tutorial',
                ),
              ],
            ),
          ),

          IndexedStack(
            index: _tabController.index,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        data!.strIngredient1 != ""
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title:
                                      Center(child: Text(data!.strIngredient1)),
                                ),
                              )
                            : SizedBox(),
                        data!.strIngredient2 != ""
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title:
                                      Center(child: Text(data!.strIngredient2)),
                                ),
                              )
                            : SizedBox(),
                        data!.strIngredient3 != ""
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title:
                                      Center(child: Text(data!.strIngredient3)),
                                ),
                              )
                            : SizedBox(),
                        data!.strIngredient4 != ""
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title:
                                      Center(child: Text(data!.strIngredient4)),
                                ),
                              )
                            : SizedBox(),
                        data!.strIngredient5 != ""
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title:
                                      Center(child: Text(data!.strIngredient5)),
                                ),
                              )
                            : SizedBox(),
                        data!.strIngredient6 != ""
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title:
                                      Center(child: Text(data!.strIngredient6)),
                                ),
                              )
                            : SizedBox(),
                        data!.strIngredient7 != ""
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title:
                                      Center(child: Text(data!.strIngredient7)),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (var line in lines)
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: line != " "
                                ? ListTile(
                                    title: Center(child: Text(line)),
                                  )
                                : SizedBox(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(90.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.orange.shade300)),
                          onPressed: () {
                            launch(data!.strYoutube);
                          },
                          child: Text("Click Here To Watch!")),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppColor {
  static Color primary = Colors.orange.shade300;
  static Color primarySoft = Colors.orange.shade100;
  static Color primaryExtraSoft = Color(0xFFEEF4F4);
  static Color secondary = Color(0xFFEDE5CC);
  static Color whiteSoft = Color(0xFFF8F8F8);
  static LinearGradient bottomShadow = LinearGradient(colors: [
    Color(0xFF107873).withOpacity(0.2),
    Color(0xFF107873).withOpacity(0)
  ], begin: Alignment.bottomCenter, end: Alignment.topCenter);
  static LinearGradient linearBlackBottom = LinearGradient(
      colors: [Colors.black.withOpacity(0.45), Colors.black.withOpacity(0)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter);
  static LinearGradient linearBlackTop = LinearGradient(
      colors: [Colors.black.withOpacity(0.5), Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}

class IngridientTile extends StatelessWidget {
  final Ingridient data;
  IngridientTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 9,
            child: Text(
              data.name.toString(),
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, height: 150 / 100),
            ),
          ),
          Flexible(
            flex: 3,
            child: Text(
              data.size.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'inter',
                  color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

class Ingridient {
  Object? name;
  Object? size;

  Ingridient({required this.name, required this.size});
  factory Ingridient.fromJson(Map<String, Object> json) {
    return Ingridient(
      name: json['name'],
      size: json['size'],
    );
  }
  // Map<String, Object> toMap() {
  //   return {
  //     'name': name,
  //     'size': size,
  //   };
  // }

  static List<Ingridient> toList(List<Map<String, Object>> json) {
    return List.from(json)
        .map((e) => Ingridient(name: e['name'], size: e['size']))
        .toList();
  }
}
