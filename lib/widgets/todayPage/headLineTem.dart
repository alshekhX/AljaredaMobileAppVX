
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';

class HeadLine extends StatelessWidget {
  const HeadLine({
    Key? key,
    @required this.context,
    @required this.imageUrl,
    @required this.text,
    @required this.size,
  }) : super(key: key);

  final BuildContext? context;
  final String? imageUrl;
  final String? text;
  final Size ?size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: size!.width * 0.73,
      child: Card(
        child: Stack(
          children: [
            Container(
                child: CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) =>Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
          child: Container(
      width: size!.width * 0.73,
            height: size!.height*.26,
            color: Colors.white,
            
          ),
        )
,
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),),
            Positioned(
              width: size!.width * .6,
              bottom: 5,
              right: 3,
              child: Container(
                decoration: BoxDecoration(
                    color:  Provider.of<Setting>(context,listen: false).nightmode!?Colors.blueGrey.shade800 .withOpacity(.8) :
Colors.grey.shade200.withOpacity(.8),
                    border: Border.all(color: Colors.black, width: .5)),
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:  EdgeInsets.all(size!.height*.008),
                  child:
                  
                  
                   Text(
                    text!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    textDirection: TextDirection.rtl,
                    
                    style: TextStyle(
                                                                                               fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 18, Provider.of<Setting>(context).fontSize),

                      fontWeight: FontWeight.w800,
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

