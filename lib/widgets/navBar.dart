
import 'package:aljaredanews/classes/nightmode.dart';
import 'package:aljaredanews/screens/categorySearch/categorysearch.dart';
import 'package:aljaredanews/screens/profilePage/profilePage.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../screens/today/today.dart';
import '../provider/settingProvider.dart';
import '../utils/adabtiveText.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({ Key? key }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
 

  PersistentTabController? _controller;



ScrollController? _scrollViewController;
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
  _scrollViewController!.dispose();
  _scrollViewController!.removeListener(() {});
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
          body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Provider.of<Setting>(context,listen: false).nightmode!?Colors.grey.shade900:Colors.white , // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          // decoration: NavBarDecoration(
          //   borderRadius: BorderRadius.circular(10.0),
          //   colorBehindNavBar: Colors.white,
          // ),
          popAllScreensOnTapOfSelectedTab: true,
          
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            // curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style12, // Choose the nav bar style with this property.
      ),
    );
  }

    List<Widget> _buildScreens() {
        return [
          Today(),Search(),
          PersonalPage()
          
         
        ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.news_solid),
                title: ("اليوم"),
                activeColorPrimary: Provider.of<Setting>(context,listen: false).nightmode!?Stylesss().nightElement: Colors.indigo.shade700,
                 textStyle: TextStyle(  fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, AljaredaConst().bottomNavText, Provider.of<Setting>(context).fontSize),
),
                inactiveColorPrimary:  Provider.of<Setting>(context,listen: false).nightmode!? Colors.grey.shade400: Colors.black,
            ),
            PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.search),
                title: ("البحث"),
                activeColorPrimary: Provider.of<Setting>(context,listen: false).nightmode!?Stylesss().nightElement: Colors.indigo.shade700,
                 textStyle: TextStyle(  fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, AljaredaConst().bottomNavText, Provider.of<Setting>(context).fontSize),
),
                inactiveColorPrimary:  Provider.of<Setting>(context,listen: false).nightmode!? Colors.grey.shade400: Colors.black,
            ),
              PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                title: ("الشخصية"),
                activeColorPrimary: Provider.of<Setting>(context,listen: false).nightmode!? Stylesss().nightElement: Colors.indigo.shade700,
                 textStyle: TextStyle(  fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, AljaredaConst().bottomNavText, Provider.of<Setting>(context).fontSize),
),
                inactiveColorPrimary:  Provider.of<Setting>(context,listen: false).nightmode!? Colors.grey.shade400: Colors.black,
            )
          
        ];
    }
}