import 'package:capstone/screens/BottomNavBArScreens/BottomNavBAr.dart';
import 'package:capstone/screens/BottomNavBArScreens/MyRecipies.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

class Add extends StatefulWidget {
  PageController _pageController = PageController(initialPage: 0);
  SharedPreferences prefs;
  Add({super.key, required this.prefs});

  @override
  _AddState createState() => _AddState(_pageController, prefs);
}

class _AddState extends State<Add> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController catcontroller = TextEditingController();
  TextEditingController instcontroller = TextEditingController();
  PageController _pageController;
  SharedPreferences prefs;
  File? image;
  _AddState(this._pageController, this.prefs);
  List<Recipe> list = [];
  List<String> inglist = [];
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
                "NEW RECIPE",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w500,
                    fontSize: 28.0),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (_pageController.page == 0) {
                    // Handle back navigation from the first page
                  } else {
                    // Navigate to the previous page in PageView
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
              ),
              elevation: 1.0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          // First page
          IngredientPage(_pageController, inglist),

          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(16.0)),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ImageSelector(
                        image: image,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("NAME"),
                                ),
                                SizedBox(
                                  width: 170.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: Colors.orange,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: namecontroller,
                                      decoration: const InputDecoration(
                                        hintText: 'Name',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("CATEGORY"),
                                ),
                                SizedBox(
                                  width: 170.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: Colors.orange,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: catcontroller,
                                      decoration: const InputDecoration(
                                        hintText: 'Category',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Instructions"),
                            ),
                            SizedBox(
                              width: 270.0,
                              height: 100,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextField(
                                  controller: instcontroller,
                                  decoration: const InputDecoration(
                                    hintText: 'Instructions on Separate Lines',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.orange.shade300,
                        ),
                        child: TextButton(
                          onPressed: () {
                            list.add(Recipe(
                                name: namecontroller.text,
                                ingredients: inglist,
                                category: catcontroller.text,
                                description: instcontroller.text,
                                image: image));
                            catcontroller.clear();
                            namecontroller.clear();
                            instcontroller.clear();
                            inglist.clear();
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => MyRecipies(
                                      prefs: prefs,
                                      mylist: list,
                                    )));

                            Fluttertoast.showToast(
                                msg: "Your Recipe is Sent for Chef's Approval",
                                backgroundColor: Colors.orange.shade300,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_SHORT);
                            _pageController.animateToPage(
                              0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Second page
        ],
      ),
    );
  }
}

class ImageSelector extends StatefulWidget {
  File? image;
  ImageSelector({required this.image});
  @override
  _ImageSelectorState createState() => _ImageSelectorState(image);
}

class _ImageSelectorState extends State<ImageSelector> {
  File? _image;
  _ImageSelectorState(this._image);
  final picker = ImagePicker();

  Future getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Select from gallery'),
                    onTap: () {
                      getImage();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Take a photo'),
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: 150.0,
        width: 250.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.orange,
            width: 1.0,
          ),
        ),
        child: _image == null
            ? Image.asset(
                "assets/images/image 10.png",
                height: 25.0,
              )
            : Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class IngredientPage extends StatefulWidget {
  PageController _pageController;
  List<String> ingredients;
  IngredientPage(this._pageController, this.ingredients);
  @override
  _IngredientPageState createState() =>
      _IngredientPageState(_pageController, ingredients);
}

class _IngredientPageState extends State<IngredientPage> {
  List<String> ingredients;
  PageController _pageController;
  _IngredientPageState(this._pageController, this.ingredients);
  void addIngredient(String ingredient) {
    setState(() {
      ingredients.add(ingredient);
    });
  }

  Widget buildIngredientList() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(ingredients[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Colors.orange.shade300,
            borderRadius: BorderRadius.all(Radius.circular(90))),
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String newIngredient = '';
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Add Ingredient'),
                      content: TextFormField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          labelText: 'Enter an ingredient',
                          hintStyle: TextStyle(color: Colors.orange),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            newIngredient = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an ingredient';
                          }
                          return null;
                        },
                      ),
                      actions: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.orange.shade300),
                          ),
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.orange.shade300),
                          ),
                          child: Text('Add'),
                          onPressed: newIngredient.isEmpty
                              ? null
                              : () {
                                  addIngredient(newIngredient);
                                  Navigator.of(context).pop();
                                },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ingredients.isNotEmpty
              ? Expanded(
                  child: buildIngredientList(),
                )
              : const Expanded(
                  child: Center(
                  child: Text(
                    "Add Your Ingredients",
                    style: TextStyle(
                        color: Colors.grey, fontFamily: "Sans", fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                )),
          Container(
            width: double.infinity,
            margin:
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.orange.shade300,
            ),
            child: TextButton(
              onPressed: () {
                if (ingredients.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Add Ingredients Please",
                      backgroundColor: Colors.orange.shade900,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT);
                } else {
                  _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Recipe {
  String name;
  List<String> ingredients;
  String category;
  String description;
  File? image;

  Recipe(
      {required this.name,
      required this.ingredients,
      required this.category,
      required this.description,
      required this.image});
}
