
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/settingProvider.dart';

class Game extends StatelessWidget {
  const Game({
    Key? key,
    @required this.context,
    @required this.imageUrl,
    @required this.text,
    @required this.size,
  }) : super(key: key);

  final BuildContext ?context;
  final String? imageUrl;
  final String? text;
  final Size ?size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(top: size!.height * .03, bottom: size!.height * .03),
      width: size!.width * 0.73,
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
         
              height: size!.height * 0.25,
              child: 
              
              
              Image.asset(imageUrl!, color:  Provider.of<Setting>(context,listen: false).nightmode!?Colors.white  :
null,)),
        ],
      ),
    );
  }
}