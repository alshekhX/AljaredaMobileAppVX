
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../provider/articleProvider.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';
import '../cateBottomNavBar.dart';

class CategoryTileTemp extends StatelessWidget {
  const CategoryTileTemp({
    Key? key,
    @required this.context,
    @required this.text,
    @required this.icon,
    @required this.category,
  }) : super(key: key);

  final BuildContext? context;
 
  final String ?text;
  final IconData? icon;
  final String? category;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Provider.of<ArticlePrvider>(context, listen: false).category = category;
        print(category);

        pushNewScreen(context,
            pageTransitionAnimation: PageTransitionAnimation.scale,
            screen: CategBottomNavBar(),
            withNavBar: false);
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CategBottomNavBar()));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * .01),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: FaIcon(
              icon,
              color:  Provider.of<Setting>(context,listen: false).nightmode!?Colors.white  :
Colors.black,
            ),
            title: Text(
              text!,
              style: TextStyle(
                             fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 25, Provider.of<Setting>(context).fontSize),
),
            ),
          ),
        ),
      ),
    );
  }
}
