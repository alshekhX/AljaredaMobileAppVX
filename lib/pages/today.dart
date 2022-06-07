import 'dart:async';
import 'dart:io';
import 'package:aljaredanews/widgets/todayPage/rawNewsTem.dart';
import 'package:calendar_time/calendar_time.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:date_format/date_format.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:weather/weather.dart';

import '../htmltest.dart';
import '../models/Article.dart';
import '../provider/articleProvider.dart';
import '../provider/settingProvider.dart';
import '../utils/adabtiveText.dart';
import '../widgets/todayPage/articleTemplete.dart';
import '../widgets/todayPage/breakingNewsTem.dart';
import '../widgets/todayPage/fullNewsTem.dart';
import '../widgets/todayPage/gameTemp.dart';
import '../widgets/todayPage/headLineTem.dart';
import '../widgets/todayPage/rawNewsHeadLine.dart';
import 'crossWord.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  Position? position;
  WeatherFactory ws = new WeatherFactory("21f03dbf900ab02e790545ccf84525c2",
      language: Language.ARABIC);
  Weather? weather;
  double? lat, lon;

  Future getWeather() async {
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

    setState(() {});
  }

  bool? _isConnected;
  double? fontsize;
  Color wetherTextColor = Colors.black;

  ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  List? articles;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void fontsizeSetting() async {
    fontsize = Provider.of<Setting>(context, listen: false).fontSize;
    print(fontsize);
  }

  DateTime today = new DateTime.now();
  @override
  void initState() {
    fontsizeSetting();

    getWeather();

    wait();

    super.initState();
    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController!.dispose();
    _scrollViewController!.removeListener(() {});
    super.dispose();
  }

  wait() {
    _timer = new Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        getArticle();
      });
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<bool> _onWillPop() async {
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

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    var dayformated = intl.DateFormat.MMMEd('ar_SA').format(date);

    /// e.g Thursday

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              height: _showAppbar ? 56.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Center(
                  child: Text(
                    'الجريدة',
                    style: TextStyle(
                      fontFamily: 'Elmiss',
                      fontWeight: FontWeight.w600,
                      fontSize:
                          AdaptiveTextSize().getadaptiveTextSize(context, 40),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TimerBuilder.periodic(
                Duration(seconds: 300),
                builder: (context) {
                  return SmartRefresher(
                      scrollController: _scrollViewController,
                      enablePullDown: true,
                      enablePullUp: false,
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      header: MaterialClassicHeader(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                      ),
                      child: (articles != null)
                          ? SingleChildScrollView(
                              child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Use children total size
                                  children: [
                                    //breaking news
                                    Consumer<ArticlePrvider>(
                                        builder: (context, articleProv, _) {
                                      try {
                                        articleProv.getArticles();
                                        List<Widget> breakingNewsList = [];

                                        for (int i = 0;
                                            i < articles!.length;
                                            i++) {
                                          if (articles![i].articletype[0] ==
                                                  'breaking' &&
                                              today
                                                      .difference(articles![i]
                                                          .createdAt)
                                                      .inHours <=
                                                  1) {
                                            breakingNewsList.add(InkWell(
                                                onTap: () async {
                                                  articleProv.article =
                                                      articles![i];

                                                  // pushNewScreen(context,
                                                  //     pageTransitionAnimation:
                                                  //         PageTransitionAnimation.scale,
                                                  //     screen: test(articleModel),
                                                  //     withNavBar: false);
                                                },
                                                child: BreakingNewsTem(
                                                    context: context,
                                                    text: articles![i].title,
                                                    size: size,
                                                    time: formatDate(
                                                        articles![i].createdAt,
                                                        [
                                                          HH,
                                                          ':',
                                                          nn,
                                                          '',
                                                          am
                                                        ]))));
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
                                          mainAxisSize: MainAxisSize
                                              .min, // Use children total size
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
                                    }),

                                    SizedBox(
                                      height: size.height * .02,
                                    ),
                                    Container(
                                        width: size.width * .95,
                                        child: Divider(
                                          thickness: 2,
                                          color: Provider.of<Setting>(context,
                                                      listen: false)
                                                  .nightmode!
                                              ? Colors.grey.shade400
                                              : Colors.black,
                                        )),
                                    Container(
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          reverse: true,
                                          scrollDirection: Axis.horizontal,
                                          //headlines consumer
                                          child: Consumer<ArticlePrvider>(
                                              builder:
                                                  (context, artProvider, _) {
                                            List<Widget> headLineRow = [];
                                            headLineRow.add(
                                              InkWell(
                                                onTap: () {
                                                  pushNewScreen(context,
                                                      pageTransitionAnimation:
                                                          PageTransitionAnimation
                                                              .scale,
                                                      screen: CrossWords(),
                                                      withNavBar: false);
                                                },
                                                child: Game(
                                                    context: context,
                                                    imageUrl:
                                                        "assets/cross.png",
                                                    text: "",
                                                    size: size),
                                              ),
                                            );

                                            for (int i = 0;
                                                i < articles!.length;
                                                i++) {
                                              if (articles![i].photo !=
                                                      'no_photo.jpg' &&
                                                  articles![i].articletype[0] !=
                                                      'breaking') {
                                                headLineRow.add(InkWell(
                                                    onTap: () async {
                                                      artProvider.article =
                                                          articles![i];
                                                      ArticleModel
                                                          articleModel =
                                                          articles![i];
                                                      //TODO
                                                      pushNewScreen(context,
                                                          pageTransitionAnimation:
                                                              PageTransitionAnimation
                                                                  .scale,
                                                          screen: test(
                                                              articleModel),
                                                          withNavBar: false);
                                                    },
                                                    child: HeadLine(
                                                        context: context,
                                                        imageUrl:
                                                            'http://192.168.43.250:8000/uploads/photos/' +
                                                                articles![i]
                                                                    ?.photo,
                                                        text:
                                                            articles![i].title,
                                                        size: size)));
                                              } else if (articles![i].photo ==
                                                      'no_photo.jpg' &&
                                                  articles![i].articletype[0] !=
                                                      'breaking') {
                                                headLineRow.add(InkWell(
                                                    onTap: () async {
                                                      artProvider.article =
                                                          articles![i];
                                                      ArticleModel
                                                          articleModel =
                                                          articles![i];

                                                      pushNewScreen(context,
                                                          pageTransitionAnimation:
                                                              PageTransitionAnimation
                                                                  .scale,
                                                          screen: test(
                                                              articleModel),
                                                          withNavBar: false);
                                                    },
                                                    child: RawNewsHLine(
                                                        context: context,
                                                        text:
                                                            articles![i].title,
                                                        color: Colors.black,
                                                        size: size)));
                                              }
                                            }
                                            headLineRow.add(
                                              Center(
                                                  child: Stack(
                                                children: [
                                                  Container(
                                                      height: size.height * 0.2,
                                                      margin: EdgeInsets.only(
                                                          left: 5, right: 5),
                                                      decoration: BoxDecoration(
                                                          color: Provider.of<Setting>(context, listen: false)
                                                                  .nightmode!
                                                              ? Colors.blueGrey
                                                                  .shade800
                                                              : Colors
                                                                  .grey.shade200
                                                                  .withOpacity(
                                                                      .8),
                                                          border: Border.all(
                                                              color: Provider.of<Setting>(
                                                                          context,
                                                                          listen: false)
                                                                      .nightmode!
                                                                  ? Colors.grey.shade200
                                                                  : Colors.black,
                                                              width: 1)),
                                                      width: size.width * 0.73,
                                                      child: AnimatedTextKit(
                                                        animatedTexts: [
                                                          TyperAnimatedText(
                                                            'عناوين اليوم',
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: AdaptiveTextSize()
                                                                  .getadaptiveTextSizeSetting(
                                                                      context,
                                                                      40,
                                                                      Provider.of<Setting>(
                                                                              context)
                                                                          .fontSize),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            speed:
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                          ),
                                                        ],
                                                        totalRepeatCount: 1,
                                                        pause: const Duration(
                                                            milliseconds: 150),
                                                        displayFullTextOnTap:
                                                            true,
                                                        stopPauseOnTap: true,
                                                      )
                                                      //  Text(
                                                      //   'عناوين اليوم',
                                                      //   style: TextStyle(
                                                      //     fontSize: AdaptiveTextSize()
                                                      //         .getadaptiveTextSizeSetting(
                                                      //             context,
                                                      //             40,
                                                      //             Provider.of<Setting>(
                                                      //                     context)
                                                      //                 .fontSize),
                                                      //   ),
                                                      //   textAlign:
                                                      //       TextAlign.center,
                                                      // ),
                                                      ),
                                                  Positioned(
                                                      child: Column(
                                                        children: [
                                                          weather == null
                                                              ? Text('',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                                                        context,
                                                                        18,
                                                                        Provider.of<Setting>(context)
                                                                            .fontSize),
                                                                  ))
                                                              : AnimatedTextKit(
                                                                  animatedTexts: [
                                                                    TyperAnimatedText(
                                                                      '${weather!.temperature!.celsius!.floor()} درجة مئوية',
                                                                      textStyle:
                                                                          TextStyle(
                                                                        color:
                                                                            wetherTextColor,
                                                                        fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                                                            context,
                                                                            18,
                                                                            Provider.of<Setting>(context).fontSize),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      speed: const Duration(
                                                                          milliseconds:
                                                                              200),
                                                                    ),
                                                                  ],
                                                                  totalRepeatCount:
                                                                      1,
                                                                  pause: const Duration(
                                                                      milliseconds:
                                                                          150),
                                                                  displayFullTextOnTap:
                                                                      true,
                                                                  stopPauseOnTap:
                                                                      true,
                                                                ),

                                                          // Text(
                                                          //     '${weather.temperature.celsius.floor()} درجة مئوية',
                                                          //     style:
                                                          //         TextStyle(
                                                          //       fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                                          //           context,
                                                          //           18,
                                                          //           Provider.of<Setting>(context)
                                                          //               .fontSize),
                                                          //     ),
                                                          //     textDirection:
                                                          //         TextDirection
                                                          //             .rtl,
                                                          //   )
                                                        ],
                                                      ),
                                                      left: size.width * .04,
                                                      bottom:
                                                          size.height * .035),
                                                  Positioned(
                                                      child: Column(
                                                        children: [
                                                          weather == null
                                                              ? Text('',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                                                        context,
                                                                        18,
                                                                        Provider.of<Setting>(context)
                                                                            .fontSize),
                                                                  ))
                                                              : AnimatedTextKit(
                                                                  animatedTexts: [
                                                                    TyperAnimatedText(
                                                                      '${weather!.weatherDescription}',
                                                                      textStyle:
                                                                          TextStyle(
                                                                        fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                                                            context,
                                                                            18,
                                                                            Provider.of<Setting>(context).fontSize),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      speed: const Duration(
                                                                          milliseconds:
                                                                              200),
                                                                    ),
                                                                  ],
                                                                  totalRepeatCount:
                                                                      1,
                                                                  pause: const Duration(
                                                                      milliseconds:
                                                                          150),
                                                                  displayFullTextOnTap:
                                                                      true,
                                                                  stopPauseOnTap:
                                                                      true,
                                                                ),
                                                          //  Text(
                                                          //     '${weather.weatherDescription}',
                                                          //     style:
                                                          //         TextStyle(
                                                          //       fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                                          //           context,
                                                          //           18,
                                                          //           Provider.of<Setting>(context)
                                                          //               .fontSize),
                                                          //     ),
                                                          //     textDirection:
                                                          //         TextDirection
                                                          //             .rtl,
                                                          //   )
                                                        ],
                                                      ),
                                                      left: size.width * .04,
                                                      bottom:
                                                          size.height * .01),
                                                  Positioned(
                                                    child: Container(
                                                        child: AnimatedTextKit(
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                          '${dayformated}',
                                                          textStyle: TextStyle(
                                                            fontSize: AdaptiveTextSize()
                                                                .getadaptiveTextSizeSetting(
                                                                    context,
                                                                    18,
                                                                    Provider.of<Setting>(
                                                                            context)
                                                                        .fontSize),
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          speed: const Duration(
                                                              milliseconds:
                                                                  200),
                                                        ),
                                                      ],
                                                      totalRepeatCount: 1,
                                                      pause: const Duration(
                                                          milliseconds: 150),
                                                      displayFullTextOnTap:
                                                          true,
                                                      stopPauseOnTap: true,
                                                    )),

                                                    //    Text(
                                                    //     'السبت',
                                                    //     style: TextStyle(
                                                    //       fontSize: AdaptiveTextSize()
                                                    //           .getadaptiveTextSizeSetting(
                                                    //               context,
                                                    //               18,
                                                    //               Provider.of<Setting>(
                                                    //                       context)
                                                    //                   .fontSize),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    right: size.width * .04,
                                                    bottom: size.height * .035,
                                                  ),
                                                  Positioned(
                                                      right: size.width * .36,
                                                      bottom: size.height * .09,
                                                      child: AnimatedTextKit(
                                                        animatedTexts: [
                                                          TyperAnimatedText(
                                                            '<<<',
                                                            textStyle:
                                                                TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: AdaptiveTextSize()
                                                                  .getadaptiveTextSizeSetting(
                                                                      context,
                                                                      26,
                                                                      Provider.of<Setting>(
                                                                              context)
                                                                          .fontSize),
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                            speed:
                                                                const Duration(
                                                                    milliseconds:
                                                                        600),
                                                          ),
                                                        ],
                                                        repeatForever: true,
                                                        pause: const Duration(
                                                            milliseconds: 400),
                                                        displayFullTextOnTap:
                                                            true,
                                                        stopPauseOnTap: true,
                                                      ))
                                                ],
                                              )),
                                            );

                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: headLineRow,
                                            );
                                          }),
                                        )),

                                    SizedBox(
                                      height: size.height * .02,
                                    ),
                                    Container(
                                        width: size.width * .95,
                                        child: Divider(
                                          thickness: 2.0,
                                          color: Provider.of<Setting>(context,
                                                      listen: false)
                                                  .nightmode!
                                              ? Colors.grey.shade400
                                              : Colors.black,
                                        )),
                                    SizedBox(
                                      height: size.height * .02,
                                    ),

                                    Row(
                                      children: [
                                        Spacer(),
                                        Container(
                                          // decoration: BoxDecoration(border: Border.all(width: 3,)),
                                          margin: EdgeInsets.only(
                                              right: size.width * .03),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: BorderedText(
                                              strokeWidth: 3,
                                              strokeColor: Colors.black,
                                              child: Text(
                                                'أخبار اليوم',
                                                style: TextStyle(
                                                  color: Colors.lightBlue[100],
                                                  fontSize: AdaptiveTextSize()
                                                      .getadaptiveTextSizeSetting(
                                                          context,
                                                          50,
                                                          fontsize!),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * .01,
                                    ),
                                    Consumer<ArticlePrvider>(
                                        //no images news
                                        builder: (context, articleProv, _) {
                                      articles!.sort((a, b) {
                                        var adate = a
                                            .createdAt; //before -> var adate = a.expiry;
                                        var bdate = b
                                            .createdAt; //before -> var bdate = b.expiry;
                                        return bdate.compareTo(
                                            adate); //to get the order other way just switch `adate & bdate`
                                      });
                                      try {
                                        List<Widget> rawNewsColumn = [];

                                        for (int i = 0;
                                            i < articles!.length;
                                            i++) {
                                          if (articles![i].articletype[0] ==
                                                  'news' 
                                                  ) {
                                            rawNewsColumn.add(Container(
                                              width: size.width * .9,
                                              child: Divider(
                                                color: Provider.of<Setting>(
                                                            context,
                                                            listen: false)
                                                        .nightmode!
                                                    ? Colors.grey.shade500
                                                    : Colors.black,
                                                thickness: 2,
                                              ),
                                            ));
                                            rawNewsColumn.add(InkWell(
                                                onTap: () async {
                                                  articleProv.article =
                                                      articles![i];
                                                  ArticleModel articleModel =
                                                      articles![i];

                                                  pushNewScreen(context,
                                                      pageTransitionAnimation:
                                                          PageTransitionAnimation
                                                              .scale,
                                                      screen:
                                                          test(articleModel),
                                                      withNavBar: false);
                                                },
                                                child: RawNews(
                                                  context: context,
                                                  text: articles![i].title,
                                                  size: size,
                                                  arthur:
                                                      '${articles![i].user.firstName} ${articles![i].user.lastName}',
                                                  place: articles![i].place,
                                                  id: articles![i].id,
                                                  assets: articles![i].assets,
                                                )));
                                          }

                                          // if (articles![i].articletype[0] ==
                                          //         'news' &&
                                          //     articles![i].photo !=
                                          //         'no_photo.jpg') {
                                          //   rawNewsColumn.add(InkWell(
                                          //       onTap: () async {
                                          //         articleProv.article =
                                          //             articles![i];
                                          //         ArticleModel articleModel =
                                          //             articles![i];

                                          //         pushNewScreen(context,
                                          //             pageTransitionAnimation:
                                          //                 PageTransitionAnimation
                                          //                     .scale,
                                          //             screen:
                                          //                 test(articleModel),
                                          //             withNavBar: false);
                                          //       },
                                          //       child: FullNews(
                                          //         context: context,
                                          //         imageUrl:
                                          //             'http://192.168.43.250:8000/uploads/photos/' +
                                          //                 articles![i].photo,
                                          //         headline: articles![i].title,
                                          //         arthur:
                                          //             '${articles![i].user.firstName} ${articles![i].user.lastName}',
                                          //         place: articles![i].place,
                                          //         size: size,
                                          //         color: Colors.black,
                                          //         opacity: 1,
                                          //         id: articles![i].id,
                                          //       )));
                                          // }
                                        }
                                        rawNewsColumn.add(Container(
                                          width: size.width * .98,
                                          child: Divider(
                                            color: Provider.of<Setting>(context,
                                                        listen: false)
                                                    .nightmode!
                                                ? Colors.grey.shade500
                                                : Colors.black,
                                            thickness: 2,
                                          ),
                                        ));

                                        return Column(
                                          mainAxisSize: MainAxisSize
                                              .min, // Use children total size
                                          children: rawNewsColumn,
                                        );
                                        // return Container(
                                        //   height: 300,
                                        //   child: ListView.builder(
                                        //     itemBuilder: (context, index) {
                                        //       return Container(
                                        //         child: article(
                                        //             'http://192.168.43.250:8000/uploads/photos/' +
                                        //                 articles[index].photo,
                                        //             '',
                                        //             articles[index].title,
                                        //             '${articles[index].user.firstName} ${articles[index].user.lastName}',
                                        //             '',
                                        //             size),
                                        //       );
                                        //     },
                                        //     itemCount: articles.length,
                                        //   ),
                                        // );

                                      } catch (e) {
                                        return Center(
                                            child: Container(
                                          width: 100,
                                          height: 200,
                                          child: Text('error'),
                                        ));
                                      }
                                    }),

                                    //news provider
                                    // Consumer<ArticlePrvider>(
                                    //     //image news
                                    //     builder: (context, articleProv, _) {
                                    //   articles!.sort((a, b) {
                                    //     var adate = a
                                    //         .createdAt; //before -> var adate = a.expiry;
                                    //     var bdate = b
                                    //         .createdAt; //before -> var bdate = b.expiry;
                                    //     return bdate.compareTo(
                                    //         adate); //to get the order other way just switch `adate & bdate`
                                    //   });
                                    //   try {
                                    //     List<Widget> newsColumn = [];

                                    //     for (int i = 0;
                                    //         i < articles!.length;
                                    //         i++) {
                                    //       if (articles![i].articletype[0] ==
                                    //               'news' &&
                                    //           articles![i].photo !=
                                    //               'no_photo.jpg') {
                                    //         newsColumn.add(InkWell(
                                    //             onTap: () async {
                                    //               articleProv.article =
                                    //                   articles![i];
                                    //               ArticleModel articleModel =
                                    //                   articles![i];

                                    //               pushNewScreen(context,
                                    //                   pageTransitionAnimation:
                                    //                       PageTransitionAnimation
                                    //                           .scale,
                                    //                   screen:
                                    //                       test(articleModel),
                                    //                   withNavBar: false);
                                    //             },
                                    //             child: FullNews(
                                    //               context: context,
                                    //               imageUrl:
                                    //                   'http://192.168.43.250:8000/uploads/photos/' +
                                    //                       articles![i].photo,
                                    //               headline: articles![i].title,
                                    //               arthur:
                                    //                   '${articles![i].user.firstName} ${articles![i].user.lastName}',
                                    //               place: articles![i].place,
                                    //               size: size,
                                    //               color: Colors.black,
                                    //               opacity: 1,
                                    //               id: articles![i].id,
                                    //             )));
                                    //       }
                                    //     }

                                    //     return Column(
                                    //       mainAxisSize: MainAxisSize
                                    //           .min, // Use children total size
                                    //       children: newsColumn,
                                    //     );
                                    //   } catch (e) {
                                    //     return Center(
                                    //         child: Container(
                                    //       width: 100,
                                    //       height: 200,
                                    //       child: Text('error'),
                                    //     ));
                                    //   }
                                    // }),

                                    SizedBox(
                                      height: size.height * .03,
                                    ),

                                    Row(
                                      children: [
                                        Spacer(),
                                        Container(
                                          // decoration: BoxDecoration(border: Border.all(width: 3,)),
                                          margin: EdgeInsets.only(
                                              right: size.width * .03),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 20, 10),
                                            child: Center(
                                              child: BorderedText(
                                                strokeWidth: 3,
                                                strokeColor: Colors.black,
                                                child: Text(
                                                  'مقالات اليوم',
                                                  style: TextStyle(
                                                    color:
                                                        Colors.lightBlue[100],
                                                    fontSize: AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      child: Column(
                                        children: [
                                          //articles
                                          Consumer<ArticlePrvider>(builder:
                                              (context, articleProv, _) {
                                            try {
                                              articles!.sort((a, b) {
                                                var adate = a
                                                    .createdAt; //before -> var adate = a.expiry;
                                                var bdate = b
                                                    .createdAt; //before -> var bdate = b.expiry;
                                                return bdate.compareTo(
                                                    adate); //to get the order other way just switch `adate & bdate`
                                              });
                                              List<Widget> articlesColumn = [];

                                              for (int i = 0;
                                                  i < articles!.length;
                                                  i++) {
                                                if (articles![i]
                                                        .articletype[0] ==
                                                    'article') {
                                                  articlesColumn.add(InkWell(
                                                    onTap: () async {
                                                      articleProv.article =
                                                          articles![i];
                                                      ArticleModel
                                                          articleModel =
                                                          articles![i];

                                                      pushNewScreen(context,
                                                          pageTransitionAnimation:
                                                              PageTransitionAnimation
                                                                  .scale,
                                                          screen: test(
                                                              articleModel),
                                                          withNavBar: false);
                                                    },
                                                    child: ArticleWidget(
                                                      context: context,
                                                      imageUrl:
                                                          'http://192.168.43.250:8000/uploads/photos/' +
                                                              articles![i]
                                                                  .photo,
                                                      title: '',
                                                      headline:
                                                          articles![i].title,
                                                      arthur:
                                                          '${articles![i].user.firstName} ${articles![i].user.lastName}',
                                                      description: '',
                                                      size: size,
                                                      category: articles![i]
                                                          .category[0],
                                                      id: articles![i].id,
                                                      userPhoto: articles![i]
                                                          .user
                                                          .photo,
                                                    ),
                                                  ));
                                                }
                                              }

                                              return Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Use children total size
                                                children: articlesColumn,
                                              );
                                              // return Container(
                                              //   height: 300,
                                              //   child: ListView.builder(
                                              //     itemBuilder: (context, index) {
                                              //       return Container(
                                              //         child: article(
                                              //             'http://192.168.43.250:8000/uploads/photos/' +
                                              //                 articles[index].photo,
                                              //             '',
                                              //             articles[index].title,
                                              //             '${articles[index].user.firstName} ${articles[index].user.lastName}',
                                              //             '',
                                              //             size),
                                              //       );
                                              //     },
                                              //     itemCount: articles.length,
                                              //   ),
                                              // );

                                            } catch (e) {
                                              return Center(
                                                  child: Container(
                                                width: 100,
                                                height: 200,
                                                child: Text('error'),
                                              ));
                                            }
                                          }),
                                          SizedBox(
                                            height: size.height * .05,
                                          ),
                                          Container(
                                              width: size.width * .95,
                                              child: Divider(
                                                thickness: 2,
                                                color: Provider.of<Setting>(
                                                            context,
                                                            listen: false)
                                                        .nightmode!
                                                    ? Colors.grey.shade500
                                                    : Colors.black,
                                              )),
                                          Center(
                                            child: Container(
                                                child: InkWell(
                                              onTap: () {
                                                pushNewScreen(
                                                  context,
                                                  screen: CrossWords(),
                                                  withNavBar:
                                                      false, // OPTIONAL VALUE. True by default.
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .fade,
                                                );
                                              },
                                              child: Game(
                                                  context: context,
                                                  imageUrl: "assets/cross.png",
                                                  text: "الكلمات المتقاطعة",
                                                  size: size),
                                            )),
                                          ),
                                          Container(
                                              width: size.width * .95,
                                              child: Divider(
                                                thickness: 2.0,
                                                color: Provider.of<Setting>(
                                                            context,
                                                            listen: false)
                                                        .nightmode!
                                                    ? Colors.grey.shade500
                                                    : Colors.black,
                                              ))
                                        ],
                                      ),
                                    )
                                  ]),
                            )
                          : Center(
                              child: Container(
                              child: LoadingFlipping.circle(),
                            )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getArticle() async {
    String res =
        await Provider.of<ArticlePrvider>(context, listen: false).getArticles();
    print(res);
    if (res == 'success') {
      articles = Provider.of<ArticlePrvider>(context, listen: false).articles;

      setState(() {});
    }
  }

  Future<String> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
        return 'success';
      }
      return 'success';
    } on SocketException catch (err) {
      return 'false';
    }
  }

  void _onRefresh() async {
    String internetConn = await _checkInternetConnection();

    if (internetConn == 'false') {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
        ),
      );
      _refreshController.refreshFailed();
    } else {
      // monitor network fetch
      await getArticle(); // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {}
}
