import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeItem {
  String idMeal;
  String strMeal;
  String strCategory;
  String strMealThumb;
  String strIngredient1;
  String strIngredient2;
  String strIngredient3;
  String strIngredient4;
  String strIngredient5;
  String strIngredient6;
  String strIngredient7;
  String strInstructions;
  String strYoutube;
  HomeItem(
      {required this.idMeal,
      required this.strMeal,
      required this.strCategory,
      required this.strMealThumb,
      required this.strIngredient1,
      required this.strIngredient2,
      required this.strIngredient3,
      required this.strIngredient4,
      required this.strIngredient5,
      required this.strIngredient6,
      required this.strIngredient7,
      required this.strInstructions,
      required this.strYoutube});
  factory HomeItem.fromJson(Map<dynamic, dynamic> json) {
    return HomeItem(
        idMeal: json["idMeal"],
        strMeal: json["strMeal"],
        strCategory: json["strCategory"],
        strMealThumb: json["strMealThumb"],
        strIngredient1: json["strIngredient1"],
        strIngredient2: json["strIngredient2"],
        strIngredient3: json["strIngredient3"],
        strIngredient4: json["strIngredient4"],
        strIngredient5: json["strIngredient5"],
        strIngredient6: json["strIngredient6"],
        strIngredient7: json["strIngredient7"],
        strInstructions: json["strInstructions"],
        strYoutube: json["strYoutube"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "idMeal": idMeal,
      "strMeal": strMeal,
      "strCategory": strCategory,
      "strMealThumb": strMealThumb,
      "strIngredient1": strIngredient1,
      "strIngredient2": strIngredient2,
      "strIngredient3": strIngredient3,
      "strIngredient4": strIngredient4,
      "strIngredient5": strIngredient5,
      "strIngredient6": strIngredient6,
      "strIngredient7": strIngredient7,
      "strInstructions": strInstructions,
      "strYoutube": strYoutube,
    };
  }
}

class HomeApi {
  Future<List<HomeItem>> randomFetch() async {
    List<HomeItem> homeItems = [];

    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      final List meals = json.decode(response.body)['meals'];

      for (var meal in meals) {
        homeItems.add(HomeItem.fromJson(meal));
      }
    }
    final response1 = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response1.statusCode == 200) {
      final List meals = json.decode(response1.body)['meals'];

      for (var meal in meals) {
        homeItems.add(HomeItem.fromJson(meal));
      }
    }
    final response2 = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response2.statusCode == 200) {
      final List meals = json.decode(response2.body)['meals'];

      for (var meal in meals) {
        homeItems.add(HomeItem.fromJson(meal));
      }
      final response3 = await http
          .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

      if (response3.statusCode == 200) {
        final List meals = json.decode(response3.body)['meals'];

        for (var meal in meals) {
          homeItems.add(HomeItem.fromJson(meal));
        }

        final response4 = await http.get(
            Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

        if (response4.statusCode == 200) {
          final List meals = json.decode(response4.body)['meals'];

          for (var meal in meals) {
            homeItems.add(HomeItem.fromJson(meal));
          }
        }
        final response5 = await http.get(
            Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

        if (response5.statusCode == 200) {
          final List meals = json.decode(response5.body)['meals'];

          for (var meal in meals) {
            homeItems.add(HomeItem.fromJson(meal));
          }
        }
      }

      return homeItems;
    } else {
      throw Exception('Failed to load home items');
    }
  }
}
