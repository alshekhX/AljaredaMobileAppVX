
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/Category/categoryNews.dart';
import '../pages/categoryArticls.dart';
import '../provider/articleProvider.dart';
import '../provider/settingProvider.dart';
import '../utils/adabtiveText.dart';


class CategBottomNavBar extends StatefulWidget {
  const CategBottomNavBar({ Key ?key }) : super(key: key);

  @override
  _CategBottomNavBarState createState() => _CategBottomNavBarState();
}

class _CategBottomNavBarState extends State<CategBottomNavBar> {
 

  PersistentTabController ?_controller;



ScrollController ?_scrollViewController;
bool _showAppbar = true; 
bool isScrollingDown = false;

@override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);

    // TODO: implement initState
    super.initState();
      _scrollViewController = new ScrollController();
  _scrollViewController!.addListener(() {
    if (_scrollViewController!.position.userScrollDirection == ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        _showAppbar = false;
        setState(() {});
      }
    }

    if (_scrollViewController!.position.userScrollDirection == ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        _showAppbar = true;
        setState(() {});
      }
    }
  });
  }



  @override
void dispose() {
  
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
 String category =
        Provider.of<ArticlePrvider>(context, listen: false).category!;
    return DefaultTabController(length: 2,
    
      child: Scaffold(
        
      
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            
                      category,
                      style:TextStyle(   
                          fontFamily: 'Elmiss' ,
                        fontWeight: FontWeight.w600,                         
fontSize: AdaptiveTextSize()
                                    .getadaptiveTextSizeSetting(context, 35, Provider.of<Setting>(context).fontSize),
                         ),
                    ),
          bottom: TabBar(
              indicatorWeight: 5,   
              indicatorSize: TabBarIndicatorSize.tab,   
            indicatorColor:                                                      Colors.lightBlue[100],
 
          
          tabs: [
          Tab(text:"أخبار" ,icon:Icon(FontAwesomeIcons.newspaper) ,),
    
          Tab(text: 'مقالات',icon:  Icon(CupertinoIcons.pencil),),
        ],
        
        ),
        
        
        ),
         body:
         
         
          TabBarView(
           
        children: [
          CategoryNews() ,CategoryArticls()
        ],
      ),
      ),
    );
    // return 
  //    Scaffold(
      
  //         body: PersistentTabView(
  //         context,
  //         controller: _controller,
  //         screens: _buildScreens(),
  //         items: _navBarsItems(),
          
  //         confineInSafeArea: true,
  //         backgroundColor: Provider.of<Setting>(context,listen: false).nightmode?Colors.blueGrey.shade700:Colors.white , // Default is Colors.white.
  //         handleAndroidBackButtonPress: false, // Default is true.
  //         resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
  //         stateManagement: false, // Default is true.
  //         hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
  //         // decoration: NavBarDecoration(
  //         //   borderRadius: BorderRadius.circular(10.0),
  //         //   colorBehindNavBar: Colors.white,
  //         // ),
  //         popAllScreensOnTapOfSelectedTab: true,
  //         popActionScreens: PopActionScreensType.all,
  //         itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
  //           duration: Duration(milliseconds: 200),
  //           // curve: Curves.ease,
  //         ),
  //         screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
  //           animateTabTransition: true,
  //           curve: Curves.ease,
  //           duration: Duration(milliseconds: 200),
  //         ),
  //         navBarStyle: NavBarStyle.style2, // Choose the nav bar style with this property.
  //     ),
  //   );
  // }
  }
    List<Widget> _buildScreens() {
        return [
          CategoryArticls(),CategoryNews()
          
         
        ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.pencil),
                title: ("مقالات"),  activeColorPrimary: Provider.of<Setting>(context,listen: false).nightmode!?Color(0xff93b2ff): Colors.indigo.shade700,
                 textStyle: TextStyle(  fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 18, Provider.of<Setting>(context).fontSize),
),
                inactiveColorPrimary:  Provider.of<Setting>(context,listen: false).nightmode!? Colors.grey.shade400: Colors.black, ),
            PersistentBottomNavBarItem(
                icon: Icon(FontAwesomeIcons.newspaper),
                title: ("اخبار"),
                 activeColorPrimary: Provider.of<Setting>(context,listen: false).nightmode!? Color(0xff93b2ff): Colors.indigo.shade700,
                 textStyle: TextStyle(  fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 18, Provider.of<Setting>(context).fontSize),
),
                inactiveColorPrimary:  Provider.of<Setting>(context,listen: false).nightmode!? Colors.grey.shade400: Colors.black, ),
          
        ];
    }
}