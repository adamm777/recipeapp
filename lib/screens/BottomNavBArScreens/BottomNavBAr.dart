import 'package:capstone/screens/BottomNavBArScreens/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Add.dart';
import 'Search.dart';

import 'Saved.dart';

class bottomNavigationBar extends StatefulWidget {
  final SharedPreferences prefs;
  const bottomNavigationBar({super.key, required this.prefs});

  @override
  _bottomNavigationBarState createState() => _bottomNavigationBarState(prefs);
}

class _bottomNavigationBarState extends State<bottomNavigationBar>
    with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  List<Widget> pages = [];

  // Must include
  @override
  bool get wantKeepAlive => true;
  final SharedPreferences prefs;
  _bottomNavigationBarState(this.prefs);
  @override
  void initState() {
    super.initState();
    pages = [
      Home(
        prefs: prefs,
      ),
      Search(
        prefs: prefs,
      ),
      Saved(
        prefs: prefs,
      ),
      Add(
        prefs: prefs,
      )
    ];
  }

  /// Set a type current number a layout class
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return Home(
          prefs: prefs,
        );
      case 1:
        return Search(
          prefs: prefs,
        );
      case 2:
        return Saved(
          prefs: prefs,
        );
      case 3:
        return Add(
          prefs: prefs,
        );

      default:
        return Home(
          prefs: prefs,
        );
    }
  }

  final PageController _pageController = PageController(initialPage: 0);

  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          Home(
            prefs: prefs,
          ),
          Search(
            prefs: prefs,
          ),
          Saved(
            prefs: prefs,
          ),
          Add(
            prefs: prefs,
          )
        ],
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.grey.shade300,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: const TextStyle(color: Colors.black12))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              unselectedItemColor: Colors.black45,
              selectedItemColor: Colors.orange.shade300,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  _pageController.jumpToPage(index);
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/save.png',
                    width: 40,
                    height: 35,
                  ),
                  label: "Saved",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  label: "Add",
                ),
              ],
            )),
      ),
    );
  }
}
