
import 'package:aljaredanews/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
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

         PersistentNavBarNavigator.  pushNewScreen(context,
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
            contentPadding:EdgeInsets.only(right: AljaredaConst().pagePadding),
            leading: FaIcon(
              icon,
              color: Provider.of<Setting>(context,
                                                        listen: false)
                                                    .nightmode!
                                                ? Colors.white.withOpacity(.87)
                                                :  Color(0xff212427),
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
