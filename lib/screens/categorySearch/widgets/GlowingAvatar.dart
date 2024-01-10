

import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class JournGlowingAvatar extends StatelessWidget {
  const JournGlowingAvatar({
    Key? key, this.i,
  }) : super(key: key);
  final dynamic i;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AvatarGlow(
        endRadius: 100,
        glowColor: Colors.blue,
        duration: Duration(milliseconds: 1500),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 50),
        child: Container(
          // margin: EdgeInsets.only(top: 10),
          width: 40.w,
          height: 40.w,
          child: CircleAvatar(
            radius: 74,
            backgroundColor:
                Provider.of<Setting>(context, listen: false).nightmode!
                    ? Colors.white
                    : Colors.black,
            child: CircleAvatar(
                radius: 71,
                backgroundImage: i.photo != 'no_image.jpg'
                    ? NetworkImage(AljaredaConst.BasePicUrl + i.photo)
                        as ImageProvider
                    : AssetImage('assets/profilePlace.png') as ImageProvider),
          ),
        ),
      ),
    );
  }
}
