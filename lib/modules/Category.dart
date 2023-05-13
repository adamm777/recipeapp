import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class CategoryItem {
  String idCategory;
  String strCategory;
  String strCategoryThumb;
  String strCategoryDescription;
  CategoryItem({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });
  factory CategoryItem.fromJson(Map<dynamic, dynamic> json) {
    return CategoryItem(
      idCategory: json["idCategory"], 
      strCategory: json["strCategory"],
      strCategoryThumb: json["strCategoryThumb"],
      strCategoryDescription: json["strCategoryDescription"],
    );
  }
}

class CategoryApi {
  // cache variable
  final databaseReference = FirebaseDatabase.instance.ref();
  Future<List<CategoryItem>> fetchData() async {
    List<CategoryItem>? cachedCategories;
    if (cachedCategories != null) {
      // check if cached data is stale
      final snapshot = await databaseReference.child('categories').once();
      final catList = (snapshot.snapshot.value ?? []) as List<dynamic>;
      final categories =
          catList.map((json) => CategoryItem.fromJson(json)).toList();
      if (!listEquals(categories, cachedCategories)) {
        // if cached data is stale, update it
        cachedCategories = categories;
      }
      return cachedCategories;
    } else {
      // if data is not in cache, fetch it and cache it
      final snapshot = await databaseReference.child('categories').once();
      final catList = (snapshot.snapshot.value ?? []) as List<dynamic>;
      final categories =
          catList.map((json) => CategoryItem.fromJson(json)).toList();
      cachedCategories = categories; // cache the data
      // set up a listener to update the cache when data in the database updates
      databaseReference.child('categories').onValue.listen((event) {
        final catList = (event.snapshot.value ?? []) as List<dynamic>;
        final categories =
            catList.map((json) => CategoryItem.fromJson(json)).toList();
        cachedCategories = categories;
      });
      return categories;
    }
  }
}
