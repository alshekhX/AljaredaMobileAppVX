import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePageController{
SharedPreferences? prefs;
  bool? alredyLogged;
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;



  
MyHomePageController(){


}
  
  verifyuserToken(BuildContext context) async {
    try {
      await initializeDateFormatting('ar_SA', null);

      prefs = await SharedPreferences.getInstance();
      if (prefs!.getString('userToken') != null) {
        Provider.of<AuthProvider>(context, listen: false).token =
            prefs!.getString('userToken')!;

        await Provider.of<AuthProvider>(context, listen: false).getUserData();
        alredyLogged = true;
      } else {
        alredyLogged = false;
      }
    } catch (e) {
      alredyLogged = false;
    }
  }


  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
     
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
       
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    
  }

  
  loadSetting(BuildContext context) async {
    //TODO
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble('fontsize') != null &&
        prefs.getString('fontsizestring') != null) {
      Provider.of<Setting>(context, listen: false).fontSize =
          prefs.getDouble('fontsize')!;

      Provider.of<Setting>(context, listen: false).fontSizeString =
          prefs.getString('fontsizestring')!;
    } else {
      Provider.of<Setting>(context, listen: false).fontSize = .8;
      Provider.of<Setting>(context, listen: false).fontSizeString = "متوسط";
    }
  }




}