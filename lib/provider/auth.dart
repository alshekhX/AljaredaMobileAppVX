import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import '../models/UserInfo.dart';
import '../utils/const.dart';

class AuthProvider with ChangeNotifier {
  String? articleType;
  UserInfo? user;
  String? token;

  // ignore: unnecessary_new
  // BaseOptions options = new BaseOptions(
  //   baseUrl: AljaredaConst.NetworkBaseUrL,

  //   connectTimeout: 8000,
  //   receiveTimeout: 8000,
  //   contentType: 'application/json',
  //   validateStatus: (status) {
  //     return status! < 600;
  //   },
  // );

  final Dio dio=AljaredaConst().GetdioX();

  signIN(String email, String password) async {
    try {
      const url = '/api/v1/auth/login';

      Response response = await dio.post(url, data: {
        "email": email,
        "password": password,
      });
      if (response.statusCode == 200) {
        token = response.data['token'];

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
   UserInfo user,String password
  ) async {

    const url = '/api/v1/auth/register';
    try {
      Response response = await dio.post(url, data: {
        'phone': user.phone,
        'userName': user.userName,
        'email': user.email,
        'password': password,
      });
      if (response.statusCode == 201) {
        token = response.data['token'];

        await getUserData();
        return "success";
      } else {
        return response.data["errorMessage"].toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  getUserData() async {

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/auth/me');

    final data = response.data['data'];
    user = UserInfo.fromMap(data);
    notifyListeners();
  }
}
