import 'dart:async';

import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/widgets/AppProgressBar.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/utils/utilMethod.dart';
import 'package:aljaredanews/widgets/navBar.dart';
import 'package:aljaredanews/widgets/todayPage/breakingNewsTem.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:weather/weather.dart';

class TodayController {
  bool? _isConnected;
  double? fontsize;
  Color wetherTextColor = Colors.black;
  DateTime today = new DateTime.now();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  bool isScrollingDown = false;
  List? articles;

  Position? position;
  WeatherFactory ws = WeatherFactory("21f03dbf900ab02e790545ccf84525c2",
      language: Language.ARABIC);
  Weather? weather;
  double? lat, lon;

  TodayController() {
  }

  void fontsizeSetting(BuildContext context) async {
    fontsize = Provider.of<Setting>(context, listen: false).fontSize;
    print(fontsize);
  }

  Future getWeather(BuildContext context) async {
    position = await Geolocator.getCurrentPosition();
    lat = position!.latitude;
    lon = position!.longitude;

    weather = await ws.currentWeatherByLocation(lat!, lon!);

    Provider.of<Setting>(context, listen: false).nightmode!
        ? wetherTextColor = Colors.white
        : wetherTextColor = Colors.black;
    if (weather!.temperature!.celsius!.floor() < 30) {
      wetherTextColor = Colors.lightBlue;
    }
    if (weather!.temperature!.celsius!.floor() <= 35 &&
        weather!.temperature!.celsius!.floor() >= 30) {
      wetherTextColor = Colors.orangeAccent.shade400;
    }
    if (weather!.temperature!.celsius!.floor() > 35 &&
        weather!.temperature!.celsius!.floor() <= 50) {
      wetherTextColor = Colors.red;
    }
  }





  

  RenderObjectWidget getBreakingNews(
      ArticlePrvider articleProv, BuildContext context, Size size) {
    try {
      articleProv.getArticles();
      List<Widget> breakingNewsList = [];

      for (int i = 0; i < articleProv.articles!.length; i++) {
        if (articleProv.articles![i].articletype[0] == 'breaking' &&
            today.difference(articleProv.articles![i].createdAt).inHours <= 1) {
          breakingNewsList.add(InkWell(
              onTap: () async {
                articleProv.article = articleProv.articles![i];

                // pushNewScreen(context,
                //     pageTransitionAnimation:
                //         PageTransitionAnimation.scale,
                //     screen: test(articleModel),
                //     withNavBar: false);
              },
              child: BreakingNewsTem(
                  context: context,
                  text: articleProv.articles![i].title,
                  size: size,
                  time: formatDate(articleProv.articles![i].createdAt,
                      [HH, ':', nn, '', am]))));
          breakingNewsList.add(Container(
            width: size.width * .9,
            child: Divider(
              color: Colors.red,
              thickness: 1.5,
            ),
          ));
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min, // Use children total size
        children: breakingNewsList,
      );
    } catch (e) {
      return Center(
          child: Container(
        width: 100,
        height: 200,
        child: Text('$e'),
      ));
    }
  }

  Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  String? customValidtaor(String? fieldContent) =>
      fieldContent!.isEmpty ? 'Ce champ est obligatoire.' : null;

  void dispose() {}

  getArticle(BuildContext context) async {
    String res =
        await Provider.of<ArticlePrvider>(context, listen: false).getArticles();
    print(res);
    if (res == 'success') {
      articles = Provider.of<ArticlePrvider>(context, listen: false).articles;
    }
  }

   onRefresh(BuildContext context) async {
    String internetConn = await UtilMethod().checkInternetConnection();

    if (internetConn == 'false') {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
        ),
      );
      refreshController.refreshFailed();
    } else {
      // monitor network fetch
      await getArticle(context); // if failed,use refreshFailed()
      refreshController.refreshCompleted();
    }
  }

  void onLoading() async {}
}
