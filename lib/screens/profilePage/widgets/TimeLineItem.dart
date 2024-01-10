
import 'package:aljaredanews/ArticleHtml/htmltext.dart';
import 'package:aljaredanews/models/UserInfo.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:aljaredanews/widgets/CustomShimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    Key? key,
    required this.user,
    required this.i,
    required this.size,
  }) : super(key: key);

  final UserInfo? user;
  final int i;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          PersistentNavBarNavigator.pushNewScreen(
              context,
              pageTransitionAnimation:
                  PageTransitionAnimation.scale,
              screen: HtmlText(user!.savedArticles![i]),
              withNavBar: false);
        },
        child: Container(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Container(
                width: size.width * .4,
                child: CachedNetworkImage(
                  imageUrl: user!.savedArticles![i]
                              .articletype ==
                          'article'
                      ? AljaredaConst.BasePicUrl +
                          user!.savedArticles![i].photo!
                      : user!.savedArticles![i].assets!
                              .isNotEmpty
                          ? AljaredaConst.BasePicUrl  +
                              user!.savedArticles![i]
                                  .assets![0]
                          : AljaredaConst.BasePicUrl  +
                              user!.savedArticles![i]
                                  .photo!,
                  placeholder: (context, url) =>
                    CustomShimmer(padding: 0, height: 20.h),
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
              Container(
                width: size.width * .40,
                child: Text(
                  user!.savedArticles![i].title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AdaptiveTextSize()
                        .getadaptiveTextSizeSetting(
                            context,
                            
                            18,
                            Provider.of<Setting>(
                                    context)
                                .fontSize),
                  ),
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          ),
        ));
  }
}
