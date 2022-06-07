import 'package:aljaredanews/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../htmltest.dart';
import '../../models/Article.dart';
import '../../provider/articleProvider.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';
import '../../widgets/todayPage/fullNewsTem.dart';
import '../../widgets/todayPage/rawNewsTem.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({Key? key}) : super(key: key);

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
      //               AnimatedContainer(
      //                 height: _showAppbar ? 56.0 : 0.0,
      //                 duration: Duration(milliseconds: 300),
      //                 child: AppBar(
      //                   automaticallyImplyLeading: false,
      //                   title: Center(
      //                     child: Text(
      //                       category,
      //                       style:TextStyle(                             fontFamily: ArabicFonts.Lemonada,
      // fontSize: AdaptiveTextSize()
      //                                     .getadaptiveTextSizeSetting(context, 35, Provider.of<Setting>(context).fontSize),
      //                           package: 'google_fonts_arabic'),
      //                     ),
      //                   ),
      //                 ),
      //               ),
            Container(
              // margin: EdgeInsets.only(top: size.height*.1),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * .02,
                    ),
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
                                return Container(
                                  width: size.width * 1,
                                  height: size.width * 1,
                                  child: Center(
                                    child: LoadingFlipping.circle(),
                                  ),
                                );
                              }
      
                              int onlyNews = 0;
      
                              for (int i = 0; i < articles!.length; i++) {
                                if (articles![i].articletype[0] == 'news') {
                                  onlyNews++;
                                }
                              }
                              if (onlyNews == 0) {
                                return Center(
                                    child: Container(
                                  width: size.width*.7,
                                          height: size.height*.15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'لا توجد اخبار جديدة ',
                                        style: TextStyle(
                                          fontSize: AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 20),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          ':(',
                                          style: TextStyle(
                                            fontSize: AdaptiveTextSize()
                                                .getadaptiveTextSize(context, 20),
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                              } else {
                                List<Widget> articlesColumn = [];
                                articles!.sort((a, b) {
                                  var adate = a
                                      .createdAt; //before -> var adate = a.expiry;
                                  var bdate = b
                                      .createdAt; //before -> var bdate = b.expiry;
                                  return bdate.compareTo(
                                      adate); //to get the order other way just switch `adate & bdate`
                                });
      
                                for (int i = 0; i < articles!.length; i++) {
                                  // if (articles[i].articletype[0] == 'article') {
                                  //   articlesColumn.add(InkWell(
                                  //     onTap: () async {
                                  //       articleProv.article = articles[i];
                                  //       ArticleModel articleModel = articles[i];
      
                                  //       pushNewScreen(context,
                                  //           pageTransitionAnimation:
                                  //               PageTransitionAnimation.scale,
                                  //           screen: test(articleModel),
                                  //           withNavBar: false);
                                  //     },
                                  //     child: article(
                                  //         'http://192.168.43.250:8000/uploads/photos/' +
                                  //             articles[i].photo,
                                  //         '',
                                  //         articles[i].title,
                                  //         '${articles[i].user.firstName} ${articles[i].user.lastName}',
                                  //         '',
                                  //         size,
                                  //         articles[i].category[0]),
                                  //   ));
                                  // }
      
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
                                  // if (articles![i].articletype[0] == 'news' &&
                                  //     articles![i].photo != 'no_photo.jpg') {
                                  //   articlesColumn.add(InkWell(
                                  //     onTap: () async {
                                  //       articleProv.article = articles![i];
                                  //       ArticleModel articleModel = articles![i];
      
                                  //       pushNewScreen(context,
                                  //           pageTransitionAnimation:
                                  //               PageTransitionAnimation.scale,
                                  //           screen: test(articleModel),
                                  //           withNavBar: false);
                                  //     },
                                  //     child: FullNews(
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
                                  //         id: articles![i].id),
                                  //   ));
                                  // }
      
                                  if (articles![i].articletype[0] == 'news') {
                                    articlesColumn.add(InkWell(
                                        onTap: () async {
                                          articleProv.article = articles![i];
                                          ArticleModel articleModel =
                                              articles![i];
      
                                          pushNewScreen(context,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation.scale,
                                              screen: test(articleModel),
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
                                          assets: articles![i].assets ,
                                        )));
      
                                    articlesColumn.add(Container(
                                      width: size.width * .9,
                                      child: Divider(
                                        color: Provider.of<Setting>(context,
                                                    listen: false)
                                                .nightmode!
                                            ? Colors.grey.shade400
                                            : Colors.black,
                                        thickness: 2,
                                      ),
                                    ));
                                  }
                                }
      
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
                                child: Text('$e'),
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
          ],
        ),
      ),
    );
  }

  Widget article(String imageUrl, String title, String headline, String arthur,
      String description, Size size, String category) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * .05),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: Colors.black,
          width: 2,
        ))),
        child: Column(
          children: [
//title
            Center(
              child: Container(
                width: size.width * .9,
                margin: EdgeInsets.only(
                    top: size.height * .02, bottom: size.height * .01),
                alignment: Alignment.bottomRight,
              ),
            ),
//headline
            Container(
              width: size.width * .9,
              margin: EdgeInsets.only(bottom: 5),
              alignment: Alignment.bottomRight,
              child: Text(
                headline,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 32),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * .03),
                  child: Text(
                    category,
                    style: TextStyle(color: Colors.black.withOpacity(.4)),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    arthur,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize:
                          AdaptiveTextSize().getadaptiveTextSize(context, 22),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * .01,
                ),
                Container(
                  margin: EdgeInsets.only(right: size.width * .03, bottom: 15),
                  width: size.width * .07,
                  height: size.height * .07,
                  child: Image.asset('assets/pen.png'),
                ),
              ],
            ),

            Container(
              child: Image.network(imageUrl),
            ),
            //description
          ],
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

  Container rawNews(String text, Size size) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      width: size.width * 9,
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
