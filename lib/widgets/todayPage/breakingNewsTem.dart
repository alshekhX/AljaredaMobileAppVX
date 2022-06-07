
import 'package:avatar_glow/avatar_glow.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';

class BreakingNewsTem extends StatelessWidget {
  const BreakingNewsTem({
    Key? key,
    @required this.context,
    @required this.text,
    @required this.size,
    @required this.time,
  }) : super(key: key);

  final BuildContext? context;
  final String? text;
  final Size ?size;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     border: Border(
      //         bottom: BorderSide(
      //       color: Colors.red,
      //     ))),
      margin: EdgeInsets.only(
          left: size!.width * .02,
          right: size!.width * .02,
          top: size!.width * .02,
          bottom: size!.width * .0),
      child: Wrap(
        children: [

         
          Row(
            children: [
              Spacer(),
              Padding(
                padding:  EdgeInsets.only(bottom:size!.height*.01),
                child: Container(

                    width: size!.width * .9,
                    // margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.bottomRight,
                    child: BorderedText(strokeWidth: 1,
                      strokeColor:  Colors.black,
                      
                      child: Text(
                        'عاجل',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 60, Provider.of<Setting>(context).fontSize),
                        ),
                      ),
                    )),
              ),
                   Padding(
                     padding:  EdgeInsets.only(top: size!.width*.02),
                     child: AvatarGlow(
                       
                                                        endRadius: size!.width*.03,
                                                        glowColor: Colors.red,
                                                        duration: Duration(
                                                            milliseconds: 1200),
                                                        repeat: true,
                                                        showTwoGlows: true,
                                                        repeatPauseDuration:
                                                            Duration(
                                                                milliseconds: 50),
                                                        child: Container(
                                                          // margin: EdgeInsets.only(top: 10),
                                                          width: size!.width * .03,
                                                          height: size!.width * .03,
                                                          child: CircleAvatar(
                                                                                                                      backgroundColor:Colors.red,

                                                            foregroundColor: Colors.red,
                                                            radius: 71,
                                                    
                                                          ),
                                                        ),
                                                      ),
                   ),
                                          
            ],
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(size!.width * .01),
              child: Container(
                width: size!.width * .95,
                alignment: Alignment.bottomRight,
                child: Text(
                  text!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                                      fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 22, Provider.of<Setting>(context).fontSize),

                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: size!.height * .01,top: size!.height * .01),
            alignment: Alignment.bottomLeft,
            child: Text(
              time!,
              textDirection: TextDirection.rtl,
              style: TextStyle(                fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 16, Provider.of<Setting>(context).fontSize),
),
            ),
          ),
        ],
      ),
    );
  }
}


