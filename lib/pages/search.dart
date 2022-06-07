
import 'package:aljaredanews/pages/searchScreen.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:timer_builder/timer_builder.dart';

import '../provider/articleProvider.dart';
import '../provider/settingProvider.dart';
import '../utils/adabtiveText.dart';
import '../widgets/searchPage/categoryTileTemp.dart';
import 'journalist.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List? journlists;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  ScrollController? _scrollViewController;

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
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getJornlists();
  }

  @override
  void dispose() {
    _scrollViewController!.dispose();
    _scrollViewController!.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Container(
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {
              pushNewScreen(
                context,
                screen: SearchScreen(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            backgroundColor:  Provider.of<Setting>(context,listen: false).nightmode!?Colors.blueGrey.shade500  :
Colors.white,
            foregroundColor: Provider.of<Setting>(context,listen: false).nightmode!?Colors.white :
Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            label: Padding(
              padding: EdgeInsets.only(right: size.width * .07),
              child: Text('إبحث عن مقال ',
               style: TextStyle(  fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 20, Provider.of<Setting>(context).fontSize),
),),
            ),
            icon: Icon(Icons.search),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                height: _showAppbar ? 56.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  title: Center(
                    child: Text(
                      'الجريدة',
                      style: TextStyle(
                        fontFamily: 'Elmiss' ,
                        fontWeight: FontWeight.w600,
                        
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSize(context, 40),
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      controller: _scrollViewController,
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
                             
                        Container(
                          margin: EdgeInsets.only(
                              top: size.height * .08,
                              right: size.width * .06,
                            ),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'الكتاب',
                            style: TextStyle(
                                          fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 50, Provider.of<Setting>(context).fontSize),
),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.blueGrey.withOpacity(.1),
                          //   border: Border(
                          //       left:
                          //           BorderSide(width: 1.5, color: Colors.black),
                          //       bottom:
                          //           BorderSide(width: 1.5, color: Colors.black),
                          //       top:
                          //           BorderSide(width: 1.5, color: Colors.black),
                          //       right: BorderSide(
                          //           width: 1.5, color: Colors.black)),
                          // ),
                          // height: size.width * .8,
                          // width: size.width * .8,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TimerBuilder.periodic(
                              Duration(seconds: 10),
                              builder: (context) {
                                return Consumer2<ArticlePrvider,AuthProvider>(
                                    builder: (context, journlistProv,authP, _) {
                                
                                  journlistProv.getAllJournlists(authP.token!);
                                  if (journlistProv.journlists == null) {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: size.height * .05),
                                        child: LoadingFlipping.circle(),
                                      );
                                  } else {
                                    return CarouselSlider(
                                      options: CarouselOptions(
                                        height: size.height * .45,
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

                                                pushNewScreen(context,
                                                    pageTransitionAnimation:
                                                        PageTransitionAnimation
                                                            .scale,
                                                    screen: journlist(i),
                                                    withNavBar: false);
                                              },
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: AvatarGlow(
                                                      endRadius: 100,
                                                      glowColor: Colors.blue,
                                                      duration: Duration(
                                                          milliseconds: 1500),
                                                      repeat: true,
                                                      showTwoGlows: true,
                                                      repeatPauseDuration:
                                                          Duration(
                                                              milliseconds: 50),
                                                      child: Container(
                                                        // margin: EdgeInsets.only(top: 10),
                                                        width: size.width * .4,
                                                        height: size.width * .4,
                                                        child: CircleAvatar(
                                                          radius: 74,
                                                          backgroundColor: Provider.of<Setting>(context,listen: false).nightmode!?Colors.white  :
 Colors.black,
                                                          child: CircleAvatar(
                                                            radius: 71,
                                                            backgroundImage:
                                                             i.photo!='no_image.jpg'?   NetworkImage(
                                                                    'http://192.168.43.250:8000/uploads/photos/' +
                                                                        i.photo) as ImageProvider:AssetImage('assets/profilePlace.png') as ImageProvider
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                 
                                                  Container(
                                                    child: Text(
                                                        '${i.firstName} ${i.lastName}',
                                                        style: TextStyle(
                                                                    fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 20, Provider.of<Setting>(context).fontSize),

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

                                  // return GridView.builder(
                                  //     gridDelegate:
                                  //         SliverGridDelegateWithFixedCrossAxisCount(
                                  //             crossAxisCount: 2),
                                  //     itemCount: journlistProv.journlists.length,
                                  //     itemBuilder: (BuildContext context, int pos) {

                                  //       return InkWell(
                                  //         onTap: () {
                                  //           print(pos);

                                  //           pushNewScreen(context,
                                  //               pageTransitionAnimation:
                                  //                   PageTransitionAnimation.scale,
                                  //               screen: journlist(journlistProv.journlists[pos]),
                                  //               withNavBar: false);
                                  //         },
                                  //         child: Column(
                                  //           children: [
                                  //             Center(
                                  //               child: Container(
                                  //                 // margin: EdgeInsets.only(top: 10),
                                  //                 width: size.width * .2,
                                  //                 height: size.width * .2,
                                  //                 child: CircleAvatar(
                                  //                   backgroundImage: NetworkImage('http://192.168.43.250:8000/uploads/photos/' +
                                  //                      journlistProv
                                  //                       .journlists[pos].photo),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Container(
                                  //               child: Text(journlistProv
                                  //                       .journlists[pos].firstName +
                                  //                   '' +
                                  //                   journlistProv
                                  //                       .journlists[pos].lastName),
                                  //             )
                                  //           ],
                                  //         ),
                                  //       );
                                  //     });
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .01,
                        )
                      ]))),
            ],
          ),
        ),
      ),
    );
  }

  getJornlists() async {
     String token =
        await Provider.of<AuthProvider>(context, listen: false).token!;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getAllJournlists(token);
    if (res == 'success') {
      journlists =  Provider.of<ArticlePrvider>(context, listen: false).journlists;
      print(journlists);
      setState(() {});
    }
  }
}
