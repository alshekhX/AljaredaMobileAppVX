
import 'package:aljaredanews/screens/Category/categoryC.dart';
import 'package:aljaredanews/screens/today/CustomDivider.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:aljaredanews/widgets/todayPage/rawNewsTem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../ArticleHtml/htmltext.dart';
import '../../models/Article.dart';
import '../../provider/articleProvider.dart';
import '../../provider/auth.dart';
import '../../utils/adabtiveText.dart';
import '../../widgets/todayPage/articleTemplete.dart';

class CategoryArticls extends StatefulWidget {
  const CategoryArticls({Key ?key}) : super(key: key);

  @override
  _CategoryArticlsState createState() => _CategoryArticlsState();
}

class _CategoryArticlsState extends State<CategoryArticls> {
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
                              if (controller.articles == null) {
                                return Container(
                                  width: size.width * 1,
                                  height: size.width * 1,
                                  child: Center(
                                    child: LoadingFlipping.circle(),
                                  ),
                                );
                              }

                              int onlyArticles = 0;

                              for (int i = 0; i < articleProv.articles!.length; i++) {
                                if (articleProv.articles![i].articletype[0] == 'article') {
                                  onlyArticles++;
                                }
                              }
                              if (onlyArticles == 0) {
                                return Center(
                                    child: Container(
                                  width: size.width * .7,
                                  height: size.height * .15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'لا توجد مقالات جديدة ',
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
                                  if (articleProv.articles![i].articletype[0] == 'article') {
                                      articlesColumn.add(InkWell(
                                              onTap: () async {
                                                articleProv.article =
                                                  articleProv.articles![i];
                                                ArticleModel articleModel =
                                                   articleProv.articles![i];

                                             PersistentNavBarNavigator.     pushNewScreen(context,
                                                    pageTransitionAnimation:
                                                        PageTransitionAnimation
                                                            .scale,
                                                    screen: HtmlText(articleModel),
                                                    withNavBar: false);
                                              },
                                              child: ArticleWidget(
                                                context: context,
                                                imageUrl:
                                                    AljaredaConst.BasePicUrl +
                                                      articleProv.articles![i].photo,
                                                title: '',
                                                headline: articleProv.articles![i].title,
                                                arthur:
                                                    '${articleProv.articles![i].user.firstName} ${articleProv.articles![i].user.lastName}',
                                                description: '',
                                                size: size,
                                                category:
                                                   articleProv.articles![i].category[0],
                                                id:articleProv.articles![i].id,
                                                userPhoto:
                                                   articleProv.articles![i].user.photo,
                                              ),
                                            ));
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

 
  getArticle() async {
    await controller.getArticles(context);
    setState(() {
      
    });
  }
}


