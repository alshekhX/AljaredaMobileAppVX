import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:calendar_time/calendar_time.dart';

import 'package:flutter/material.dart';

import '../models/Article.dart';
import '../models/CrossGame.dart';

class ArticlePrvider with ChangeNotifier {
  List? articles;
  List? journlists;
  List? journlistArticles;
  List? searchedArticles;
  List? savedArticles;
  List? games;

  ArticleModel? article;
  String? articleHtmlText;
  String? articleType;
  String? category;

  // ignore: unnecessary_new
  BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.43.250:8000",
    connectTimeout: 150000,
    receiveTimeout: 150000,
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  getArticles() async {
    try {
      String gte = 'gte';
      String lte = 'lte';

      //Dio option config

      var calendarTime = CalendarTime(DateTime.now());

      var dayBefore = calendarTime.startOfToday.subtract(Duration(days: 1));
      var dayEnd = calendarTime.endOfToday;

      print(calendarTime.startOfToday);

      Dio dio = Dio(options);

      // Response response = await dio.get("/api/v1/articles", queryParameters: {
      //   'createdAt': {"$gte": "$dayBefore", "\$$lte": "$dayEnd"}
      // });

      Response response = await dio.get(
        "/api/v1/articles",
      );
      if (response.statusCode == 200) {
        final map = response.data['data'];

        articles = map.map((i) => ArticleModel.fromMap(i)).toList();
        // DateTime
        return 'success';
      } else {
        String error = response.data['errorMessage'].toString();
        return error;
      }
    } catch (e) {
      return e.toString();
    }
  }

  getJournlistArticles(String id, String token) async {
    //Dio option config

    // var calendarTime = CalendarTime(DateTime.now());

    // var dayBefore = calendarTime.startOfToday.subtract(Duration(days: 1));
    // var dayEnd = calendarTime.endOfToday;

    Dio dio = Dio(options);
    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.get("/api/v1/articles/journlistarticles",
        queryParameters: {'user': id});
    if (response.statusCode == 200) {
      final map = response.data['data'];

      journlistArticles = map.map((i) => ArticleModel.fromMap(i)).toList();
      // DateTime

      return 'success';
    } else {
      String error = response.data['errorMessage'].toString();
      return error;
    }
  }

  getCategoryArticles(String token) async {
    try {
      //Dio option config

      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';
      Response response = await dio.get("/api/v1/articles", queryParameters: {
        'category': [category]
      });
      if (response.statusCode == 200) {
        final map = response.data['data'];

        articles = map.map((i) => ArticleModel.fromMap(i)).toList();
        return 'success';
      } else {
        String error = response.data['errorMessage'].toString();
        return error;
      }
    } catch (e) {
      return e.toString();
    }
  }

  getSearchedArticles(String title, String token) async {
    try {
      //Dio option config

      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';
      var regex = "regex";
      var optionss = "options";
      Response response = await dio.get("/api/v1/articles", queryParameters: {
        'title': {'\$$regex': title, "\$$optionss": 'i'}
      });
      if (response.statusCode == 200) {
        final map = response.data['data'];

        searchedArticles = map.map((i) => ArticleModel.fromMap(i)).toList();
        return 'success';
      } else {
        String error = response.data['errorMessage'].toString();
        return error;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getHtml(ArticleModel articleModel) async {
    Dio dio = Dio(options);

    Response htmlPage =
        await dio.get('/uploads/htmlarticles/' + articleModel.description!);
    articleHtmlText = htmlPage.data;
    return 'success';
  }

  getAllJournlists(String token) async {
    try {
      //Dio option config

      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';

      Response response = await dio
          .get("/api/v1/users", queryParameters: {'role': 'journlist'});
      if (response.statusCode == 200) {
        final map = response.data['data'];

        journlists = map.map((i) => User.fromMap(i)).toList();
        return 'success';
      } else {
        String error = response.data['errorMessage'].toString();
        return error;
      }
    } catch (e) {
      return e.toString();
    }
  }

  savedArticleToUser(String id, String token) async {
    try {
      //Dio option config
      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';
      Response response = await dio.put("/api/v1/users/savedArt/$id");
      print(response);
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'false';
      }
    } catch (e) {
      return e.toString();
    }
  }

  getAllGames(String token) async {
    //Dio option config

    Dio dio = Dio(options);
    dio.options.headers["authorization"] = 'Bearer $token';

    Response response = await dio.get("/api/v1/games/crossword");
    if (response.statusCode == 200) {
      final map = response.data['data'];

      games = map.map((i) => CrossWordM.fromMap(i)).toList();

      print(games);
      return 'success';
    } else {
      String error = response.data['errorMessage'].toString();
      return error;
    }
  }
}
