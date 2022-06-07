
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../htmltest.dart';
import '../models/Article.dart';
import '../provider/articleProvider.dart';
import '../provider/auth.dart';
import '../utils/adabtiveText.dart';
import '../widgets/todayPage/articleTemplete.dart';

class CategoryArticls extends StatefulWidget {
  const CategoryArticls({Key ?key}) : super(key: key);

  @override
  _CategoryArticlsState createState() => _CategoryArticlsState();
}

class _CategoryArticlsState extends State<CategoryArticls> {
  List? articles;

  ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
   
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  void didChangeDependencies() {
    getArticle();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String category =
        Provider.of<ArticlePrvider>(context, listen: false).category!;

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              // AnimatedContainer(
              //   height: _showAppbar ? 56.0 : 0.0,
              //   duration: Duration(milliseconds: 300),
              //   child: AppBar(
                
              //     centerTitle: true,
              //     title: Text(
              //       category,
              //       style: TextStyle(
              //           fontFamily: ArabicFonts.Lemonada,
              //           fontSize: AdaptiveTextSize()
              //               .getadaptiveTextSizeSetting(context, 35,
              //                   Provider.of<Setting>(context).fontSize),
              //           package: 'google_fonts_arabic'),
              //     ),
              //   ),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollViewController,
                  child: Container(
                    // margin: EdgeInsets.only(top: size.height*.1),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * .015),
                      child: Container(
                        child: Column(
                          children: [
                            //       Container(
                            //         margin: EdgeInsets.only(top: 10,bottom: 10),
                            //            decoration: BoxDecoration(
                            //   border: Border(
                            //       left: BorderSide(width: 3, color: Colors.black),
                            //       bottom: BorderSide(width: 3, color: Colors.black),
                            //       top: BorderSide(width: 3, color: Colors.black),
                            //       right: BorderSide(width: 3, color: Colors.black)),
                            // ),
                            //         alignment: Alignment.center,
                            //         child:Text(category,style: TextStyle(fontSize: 30),),
                            //         height: size.height * .08,
                            //       ),
                            Container(
                              child: Column(
                                children: [
                                  Consumer<ArticlePrvider>(
                                      builder: (context, articleProv, _) {
                                    try {
                                      if (articles == null) {
                                        return Center(
                                          child: Container(
                                            width: size.width * 1,
                                            height: size.width * 1,
                                            child: Center(
                                              child: LoadingFlipping.circle(),
                                            ),
                                          ),
                                        );
                                      }

                                      int onlyArticles = 0;

                                      articles!.sort((a, b) {
                                        var adate = a
                                            .createdAt; //before -> var adate = a.expiry;
                                        var bdate = b
                                            .createdAt; //before -> var bdate = b.expiry;
                                        return bdate.compareTo(
                                            adate); //to get the order other way just switch `adate & bdate`
                                      });

                                      for (int i = 0;
                                          i < articles!.length;
                                          i++) {
                                        if (articles![i].articletype[0] ==
                                            'article') {
                                          print(articles![i].articletype);
                                          onlyArticles++;
                                          print(onlyArticles);
                                        }
                                      }
                                      if (onlyArticles == 0) {
                                        return Center(
                                            child: Container(
                                          width: size.width*.7,
                                          height: size.height*.15,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'لا توجد مقالات جديدة ',
                                                style: TextStyle(
                                                  fontSize: AdaptiveTextSize()
                                                      .getadaptiveTextSize(
                                                          context, 20),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  ':(',
                                                  style: TextStyle(
                                                    fontSize: AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 20),
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                      } else {
                                        List<Widget> articlesColumn = [];

                                        for (int i = 0;
                                            i < articles!.length;
                                            i++) {
                                          if (articles![i].articletype[0] ==
                                              'article') {
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
                                              child: ArticleWidget(
                                                context: context,
                                                imageUrl:
                                                    'http://192.168.43.250:8000/uploads/photos/' +
                                                        articles![i].photo,
                                                title: '',
                                                headline: articles![i].title,
                                                arthur:
                                                    '${articles![i].user.firstName} ${articles![i].user.lastName}',
                                                description: '',
                                                size: size,
                                                category:
                                                    articles![i].category[0],
                                                id: articles![i].id,
                                                userPhoto:
                                                    articles![i].user.photo,
                                              ),
                                            ));
                                          }

                                          //                  if (articles[i].articletype[0] == 'news' &&
                                          //     articles[i].photo == 'no_photo.jpg') {
                                          //   articlesColumn.add(Divider(
                                          //     color: Colors.black,
                                          //     thickness: 2,
                                          //   ));
                                          //   articlesColumn.add(InkWell(
                                          //       onTap: () async {
                                          //         articleProv.article = articles[i];
                                          //         ArticleModel articleModel = articles[i];

                                          //         pushNewScreen(context,
                                          //             pageTransitionAnimation:
                                          //                 PageTransitionAnimation.scale,
                                          //             screen: test(articleModel),
                                          //             withNavBar: false);
                                          //       },
                                          //       child: rawNews(articles[i].title, size)));
                                          // }
                                          //                if (articles[i].articletype[0] == 'news' &&
                                          //     articles[i].photo != 'no_photo.jpg') {
                                          //   articlesColumn.add(InkWell(
                                          //       onTap: () async {
                                          //         articleProv.article = articles[i];
                                          //         ArticleModel articleModel = articles[i];

                                          //         pushNewScreen(context,
                                          //             pageTransitionAnimation:
                                          //                 PageTransitionAnimation.scale,
                                          //             screen: test(articleModel),
                                          //             withNavBar: false);
                                          //       },
                                          //       child: newsPhoTemplate(
                                          //           'http://192.168.43.250:8000/uploads/photos/' +
                                          //               articles[i].photo,
                                          //           articles[i].title,
                                          //           '${articles[i].user.firstName} ${articles[i].user.lastName}',
                                          //           articles[i].place,
                                          //           size,
                                          //           Colors.black,
                                          //           1)));
                                          // }
                                        }

                                        articles!
                                          ..sort((a, b) {
                                            return a.articletype[0]
                                                .toString()
                                                .toLowerCase()
                                                .compareTo(b.articletype[0]
                                                    .toString()
                                                    .toLowerCase());
                                          });

                                        return Column(
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
                                      }
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
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getArticle() async {
     String token =
        await Provider.of<AuthProvider>(context, listen: false).token!;
    // String cate = Provider.of<ArticlePrvider>(context, listen: false).category;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getCategoryArticles(token);
    if (res == 'success') {
      articles = Provider.of<ArticlePrvider>(context, listen: false).articles;
      print(articles);
      setState(() {});
    }
  }
}
