import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '../htmltest.dart';
import '../models/Article.dart';
import '../models/UserInfo.dart';
import '../provider/articleProvider.dart';
import '../provider/auth.dart';
import '../provider/settingProvider.dart';
import '../utils/adabtiveText.dart';

class journlist extends StatefulWidget {
  User journlistInfo;
  journlist(this.journlistInfo);
  @override
  _journlistState createState() => _journlistState();
}

class _journlistState extends State<journlist> {
  List? articles;
  UserInfo? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    user = Provider.of<AuthProvider>(context, listen: false).user;
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
              child: articles != null
                  ? Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: size.height * .02,
                                  top: size.height * .02),
                              child: Container(
                                width: size.width * .4,
                                height: size.width * .4,
                                child: CircleAvatar(
                                  backgroundColor: Provider.of<Setting>(context,
                                              listen: false)
                                          .nightmode!
                                      ? Colors.white
                                      : Colors.black,
                                  radius: 74,
                                  child: CircleAvatar(
                                    radius: 71,
                                    backgroundImage: widget
                                                .journlistInfo.photo! !=
                                            'no_image.jpg'
                                        ? NetworkImage(
                                            'http://192.168.43.250:8000/uploads/photos/' +
                                                widget.journlistInfo.photo!,
                                          ) as ImageProvider
                                        : AssetImage('assets/profilePlace.png'),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * .93,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * .01,
                                        left: size.width * .02,
                                        right: size.width * .02),
                                    child: Container(
                                      child: Text(
                                        '${widget.journlistInfo.firstName} ${widget.journlistInfo.lastName}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 16)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        // top: size.height * .01,
                                        left: size.width * .01,
                                        right: size.width * .01),
                                    child: Center(
                                      child: Container(
                                          child: Text(
                                        widget.journlistInfo.email!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 16)),
                                      )),
                                    ),
                                  ),
                                  Divider(
                                    color: Provider.of<Setting>(context,
                                                listen: false)
                                            .nightmode!
                                        ? Colors.grey.shade400
                                        : Colors.black,
                                    thickness: 1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * .01,
                                        bottom: size.height * .02,
                                        left: size.width * .01,
                                        right: size.width * .01),
                                    child: Container(
                                        decoration: BoxDecoration(),
                                        child: Text(
                                          widget.journlistInfo.description ==
                                                  null
                                              ? 'لا يوجد وصف'
                                              : widget
                                                  .journlistInfo.description!,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              fontSize: AdaptiveTextSize()
                                                  .getadaptiveTextSize(
                                                      context, 16)),
                                        )),
                                  ),
                                  Divider(
                                    color: Provider.of<Setting>(context,
                                                listen: false)
                                            .nightmode!
                                        ? Colors.grey.shade400
                                        : Colors.black,
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        SizedBox(
                          height: size.height * .05,
                        ),
                        // ),
                        //ColorFiltered

                        Center(
                          child: Container(
                            width: size.width * .93,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * .01,
                                  bottom: size.height * .02,
                                  left: size.width * .02,
                                  right: size.width * .02),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: size.width * .05),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'المقالات والأخبار',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          child: Consumer<ArticlePrvider>(
                              builder: (context, articleProv, _) {
                            try {
                              if (articles == null) {
                                return Container(
                                  width: 100,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (articles!.length == 0) {
                                return Center(
                                    child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'لا توجد مقالات او أخبار للكاتب ',
                                        style: TextStyle(
                                          fontSize: AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 25),
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

                                for (int i = 0; i < articles!.length; i++) {
                                  if (articles![i].articletype[0] !=
                                      'breaking') {
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
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: 
                                        ExpansionTileCard(
                                     expandedTextColor: Colors.black,
                                          leading: Text(
                                            articles![i].articletype[0] ==
                                                    'article'
                                                ? 'مقال'
                                                : 'خبر',
                                            style: TextStyle(
                                                fontSize: AdaptiveTextSize()
                                                    .getadaptiveTextSize(
                                                        context, 14)),
                                          ),
                                          title: Text(
                                            articles![i].title,
                                            style: TextStyle(
                                                fontSize: AdaptiveTextSize()
                                                    .getadaptiveTextSize(
                                                        context, 18)),
                                          ),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .01),
                                            child: Text(
                                              intl.DateFormat.yMMMMEEEEd(
                                                      'ar_SA')
                                                  .format(
                                                articles![i].createdAt,
                                              ),
                                              style: TextStyle(
                                                  fontSize: AdaptiveTextSize()
                                                      .getadaptiveTextSize(
                                                          context, 12)),
                                            ),
                                          ),
                                          children: <Widget>[
                                            Divider(
                                              thickness: 1.0,
                                              height: 1.0,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 8.0,
                                                ),
                                                child:   Container(
                                        child: Center(
                                          child: CachedNetworkImage(
                                            imageUrl: articles![i]
                                                        .articletype ==
                                                    'article'
                                                ? "http://192.168.43.250:8000/uploads/photos/" +
                                                    articles![i].photo!
                                                : articles![i].assets!
                                                        .isNotEmpty
                                                    ? "http://192.168.43.250:8000/uploads/photos/" +
                                                        articles![i]
                                                            .assets![0]
                                                    : "http://192.168.43.250:8000/uploads/photos/" +
                                                        articles![i]
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
                                      ),
                                   
                                                     // : Image.asset(
                                                    //     'assets/newsPlace.png',
                                                    //     fit: BoxFit.cover,
                                                    //   ),
                                              ),
                                            ),
                                          ],
                                        ),
                                     
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

  Widget article(String imageUrl, String title, String headline, String arthur,
      String description, Size size, String category, String date) {
    String dateWithOutTime = date.substring(0, 10);
    return Container(
      width: size.width * .93,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
              top: BorderSide(color: Colors.black, width: 2),
              left: BorderSide(color: Colors.black, width: 2),
              right: BorderSide(color: Colors.black, width: 2))),
      child: Padding(
        padding: EdgeInsets.only(top: size.height * .01),
        child: Container(
          // decoration: BoxDecoration(
          //     border: Border(
          //         top: BorderSide(
          //   color: Colors.black,
          //   width: 2,
          // ))),
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
                margin: EdgeInsets.only(bottom: 5, right: 5),
                alignment: Alignment.bottomRight,
                child: Text(
                  headline,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize:
                        AdaptiveTextSize().getadaptiveTextSize(context, 32),
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
                    margin:
                        EdgeInsets.only(right: size.width * .03, bottom: 15),
                    width: size.width * .07,
                    height: size.height * .07,
                    child: Image.asset('assets/pen.png'),
                  ),
                ],
              ),

              Container(
                child: Image.network(imageUrl),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    dateWithOutTime,
                    style: TextStyle(color: Colors.black.withOpacity(.6)),
                  ),
                ),
              ),
              //description
            ],
          ),
        ),
      ),
    );
  }

  getArticle() async {
    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getJournlistArticles(widget.journlistInfo.id!,token);
    if (res == 'success') {
      articles =
          Provider.of<ArticlePrvider>(context, listen: false).journlistArticles;
      print(articles);
      setState(() {});
    }
  }
}
