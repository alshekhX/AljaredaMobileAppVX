
import 'package:aljaredanews/widgets/CustomShimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';

class HeadLine extends StatelessWidget {
  const HeadLine({
    Key? key,
    @required this.context,
    @required this.imageUrl,
    @required this.text,
  }) : super(key: key);

  final BuildContext? context;
  final String? imageUrl;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width:73.w,
      child: Card(
        child: Stack(
          children: [
            Container(
                child: CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) =>CustomShimmer(height: 25.h,padding: 5.sp,)
,
        errorWidget: (context, url, error) => CustomShimmer(height: 25.h,padding: 5.sp,),
     ),),
            Positioned(
              width:60.w,
              bottom: 5,
              right: 3,
              child: Container(
                decoration: BoxDecoration(
                    color:  Provider.of<Setting>(context,listen: false).nightmode!?Colors.blueGrey.shade800 .withOpacity(.8) :
Colors.grey.shade200.withOpacity(.8),
                    border: Border.all(color: Colors.black, width: .5)),
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:  EdgeInsets.all(.08.h),
                  child:
                  
                  
                   Text(
                    text!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    textDirection: TextDirection.rtl,
                    
                    style: TextStyle(
                                                                                               fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 18, Provider.of<Setting>(context).fontSize),

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

