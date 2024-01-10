import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/screens/Category/categoryC.dart';
import 'package:aljaredanews/screens/today/CustomDivider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../ArticleHtml/htmltext.dart';
import '../../models/Article.dart';
import '../../provider/articleProvider.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';
import '../../widgets/todayPage/rawNewsTem.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({Key? key}) : super(key: key);

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  late CategoryController controller;

  @override
  void initState() {
    controller = CategoryController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getNews();
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
            Container(
              // margin: EdgeInsets.only(top: size.height*.1),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Consumer<ArticlePrvider>(
                              builder: (context, articleProv, _) {

                            try {
                              if (controller.news == null) {
                                return Container(
                                  width: size.width * 1,
                                  height: size.width * 1,
                                  child: Center(
                                    child: LoadingFlipping.circle(),
                                  ),
                                );
                              }

                              int onlyNews = 0;

                              for (int i = 0; i < articleProv.articles!.length; i++) {
                                if (articleProv.articles![i].articletype[0] == 'news') {
                                  onlyNews++;
                                }
                              }
                              if (onlyNews == 0) {
                                return Center(
                                    child: Container(
                                  width: size.width * .7,
                                  height: size.height * .15,
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
                                articleProv.articles!.sort((a, b) {
                                  var adate = a
                                      .createdAt; //before -> var adate = a.expiry;
                                  var bdate = b
                                      .createdAt; //before -> var bdate = b.expiry;
                                  return bdate.compareTo(
                                      adate); //to get the order other way just switch `adate & bdate`
                                });

                                for (int i = 0;
                                    i < articleProv.articles!.length;
                                    i++) {
                                  if (articleProv.articles![i].articletype[0] == 'news') {
                                    articlesColumn.add(InkWell(
                                        onTap: () async {
                                          articleProv.article =
                                              articleProv.articles![i];

                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .scale,
                                                  screen: HtmlText(
                                                      articleProv.article),
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
                                          assets:
                                              articleProv.articles![i].assets,
                                        )));

                                    articlesColumn
                                        .add(CustomDivider(size: size));
                                  }
                                }

                                return Column(
                                  children: articlesColumn,
                                );
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

  getNews() async {
    await controller.getNews(context);
    setState(() {
      
    });
  }
}

