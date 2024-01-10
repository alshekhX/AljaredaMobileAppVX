import 'package:aljaredanews/screens/journlistScreen/journlistC.dart';
import 'package:aljaredanews/screens/journlistScreen/widgets/EmptyContents.dart';
import 'package:aljaredanews/screens/journlistScreen/widgets/JournlistDetails.dart';
import 'package:aljaredanews/screens/journlistScreen/widgets/JournlistExpansionCard.dart';
import 'package:aljaredanews/screens/today/today.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../ArticleHtml/htmltext.dart';
import '../../models/Article.dart';
import '../../models/UserInfo.dart';
import '../../provider/articleProvider.dart';
import '../../provider/auth.dart';
import '../../provider/settingProvider.dart';

class journlist extends StatefulWidget {
  User journlistInfo;
  journlist(this.journlistInfo);
  @override
  _journlistState createState() => _journlistState();
}

class _journlistState extends State<journlist> {
  late JournlistController controller;
  @override
  void initState() {
    controller = JournlistController(context);
        getArticle();

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getArticle();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * .010),
          child: Container(
            child: SingleChildScrollView(
              child: controller.articles != null
                  ? Column(
                      children: [
                        JournlistDetails(size: size, widget: widget),

                        // ),
                        //ColorFiltered

                        Align(
                          alignment: Alignment.bottomRight,
                          child: MainTitle(
                              text: 'المقالات ولأخبار',
                              fontSize:
                                  Provider.of<Setting>(context, listen: false)
                                      .fontSize),
                        ),

                        Container(
                          child: Consumer<ArticlePrvider>(
                              builder: (context, articleProv, _) {
                            try {
                              if (controller.articles == null) {
                                return Container(
                                  width: 100.w,
                                  height: 90.h,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (controller.articles !.length == 0) {
                                return const EmptyContent();
                              } else {
                                List<Widget> articlesColumn = [];

                                for (int i = 0; i < controller.articles !.length; i++) {
                                  if (controller.articles ![i].articletype[0] !=
                                      'breaking') {
                                    articlesColumn.add(InkWell(
                                      onTap: () async {
                                        articleProv.article = controller.articles ![i];
                                        ArticleModel articleModel =
                                            controller.articles ![i];

                                        PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.scale,
                                            screen: HtmlText(articleModel),
                                            withNavBar: false);
                                      },
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: JournlistExpansionCard(
                                            articles: controller.articles ,
                                            i: i,
                                            size: size),
                                      ),
                                    ));
                                  }
                                }

                                return Padding(
                                  padding:
                                      EdgeInsets.only(bottom: size.height * .1),
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
                            } catch (e) {
                              return Center(
                                  child: Container(
                                width: 100,
                                height: 200,
                                child: Text('error'),
                              ));
                            }
                          }),
                        )

                        // إن حرية التعبير – خاصة حرية الصحافة – تضمن مشاركة الشعب فى قرارات الحكومة و أفعالها و المشاركة الشعبية هى جوهر ديمقراطيتنا .
                      ],
                    )
                  : Center(
                      child: Container(
                      width: size.width,
                      height: size.height * .2,
                      child: LoadingFlipping.circle(),
                    )),
            ),
          ),
        ),
      ),
    );
  }

  getArticle() async {
    await controller.getArticle(context, widget.journlistInfo);
    setState(() {
      
    });
  }
}
