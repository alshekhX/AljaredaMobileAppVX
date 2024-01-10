
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:aljaredanews/widgets/CustomShimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' as intl;

class JournlistExpansionCard extends StatelessWidget {
  const JournlistExpansionCard({
    Key? key,
    required this.articles,
    required this.i,
    required this.size,
  }) : super(key: key);

  final List? articles;
  final int i;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
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
            ? AljaredaConst.BasePicUrl +
                articles![i].photo!
            : articles![i].assets!
                    .isNotEmpty
            ? AljaredaConst.BasePicUrl +
                    articles![i]
                        .assets![0]
                : 
            AljaredaConst.BasePicUrl +
                    articles![i]
                        .photo!,
        placeholder: (context, url) =>
           CustomShimmer(padding: 0, height: 25.h),
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
    );
  }
}