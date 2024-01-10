import 'dart:async';
import 'package:aljaredanews/MainWidgets/DynamicAppBar.dart';
import 'package:aljaredanews/screens/today/CustomDivider.dart';
import 'package:aljaredanews/screens/today/todayC.dart';
import 'package:aljaredanews/screens/today/widget/HeadBox.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:aljaredanews/widgets/todayPage/rawNewsTem.dart';

import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../ArticleHtml/htmltext.dart';
import '../../models/Article.dart';
import '../../provider/articleProvider.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';
import '../../widgets/todayPage/articleTemplete.dart';
import '../../widgets/todayPage/gameTemp.dart';
import '../../widgets/todayPage/headLineTem.dart';
import '../../widgets/todayPage/rawNewsHeadLine.dart';
import '../crossWord.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  Timer? _timer;

  late TodayController controller;

  DateTime today = new DateTime.now();
  @override
  void initState() {
    controller = TodayController();
    controller.fontsizeSetting(context);
    controller.getWeather(context);
    wait();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  wait() async {
    _timer = Timer(const Duration(milliseconds: 1000), () async {});
    await controller.getArticle(context);

    setState(() {});
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
            Expanded(
                child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              controller: controller.refreshController,
              onRefresh: () async {
                await controller.onRefresh(context);
                setState(() {
                  
                });
              },
              header: MaterialClassicHeader(
                color: Colors.black,
              ),
              child: CustomScrollView(
                slivers: [
                  const DynamicAppBar(),
                  SliverToBoxAdapter(
                    child: (controller.articles != null)
                        ? SingleChildScrollView(
                            child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Use children total size
                                children: [
                                  //breaking news
                                  Consumer<ArticlePrvider>(
                                      builder: (context, articleProv, _) {
                                    return controller.getBreakingNews(
                                        articleProv, context, size);
                                  }),

                                  Gap(
                                    size.height * .02,
                                  ),

                                  CustomDivider(size: size),
                                  //Today Row
                                  SizedBox(
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        reverse: true,
                                        scrollDirection: Axis.horizontal,
                                        //headlines consumer
                                        child: Consumer<ArticlePrvider>(
                                            builder: (context, artProvider, _) {
                                          return getHeadLinesRow(context, size,
                                              artProvider, dayformated);
                                        }),
                                      )),

                                  SizedBox(
                                    height: size.height * .02,
                                  ),
                                  CustomDivider(size: size),
                                  SizedBox(
                                    height: size.height * .02,
                                  ),

                                  Row(
                                    children: [
                                      Spacer(),
                                      MainTitle(
                                        fontSize: controller.fontsize!,
                                        text: 'أخبار اليوم',
                                      ),
                                    ],
                                  ),
                                  Gap(
                                    size.height * .01,
                                  ),

//news consumer
                                  Consumer<ArticlePrvider>(
                                      builder: (context, articleProv, _) {
                                    return getNews(articleProv, context, size);
                                  }),

                                  Gap(
                                    size.height * .03,
                                  ),

                                  Row(
                                    children: [
                                      Spacer(),
                                      MainTitle(
                                          fontSize: controller.fontsize!,
                                          text: 'مقالات اليوم')
                                    ],
                                  ),
//articles
                                  Container(
                                    child: Column(
                                      children: [
                                        //articles
                                        Consumer<ArticlePrvider>(
                                            builder: (context, articleProv, _) {
                                          return getArticles(
                                              articleProv, context, size);
                                        }),

                                        Gap(
                                          2.h,
                                        ),
                                  CustomDivider(size: size),
                                        Center(
                                          child: Container(
                                              child: InkWell(
                                            onTap: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreen(
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
                                            ),
                                          )),
                                        ),
                                  CustomDivider(size: size)
                                      ],
                                    ),
                                  )
                                ]),
                          )
                        : Center(
                            child: Container(
                            height: 80.h,
                            child: LoadingFlipping.circle(),
                          )),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  //UImethods

  RenderObjectWidget getArticles(
      ArticlePrvider articleProv, BuildContext context, Size size) {
    try {
      articleProv.articles!.sort((a, b) {
        var adate = a.createdAt; //before -> var adate = a.expiry;
        var bdate = b.createdAt; //before -> var bdate = b.expiry;
        return bdate.compareTo(
            adate); //to get the order other way just switch `adate & bdate`
      });
      List<Widget> articlesColumn = [];

      for (int i = 0; i < articleProv.articles!.length; i++) {
        if (articleProv.articles![i].articletype[0] == 'article') {
          articlesColumn.add(InkWell(
            onTap: () async {
              articleProv.article = articleProv.articles![i];
              ArticleModel articleModel = articleProv.articles![i];

              PersistentNavBarNavigator.pushNewScreen(context,
                  pageTransitionAnimation: PageTransitionAnimation.scale,
                  screen: HtmlText(articleModel),
                  withNavBar: false);
            },
            child: ArticleWidget(
              context: context,
              imageUrl:
                  AljaredaConst.BasePicUrl + articleProv.articles![i].photo,
              title: '',
              headline: articleProv.articles![i].title,
              arthur:
                  '${articleProv.articles![i].user.firstName} ${articleProv.articles![i].user.lastName}',
              description: '',
              size: size,
              category: articleProv.articles![i].category[0],
              id: articleProv.articles![i].id,
              userPhoto: articleProv.articles![i].user.photo,
            ),
          ));
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min, // Use children total size
        children: articlesColumn,
      );
    } catch (e) {
      return Center(
          child: Container(
        width: 100,
        height: 200,
        child: Text('error'),
      ));
    }
  }

  RenderObjectWidget getNews(
      ArticlePrvider articleProv, BuildContext context, Size size) {
    articleProv.articles!.sort((a, b) {
      var adate = a.createdAt; //before -> var adate = a.expiry;
      var bdate = b.createdAt; //before -> var bdate = b.expiry;
      return bdate.compareTo(
          adate); //to get the order other way just switch `adate & bdate`
    });
    try {
      List<Widget> rawNewsColumn = [];

      for (int i = 0; i < articleProv.articles!.length; i++) {
        if (articleProv.articles![i].articletype[0] == 'news') {
          rawNewsColumn.add(InkWell(
              onTap: () async {
                articleProv.article = articleProv.articles![i];
                ArticleModel articleModel = articleProv.articles![i];

                PersistentNavBarNavigator.pushNewScreen(context,
                    pageTransitionAnimation: PageTransitionAnimation.scale,
                    screen: HtmlText(articleModel),
                    withNavBar: false);
              },
              child: RawNews(
                context: context,
                text: articleProv.articles![i].title,
                size: size,
                arthur:
                    '${articleProv.articles![i].user.firstName} ${articleProv.articles![i].user.lastName}',
                place: articleProv.articles![i].place,
                id: articleProv.articles![i].id,
                assets: articleProv.articles![i].assets,
              )));
          rawNewsColumn.add(CustomDivider(size: size));
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min, // Use children total size
        children: rawNewsColumn,
      );
    } catch (e) {
      return Center(
          child: Container(
        width: 100,
        height: 200,
        child: Text('error'),
      ));
    }
  }

  Row getHeadLinesRow(BuildContext context, Size size,
      ArticlePrvider artProvider, String dayformated) {
    List<Widget> headLineRow = [];
    headLineRow.add(
      InkWell(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(context,
              pageTransitionAnimation: PageTransitionAnimation.scale,
              screen: CrossWords(),
              withNavBar: false);
        },
        child: Game(
          context: context,
          imageUrl: "assets/cross.png",
          text: "",
        ),
      ),
    );

    for (int i = 0; i < artProvider.articles!.length; i++) {
      if (artProvider.articles![i].photo != 'no_photo.jpg' &&
          artProvider.articles![i].articletype[0] != 'breaking') {
        headLineRow.add(InkWell(
            onTap: () async {
              artProvider.article = artProvider.articles![i];
              ArticleModel articleModel = artProvider.articles![i];
              //TODO
              PersistentNavBarNavigator.pushNewScreen(context,
                  pageTransitionAnimation: PageTransitionAnimation.scale,
                  screen: HtmlText(articleModel),
                  withNavBar: false);
            },
            child: HeadLine(
              context: context,
              imageUrl:
                  AljaredaConst.BasePicUrl + artProvider.articles![i]?.photo,
              text: artProvider.articles![i].title,
            )));
      } else if (artProvider.articles![i].photo == 'no_photo.jpg' &&
          artProvider.articles![i].articletype[0] != 'breaking') {
        headLineRow.add(InkWell(
            onTap: () async {
              artProvider.article = artProvider.articles![i];
              ArticleModel articleModel = artProvider.articles![i];

              PersistentNavBarNavigator.pushNewScreen(context,
                  pageTransitionAnimation: PageTransitionAnimation.scale,
                  screen: HtmlText(articleModel),
                  withNavBar: false);
            },
            child: RawNewsHLine(
                context: context,
                text: artProvider.articles![i].title,
                color: Colors.black,
                size: size)));
      }
    }

    headLineRow.add(
      HeadBox(size: size, controller: controller, dayformated: dayformated),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: headLineRow,
    );
  }
}

class MainTitle extends StatelessWidget {
  const MainTitle({
    Key? key,
    required this.text,
    required this.fontSize,
  }) : super(key: key);

  final String text;

  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(width: 3,)),
      margin: EdgeInsets.only(right: AljaredaConst().headLinePadding),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: GoogleFonts.arefRuqaa(
            fontWeight: FontWeight.bold,
            fontSize: AdaptiveTextSize()
                .getadaptiveTextSizeSetting(context, 60, fontSize!),
          ),
        ),
      ),
    );
  }
}
