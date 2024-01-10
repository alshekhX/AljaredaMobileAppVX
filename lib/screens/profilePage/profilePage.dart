import 'package:aljaredanews/classes/nightmode.dart';
import 'package:aljaredanews/screens/profilePage/profilePageC.dart';
import 'package:aljaredanews/screens/profilePage/widgets/TimeLineItem.dart';
import 'package:aljaredanews/screens/today/CustomDivider.dart';
import 'package:aljaredanews/screens/today/today.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:timelines/timelines.dart';

import '../../models/UserInfo.dart';
import '../../provider/articleProvider.dart';
import '../../provider/settingProvider.dart';
import '../settings/settings.dart';
import '../../utils/adabtiveText.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late ProfileController controller;
  UserInfo? user;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getJournlistArt() async {
    await controller.getJournlistArt(context);
    user = controller.user;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller = ProfileController(context);
    controller.fontsizeSetting(context);
    user = controller.user;

    getJournlistArt();

    WidgetsBinding.instance!
        .addPostFrameCallback((_) => {controller.faderController.fadeIn()});
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String greet = controller.greeting();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              leading: InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: Settings(), withNavBar: false);
                  },
                  child: Icon(Icons.settings,color: Provider.of<Setting>(context,listen: false).nightmode!? Stylesss().nightElement: Colors.indigo.shade700,)),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'الجريدة',
                style: TextStyle(
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 32),
                ),
              ),
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                
                controller:controller.refreshController,
                onRefresh: () async {
                  await controller.onRefresh(context);
                  setState(() {});
                },
                header: MaterialClassicHeader(
                  backgroundColor:  Provider.of<Setting>(context,
                                                listen: false)
                                            .nightmode ==
                                        true
                                    ? Colors.blueGrey.shade900
                                    : Colors.white,
                  color: Provider.of<Setting>(context,
                                                listen: false)
                                            .nightmode ==
                                        true
                                    ? Colors.white
                                    : Colors.black,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min, // Use children total size
                    children: [
                      Gap(20.sp),
                        CustomDivider(size: size),

                      Padding(
                        padding: EdgeInsets.only(
                            right: size.width * .03, top: size.height * .00),
                        child: Container(
                            alignment: Alignment.topRight,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  '$greet',
                                  textStyle:  GoogleFonts.arefRuqaa(
            fontWeight: FontWeight.bold,
            fontSize: 22
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
                        padding: EdgeInsets.only(right: size.width * .08),
                        child: Container(
                            alignment: Alignment.topRight,
                            child:  Text(
                                  ' ${user!.userName}',
                                  style:  TextStyle(
                                    fontSize: 24,
                                    color: Provider.of<Setting>(context,listen: false).nightmode!? Stylesss().nightElement: Colors.indigo.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),),
                      ),
  CustomDivider(size: size),
                      SizedBox(
                        height: size.height * .02,
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
                                if (articleProv.articles == null) {
                                  return Container(
                                    child: Center(
                                      child: LoadingFadingLine.circle(),
                                    ),
                                  );
                                }
        
                                if (articleProv.articles!.length == 0) {
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
                                  return controller.getJournlistArticlesWid(
                                      articleProv, context);
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
                          ? CustomDivider(size: size)
                          : Container(),
        
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MainTitle(
                            text: '  المحفوظات',
                            fontSize: controller.fontsize!),
                      ),
                      Gap(3.h),
                      //saved articles and news
                      Consumer<ArticlePrvider>(
                          builder: (context, articleProv, _) {
                        // try {
                        List<Widget> timeLineD = [];
                        List<Widget> articlesColumn = [];
        
                        for (int i = 0;
                            i < user!.savedArticles!.length;
                            i++) {
                          timeLineD.add(Text(
                            intl.DateFormat.yMMMEd('ar_SA').format(
                              user!.savedArticles![i].createdAt!,
                            ),
                            style: TextStyle(
                              fontSize: AdaptiveTextSize()
                                  .getadaptiveTextSizeSetting(context, 18,
                                      Provider.of<Setting>(context).fontSize),
                              fontWeight: FontWeight.w800,
                            ),
                          ));
                          // if (user!.savedArticles![i].articletype![0] ==
                          //     'article') {
                          articlesColumn.add(
                              TimelineItem(user: user, i: i, size: size));
                        }
                        if (articlesColumn.isNotEmpty) {
                          return Expanded(
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
                            height: size.height * .3,
                            child: Center(
                              child: Text(
                                'لا توجد منشورات محفوظة',
                              ),
                            ),
                          );
                        }
                      }),
                    
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserSavedArtiNew() async {
    controller.getUserSavedArtiNew(context);
    user = controller.user;
  }
}
