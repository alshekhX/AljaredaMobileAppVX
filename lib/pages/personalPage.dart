import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timelines/timelines.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../htmltest.dart';
import '../models/Article.dart';
import '../models/UserInfo.dart';
import '../provider/articleProvider.dart';
import '../provider/auth.dart';
import '../provider/settingProvider.dart';
import '../settings.dart';
import '../utils/adabtiveText.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  bool? _isConnected;
  List? articles;
  ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  final FaderController faderController = new FaderController();

  @override
  void dispose() {
    _scrollViewController!.dispose();
    _scrollViewController!.removeListener(() {});
    super.dispose();
  }

  UserInfo? user;

  @override
  void didChangeDependencies() {
    user = Provider.of<AuthProvider>(context, listen: false).user;
    getJournlistArt();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> getJournlistArt() async {
    String token =
        await Provider.of<AuthProvider>(context, listen: false).token!;
    await Provider.of<ArticlePrvider>(context, listen: false)
        .getJournlistArticles(user!.id!, token);
    articles =
        Provider.of<ArticlePrvider>(context, listen: false).journlistArticles;
    setState(() {});
  }

  @override
  void initState() {
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

    WidgetsBinding.instance!
        .addPostFrameCallback((_) => {faderController.fadeIn()});
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String greet = greeting();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              height: _showAppbar ? 56.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: AppBar(
                leading: InkWell(
                    onTap: () {
                      pushNewScreen(context,
                          screen: Settings(), withNavBar: false);
                    },
                    child: Icon(Icons.settings)),
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
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
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                controller: _refreshController,
                onRefresh: _onRefresh,
                header: MaterialClassicHeader(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                ),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min, // Use children total size
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: size.width * .03, top: size.height * .02),
                          child: Container(
                              alignment: Alignment.topRight,
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    '$greet',
                                    textStyle: const TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    speed: const Duration(milliseconds: 200),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                pause: const Duration(milliseconds: 100),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: size.width * .05),
                          child: Container(
                              alignment: Alignment.topRight,
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    ' ${user!.firstName}${user!.lastName}',
                                    textStyle: const TextStyle(
                                      fontSize: 38,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    speed: const Duration(milliseconds: 250),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                pause: const Duration(milliseconds: 100),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              )),
                        ),
                        SizedBox(
                          height: size.height * .05,
                        ),
                        user!.role == 'journlist'
                            ? Padding(
                                padding:
                                    EdgeInsets.only(right: size.width * .05),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'مقالاتي',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontSize: AdaptiveTextSize()
                                          .getadaptiveTextSizeSetting(
                                              context,
                                              38,
                                              Provider.of<Setting>(context)
                                                  .fontSize),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: size.height * .03,
                        ),
                        user?.role == 'journlist'
                            ? Container(
                                child: Consumer<ArticlePrvider>(
                                    builder: (context, articleProv, _) {
                                  if (articles == null) {
                                    return Container(
                                      child: Center(
                                        child: LoadingFadingLine.circle(),
                                      ),
                                    );
                                  }

                                  if (articles!.length == 0) {
                                    return Center(
                                        child: Padding(
                                      padding: EdgeInsets.all(size.width * .1),
                                      child: Container(
                                          child: Text(
                                        'لم تنشر مقال او خبر بعد',
                                        style: TextStyle(
                                          // color: Colors.black,
                                          fontSize: AdaptiveTextSize()
                                              .getadaptiveTextSizeSetting(
                                                  context,
                                                  20,
                                                  Provider.of<Setting>(context)
                                                      .fontSize),
                                        ),
                                      )),
                                    ));
                                  } else {
                                    print(articles);
                                    List<Widget> articlesColumn = [];

                                    for (int i = 0; i < articles!.length; i++) {
                                      if (articles![i].articletype[0] !=
                                          'breaking') {
                                        articlesColumn.add(InkWell(
                                            onTap: () async {
                                              articleProv.article =
                                                  articles![i];
                                              ArticleModel articleModel =
                                                  articles![i];

                                              pushNewScreen(context,
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .scale,
                                                  screen: test(articleModel),
                                                  withNavBar: false);
                                            },
                                            child: Container(
                                              alignment: Alignment.bottomRight,
                                              width: size.width * .9,
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    size.width * .03),
                                                child: ExpansionCard(
                                                  initiallyExpanded: true,
                                                  borderRadius: 18,
                                                  margin: EdgeInsets.all(10),
                                                  background: articles![i]
                                                              .photo !=
                                                          'no_photo.jpg'
                                                      ? Container(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                "http://192.168.43.250:8000/uploads/photos/" +
                                                                    articles![i]
                                                                        .photo,
                                                            placeholder: (context,
                                                                    url) =>
                                                                Shimmer
                                                                    .fromColors(
                                                              baseColor: Colors
                                                                  .grey[300]!,
                                                              highlightColor:
                                                                  Colors.grey[
                                                                      100]!,
                                                              enabled: true,
                                                              child: Container(
                                                                width:
                                                                    size.width *
                                                                        .9,
                                                                height:
                                                                    size.height *
                                                                        .2,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          'assets/newsPlace.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                  title: Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade200
                                                              .withOpacity(.8),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: .5)),
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            size.height * .008),
                                                        child: Text(
                                                          articles![i].title,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: AdaptiveTextSize()
                                                                .getadaptiveTextSizeSetting(
                                                                    context,
                                                                    18,
                                                                    Provider.of<Setting>(
                                                                            context)
                                                                        .fontSize),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )

                                            //  article(
                                            //     'http://192.168.43.250:8000/uploads/photos/' +
                                            //         articles[i].photo,
                                            //     '',
                                            //     articles[i].title,
                                            //     '${articles[i].user.firstName} ${articles[i].user.lastName}',
                                            //     '',
                                            //     size,
                                            //     articles[i].category[0],
                                            //     articles[i].createdAt.toString()),
                                            ));
                                      }
                                    }

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: size.height * .02),
                                      child: Column(
                                        children: articlesColumn,
                                      ),
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
                                  }
                                }),
                              )
                            : Container(),
                        user!.role == 'journlist'
                            ? SizedBox(
                                height: size.height * .05,
                              )
                            : Container(),
                        user!.role == 'journlist'
                            ? Container(
                                width: size.width * .95,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * .02),
                                  child: Divider(
                                    thickness: 2.0,
                                    color: Provider.of<Setting>(context,
                                                listen: false)
                                            .nightmode!
                                        ? Colors.grey.shade400
                                        : Colors.black,
                                  ),
                                ))
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(right: size.width * .05),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              'المقالات والاخبار المحفوظة',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                // color: Colors.black,
                                fontSize: AdaptiveTextSize()
                                    .getadaptiveTextSizeSetting(context, 28,
                                        Provider.of<Setting>(context).fontSize),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .03,
                        ),
                        Consumer<ArticlePrvider>(
                            builder: (context, articleProv, _) {
                          // try {
                          List<Widget> articlesNews = [];
                          List<Widget> timeLineD = [];
                          List<Widget> articlesColumn = [];
                          List<Widget> newsColumn = [];

                          ArticleModel articleModel = new ArticleModel();

                          for (int i = 0;
                              i < user!.savedArticles!.length;
                              i++) {
                            timeLineD.add(Text(
                              intl.DateFormat.yMMMEd('ar_SA').format(
                                user!.savedArticles![i].createdAt!,
                              ),
                              style: TextStyle(
                                fontSize: AdaptiveTextSize()
                                    .getadaptiveTextSizeSetting(context, 17,
                                        Provider.of<Setting>(context).fontSize),
                                fontWeight: FontWeight.w500,
                              ),
                            ));
                            // if (user!.savedArticles![i].articletype![0] ==
                            //     'article') {
                            articlesColumn.add(InkWell(
                                onTap: () async {
                                  pushNewScreen(context,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.scale,
                                      screen: test(user!.savedArticles![i]),
                                      withNavBar: false);
                                },
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width * .4,
                                        child: CachedNetworkImage(
                                          imageUrl: user!.savedArticles![i]
                                                      .articletype ==
                                                  'article'
                                              ? "http://192.168.43.250:8000/uploads/photos/" +
                                                  user!.savedArticles![i].photo!
                                              : user!.savedArticles![i].assets!
                                                      .isNotEmpty
                                                  ? "http://192.168.43.250:8000/uploads/photos/" +
                                                      user!.savedArticles![i]
                                                          .assets![0]
                                                  : "http://192.168.43.250:8000/uploads/photos/" +
                                                      user!.savedArticles![i]
                                                          .photo!,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            enabled: true,
                                            child: Container(
                                              width: size.width * .9,
                                              height: size.height * .2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .3,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .3,
                                                  child: Image.network(
                                                      'https://jackson.yale.edu/wp-content/themes/twentysixteen/images/FPO/xFPO-news-1x.png.pagespeed.ic.cKnAqZyrXs.png')),
                                        ),
                                      ),
                                      Container(
                                        width: size.width * .40,
                                        child: Text(
                                          user!.savedArticles![i].title!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: AdaptiveTextSize()
                                                .getadaptiveTextSizeSetting(
                                                    context,
                                                    14,
                                                    Provider.of<Setting>(
                                                            context)
                                                        .fontSize),
                                          ),
                                          maxLines: 3,
                                          textDirection: TextDirection.rtl,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                                //  Container(

                                //   alignment: Alignment.bottomRight,
                                //   width: size.width * .9,
                                //   child: Padding(
                                //     padding: EdgeInsets.all(size.width * .03),
                                //     child: ExpansionCard(
                                //       initiallyExpanded: true,
                                //       margin: EdgeInsets.all(10),
                                //       borderRadius: 18,
                                //       background: Container(
                                //         child: CachedNetworkImage(
                                //           imageUrl:
                                //               "http://192.168.43.250:8000/uploads/photos/" +
                                //                   user!
                                //                       .savedArticles![i].photo!,
                                //           placeholder: (context, url) =>
                                //               Shimmer.fromColors(
                                //             baseColor: Colors.grey[300]!,
                                //             highlightColor: Colors.grey[100]!,
                                //             enabled: true,
                                //             child: Container(
                                //               width: size.width * .9,
                                //               height: size.height * .2,
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //           errorWidget: (context, url, error) =>
                                //               Icon(Icons.error),
                                //         ),
                                //       ),
                                //       title: Container(
                                //         alignment: Alignment.topRight,
                                //         child: Container(
                                //           decoration: BoxDecoration(
                                //               color: Colors.grey.shade200
                                //                   .withOpacity(.8),
                                //               border: Border.all(
                                //                   color: Colors.black,
                                //                   width: .5)),
                                //           alignment: Alignment.bottomRight,
                                //           child: Padding(
                                //             padding: EdgeInsets.all(
                                //                 size.height * .008),
                                //             child: Text(
                                //               user!.savedArticles![i].title!,
                                //               overflow: TextOverflow.ellipsis,
                                //               maxLines: 5,
                                //               textDirection: TextDirection.rtl,
                                //               style: TextStyle(
                                //                 color: Colors.black,
                                //                 fontSize: AdaptiveTextSize()
                                //                     .getadaptiveTextSizeSetting(
                                //                         context,
                                //                         12,
                                //                         Provider.of<Setting>(
                                //                                 context)
                                //                             .fontSize),
                                //                 fontWeight: FontWeight.w800,
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       children: <Widget>[
                                //         // Container(
                                //         //   margin:
                                //         //       EdgeInsets.symmetric(horizontal: 7),
                                //         //   child: BorderedText(
                                //         //      strokeWidth: 5.0,
                                //         //       strokeColor: Colors.black,
                                //         //     child: Text(
                                //         //         "${user.savedArticles[i].user.firstName} ${user.savedArticles[i].user.lastName}",
                                //         //         style: TextStyle(
                                //         //             fontSize: 18,
                                //         //             color: Colors.white)),
                                //         //   ),
                                //         // ),
                                //         // SizedBox(height: size.height*.1,),
                                //       ],
                                //     ),
                                //   ),
                                // )

                                //  ArticleWidget(
                                //     context: context,
                                //     imageUrl:
                                //         'http://192.168.43.250:8000/uploads/photos/' +
                                //             user.savedArticles[i].photo,
                                //     title: '',
                                //     headline: user.savedArticles[i].title,
                                //     arthur:
                                //         '${user.savedArticles[i].user.firstName} ${user.savedArticles[i].user.lastName}',
                                //     description: '',
                                //     size: size,
                                //     category: user.savedArticles[i].category[0]),
                                ));

                            // articlesColumn.add(SizedBox(
                            //   height: size.height * .01,
                            // ));
                            // }
                          }

                          // if (articlesColumn.isEmpty) {
                          //   articlesColumn.add(Center(
                          //       child: Padding(
                          //     padding: EdgeInsets.all(size.width * .1),
                          //     child: Container(
                          //         child: Text(
                          //       'لا توجد مقالات محفوظة',
                          //       style: TextStyle(
                          //         // color: Colors.black,
                          //         fontSize: AdaptiveTextSize()
                          //             .getadaptiveTextSizeSetting(
                          //                 context,
                          //                 20,
                          //                 Provider.of<Setting>(context)
                          //                     .fontSize),
                          //       ),
                          //     )),
                          //   )));
                          // }

                          // articlesColumn.add(Container(
                          //     width: size.width * .95,
                          //     child: Padding(
                          //       padding:
                          //           EdgeInsets.only(bottom: size.height * .02),
                          //       child: Divider(
                          //         thickness: 2.0,
                          //         color: Provider.of<Setting>(context,
                          //                     listen: false)
                          //                 .nightmode!
                          //             ? Colors.grey.shade400
                          //             : Colors.black,
                          //       ),
                          //     )));
                          // articlesColumn.add(
                          //   Padding(
                          //     padding: EdgeInsets.only(right: size.width * .05),
                          //     child: Container(
                          //       alignment: Alignment.topRight,
                          //       child: Text(
                          //         'الاخبار المحفوظة',
                          //         textDirection: TextDirection.rtl,
                          //         style: TextStyle(
                          //           fontSize: AdaptiveTextSize()
                          //               .getadaptiveTextSizeSetting(
                          //                   context,
                          //                   38,
                          //                   Provider.of<Setting>(context)
                          //                       .fontSize),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // );

                          // articlesColumn.add(SizedBox(
                          //   height: size.height * .03,
                          // ));

                          // for (int i = 0;
                          //     i < user!.savedArticles!.length;
                          //     i++) {
                          //   if (user!.savedArticles![i].articletype![0] ==
                          //       'news') {
                          //     newsColumn.add(InkWell(
                          //         onTap: () async {
                          //           articleModel.title =
                          //               user!.savedArticles![i].title;
                          //           articleProv.article!.title =
                          //               user!.savedArticles![i].title;
                          //           articleProv.article!.photo =
                          //               user!.savedArticles![i].photo;
                          //           articleProv.article!.description =
                          //               user!.savedArticles![i].description;
                          //           articleProv.article!.user!.firstName =
                          //               user!.savedArticles![i].user!.firstName;
                          //           articleProv.article!.user!.lastName =
                          //               user!.savedArticles![i].user!.lastName;
                          //           articleProv.article!.description =
                          //               user!.savedArticles![i].description;
                          //           articleProv.article!.createdAt =
                          //               user!.savedArticles![i].createdAt;
                          //           pushNewScreen(context,
                          //               pageTransitionAnimation:
                          //                   PageTransitionAnimation.scale,
                          //               screen: test(articleProv.article),
                          //               withNavBar: false);
                          //         },
                          //         child: Container(
                          //           alignment: Alignment.bottomRight,
                          //           width: size.width * .9,
                          //           child: Padding(
                          //             padding: EdgeInsets.all(size.width * .03),
                          //             child: ExpansionCard(
                          //               initiallyExpanded: true,
                          //               margin: EdgeInsets.all(10),
                          //               borderRadius: 18,
                          //               background: user!
                          //                           .savedArticles![i].photo !=
                          //                       'no_photo.jpg'
                          //                   ? Container(
                          //                       child: CachedNetworkImage(
                          //                         imageUrl:
                          //                             "http://192.168.43.250:8000/uploads/photos/" +
                          //                                 user!
                          //                                     .savedArticles![i]
                          //                                     .photo!,
                          //                         placeholder: (context, url) =>
                          //                             Shimmer.fromColors(
                          //                           baseColor:
                          //                               Colors.grey[300]!,
                          //                           highlightColor:
                          //                               Colors.grey[100]!,
                          //                           enabled: true,
                          //                           child: Container(
                          //                             width: size.width * .9,
                          //                             height: size.height * .2,
                          //                             color: Colors.white,
                          //                           ),
                          //                         ),
                          //                         errorWidget:
                          //                             (context, url, error) =>
                          //                                 Icon(Icons.error),
                          //                       ),
                          //                     )
                          //                   : Image.asset(
                          //                       'assets/newsPlace.png',
                          //                       fit: BoxFit.cover,
                          //                     ),
                          //               title: Container(
                          //                 alignment: Alignment.topRight,
                          //                 child: Container(
                          //                   decoration: BoxDecoration(
                          //                       color: Colors.grey.shade200
                          //                           .withOpacity(.8),
                          //                       border: Border.all(
                          //                           color: Colors.black,
                          //                           width: .5)),
                          //                   alignment: Alignment.bottomRight,
                          //                   child: Padding(
                          //                     padding: EdgeInsets.all(
                          //                         size.height * .008),
                          //                     child: Text(
                          //                       user!.savedArticles![i].title!,
                          //                       overflow: TextOverflow.ellipsis,
                          //                       maxLines: 5,
                          //                       textDirection:
                          //                           TextDirection.rtl,
                          //                       style: TextStyle(
                          //                         color: Colors.black,
                          //                         fontSize: AdaptiveTextSize()
                          //                             .getadaptiveTextSizeSetting(
                          //                                 context,
                          //                                 18,
                          //                                 Provider.of<Setting>(
                          //                                         context)
                          //                                     .fontSize),
                          //                         fontWeight: FontWeight.w800,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //               children: <Widget>[
                          //                 // Container(
                          //                 //   margin:
                          //                 //       EdgeInsets.symmetric(horizontal: 7),
                          //                 //   child: BorderedText(
                          //                 //      strokeWidth: 5.0,
                          //                 //       strokeColor: Colors.black,
                          //                 //     child: Text(
                          //                 //         "${user.savedArticles[i].user.firstName} ${user.savedArticles[i].user.lastName}",
                          //                 //         style: TextStyle(
                          //                 //             fontSize: 18,
                          //                 //             color: Colors.white)),
                          //                 //   ),
                          //                 // ),
                          //                 // SizedBox(height: size.height*.1,),
                          //               ],
                          //             ),
                          //           ),
                          //         )
                          //         //  ArticleWidget(
                          //         //     context: context,
                          //         //     imageUrl:
                          //         //         'http://192.168.43.250:8000/uploads/photos/' +
                          //         //             user.savedArticles[i].photo,
                          //         //     title: '',
                          //         //     headline: user.savedArticles[i].title,
                          //         //     arthur:
                          //         //         '${user.savedArticles[i].user.firstName} ${user.savedArticles[i].user.lastName}',
                          //         //     description: '',
                          //         //     size: size,
                          //         //     category: user.savedArticles[i].category[0]),
                          //         ));

                          //     articlesNews.add(SizedBox(
                          //       height: size.height * .01,
                          //     ));
                          //   }
                          // }
                          // if (newsColumn.isEmpty) {
                          //   newsColumn.add(Center(
                          //       child: Padding(
                          //     padding: EdgeInsets.all(size.width * .1),
                          //     child: Container(
                          //         child: Text(
                          //       'لا توجد اخبار محفوظة',
                          //       style: TextStyle(
                          //         // color: Colors.black,
                          //         fontSize: AdaptiveTextSize()
                          //             .getadaptiveTextSizeSetting(
                          //                 context,
                          //                 20,
                          //                 Provider.of<Setting>(context)
                          //                     .fontSize),
                          //       ),
                          //     )),
                          //   )));
                          // }

                          // articlesNews = articlesColumn + newsColumn;
                          if (articlesColumn.isNotEmpty) {
                            return Container(
                              height: size.height * .465,
                              child: Timeline.tileBuilder(
                                theme: TimelineThemeData(
                                  color: Provider.of<Setting>(context,
                                                  listen: false)
                                              .nightmode ==
                                          true
                                      ? Colors.grey.shade200
                                      : Colors.black,
                                ),
                                builder: TimelineTileBuilder.fromStyle(
                                  indicatorStyle: IndicatorStyle.outlined,
                                  contentsAlign: ContentsAlign.alternating,
                                  contentsBuilder: (context, index) => Center(
                                      child: articlesColumn.reversed
                                          .toList()[index]),
                                  oppositeContentsBuilder: (context, index) =>
                                      Center(
                                          child: timeLineD.reversed
                                              .toList()[index]),
                                  itemCount: articlesColumn.length,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: size.height*.3,
                              child: Center(
                                child: Text('لا توجد منشورات محفوظة'
                                ,),
                              ),
                            );
                          }
                          // return Column(
                          //   mainAxisSize:
                          //       MainAxisSize.min, // Use children total size
                          //   children: articlesNews,
                          // );
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

                          // } catch (e) {
                          //   return Center(
                          //       child: Container(
                          //     width: 100,
                          //     height: 200,
                          //     child: Text('$e nhvhjvj'),
                          //   ));
                          // }
                        }),
                        SizedBox(
                          height: size.height * .05,
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      await getUserSavedArtiNew();
      setState(() {});
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return ' نهارك سعيد';
    } else {
      return 'مساء الخير ';
    }
  }

  Future<void> getUserSavedArtiNew() async {
    await Provider.of<AuthProvider>(context, listen: false).getUserData();
    user = Provider.of<AuthProvider>(context, listen: false).user;
    setState(() {});
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
}
