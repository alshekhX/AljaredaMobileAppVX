
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../provider/settingProvider.dart';

class Game extends StatelessWidget {
  const Game({
    Key? key,
    @required this.context,
    @required this.imageUrl,
    @required this.text,
  }) : super(key: key);

  final BuildContext ?context;
  final String? imageUrl;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(top: 3.h, bottom: 3.h),
      width: 73.w,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              text!,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                           fontSize: const AdaptiveTextSize().getadaptiveTextSizeSetting(context, 30, Provider.of<Setting>(context).fontSize),

                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
         
              height: 25.h,
              child: 
              
              
              Image.asset(imageUrl!, color:  Provider.of<Setting>(context,listen: false).nightmode!?Colors.white  :
null,)),
        ],
      ),
    );
  }
}