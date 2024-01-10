
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/screens/journlistScreen/journalist.dart';
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JournlistDetails extends StatelessWidget {
  const JournlistDetails({
    Key? key,
    required this.size,
    required this.widget,
  }) : super(key: key);

  final Size size;
  final journlist widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              bottom: size.height * .02,
            ),
          child: Container(
            width: size.width * .4,
            height: size.width * .4,
            child: CircleAvatar(
              backgroundColor: Provider.of<Setting>(context,
                          listen: false)
                      .nightmode!
                  ? Colors.white
                  : Colors.black,
              radius: 74,
              child: CircleAvatar(
                radius: 71,
                backgroundImage: widget
                            .journlistInfo.photo! !=
                        'no_image.jpg'
                    ? NetworkImage(
                        AljaredaConst.BasePicUrl +
                            widget.journlistInfo.photo!,
                      ) as ImageProvider
                    : AssetImage('assets/profilePlace.png'),
              ),
            ),
          ),
        ),
        Container(
          width: size.width * .93,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * .01,
                    left: size.width * .02,
                    right: size.width * .02),
                child: Container(
                  child: Text(
                    '${widget.journlistInfo.firstName} ${widget.journlistInfo.lastName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AdaptiveTextSize()
                            .getadaptiveTextSize(
                                context, 16)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    // top: size.height * .01,
                    left: size.width * .01,
                    right: size.width * .01),
                child: Center(
                  child: Container(
                      child: Text(
                    widget.journlistInfo.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AdaptiveTextSize()
                            .getadaptiveTextSize(
                                context, 16)),
                  )),
                ),
              ),
              Divider(
                color: Provider.of<Setting>(context,
                            listen: false)
                        .nightmode!
                    ? Colors.grey.shade400
                    : Colors.black,
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * .01,
                    bottom: size.height * .02,
                    left: size.width * .01,
                    right: size.width * .01),
                child: Container(
                    decoration: BoxDecoration(),
                    child: Text(
                      widget.journlistInfo.description ==
                              null
                          ? 'لا يوجد وصف'
                          : widget
                              .journlistInfo.description!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSize(
                                  context, 16)),
                    )),
              ),
              Divider(
                color: Provider.of<Setting>(context,
                            listen: false)
                        .nightmode!
                    ? Colors.grey.shade400
                    : Colors.black,
                thickness: 1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
