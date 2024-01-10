import 'package:aljaredanews/MainWidgets/DynamicAppBar.dart';
import 'package:aljaredanews/screens/categorySearch/categorysearchC.dart';
import 'package:aljaredanews/screens/categorySearch/widgets/GlowingAvatar.dart';
import 'package:aljaredanews/screens/searchResults/searchResult.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/screens/today/today.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../provider/articleProvider.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';
import '../../widgets/searchPage/categoryTileTemp.dart';
import '../journlistScreen/journalist.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List? journlists;
  late CategorySearchController controller;

  @override
  void initState() {
    controller = CategorySearchController();
    controller.fontsizeSetting(context);
        getJornlists();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  getJornlists() async {
    await controller.getJornlists(context);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Container(
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: SearchScreen(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            backgroundColor:
                Provider.of<Setting>(context, listen: false).nightmode!
                    ? Colors.blueGrey.shade500
                    : Colors.white,
            foregroundColor:
                Provider.of<Setting>(context, listen: false).nightmode!
                    ? Colors.white
                    : Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            label: Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: Text(
                'إبحث عن مقال ',
                style: TextStyle(
                  fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                      context, 18, Provider.of<Setting>(context).fontSize),
                      fontWeight: FontWeight.bold

                ),
              ),
            ),
            icon: Icon(
              Icons.search,
              color: Provider.of<Setting>(context, listen: false).nightmode!
                  ? Colors.white.withOpacity(.87)
                  : Color(0xff212427),
            ),
          ),
        ),
      ),
      body: SafeArea(



        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(slivers: [
                const DynamicAppBar(),
                 
                 
                  SliverToBoxAdapter(
                    child: Column(children: [
                                CategoryTileTemp(
                                    context: context,
                                    text: 'سياسة',
                                    icon: FontAwesomeIcons.handshake,
                                    category: 'سياسة'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'اقتصاد',
                                    icon: FontAwesomeIcons.chartBar,
                                    category: 'إقتصاد'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'أدب',
                                    icon: FontAwesomeIcons.scroll,
                                    category: 'أدب'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'فنون',
                                    icon: FontAwesomeIcons.brush,
                                    category: 'فنون'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'رياضة',
                                    icon: FontAwesomeIcons.futbol,
                                    category: 'رياضة'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'صحة',
                                    icon: FontAwesomeIcons.heartbeat,
                                    category: 'صحة'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'كوارث طبيعية',
                                    icon: FontAwesomeIcons.cloudRain,
                                    category: 'كوارث'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'تكنولوجيا',
                                    icon: FontAwesomeIcons.robot,
                                    category: 'تكنولوجيا'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'فلسفة',
                                    icon: Icons.question_answer,
                                    category: 'فلسفة'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'طعام',
                                    icon: FontAwesomeIcons.utensils,
                                    category: 'طعام'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'علم نفس',
                                    icon: FontAwesomeIcons.brain,
                                    category: 'علم نفس'),
                                CategoryTileTemp(
                                    context: context,
                                    text: 'جريمة',
                                    icon: FontAwesomeIcons.userNinja,
                                    category: 'جريمة'),
                                    Gap(10.sp),
                             Align(
                              alignment: Alignment.bottomRight,
                              child: MainTitle(text: 'الكتٌاب', fontSize: controller.fontsize!)),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TimerBuilder.periodic(
                    Duration(seconds: 10),
                    builder: (context) {
                      return Consumer2<ArticlePrvider, AuthProvider>(
                          builder: (context, journlistProv, authP, _) {
                        journlistProv.getAllJournlists(authP.token!);
                        if (journlistProv.journlists == null) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: LoadingFlipping.circle(),
                          );
                        } else {
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: 45.h,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 2),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 500),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                            ),
                            items: journlistProv.journlists!.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return InkWell(
                                    focusColor: Colors.white10,
                                    onTap: () {
                                      print(i);
                          
                                      PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.scale,
                                          screen: journlist(i),
                                          withNavBar: false);
                                    },
                                    child: Column(
                                      children: [
                                        JournGlowingAvatar(i: i,),
                                        Container(
                                          child: Text(
                                              '${i.firstName} ${i.lastName}',
                                              style: TextStyle(
                                                fontSize: AdaptiveTextSize()
                                                    .getadaptiveTextSizeSetting(
                                                        context,
                                                        20,
                                                        Provider.of<Setting>(
                                                                context)
                                                            .fontSize),
                                              )),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        }
                      });
                    },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                )
                              ]),
                  ),
                ],
              ),
            ),
          ],
        ),
            
        
        
        
        
        
        
        
        
               ),
    );
  }
}