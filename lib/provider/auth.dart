import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import '../models/UserInfo.dart';

class AuthProvider with ChangeNotifier {
  String? articleType;
  UserInfo? user;
  String ?token;

  // ignore: unnecessary_new
  BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.43.250:8000",
    
    connectTimeout: 8000,
    receiveTimeout: 8000,
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  signIN(String email, String password) async {
    try {
      var dio = Dio(options);
      final url = '/api/v1/auth/login';
      print('$email');
      print('$password' + 'what');

      Response response = await dio.post(url, data: {
        "email":email,
        
        "password":password,
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        token = response.data['token'];
        print(token);

        await getUserData();
        return 'success';
      } else {
        return response.data["errorMessage"].toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  registerUser(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
  ) async {
    var dio = Dio(options);
    final url = '/api/v1/auth/register';
    try {
      Response response = await dio.post(url, data: {
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'email': email,
        'password': password,
      });
      print(response.data);
      if (response.statusCode == 201) {
        token = response.data['token'];
        print(token);

        await getUserData();
        return "success";
      } else {
        return response.data["errorMessage"].toString();
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  getUserData() async {
    Dio dio = Dio(options);

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/auth/me');

    final data = response.data['data'];
    user = UserInfo.fromMap(data);
    notifyListeners();
    print(user!.id);
  }
}
