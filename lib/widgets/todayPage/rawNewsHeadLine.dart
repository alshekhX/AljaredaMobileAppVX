
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';

class RawNewsHLine extends StatelessWidget {
  const RawNewsHLine({
    Key? key,
    @required this.context,
    @required this.text,
    @required this.color,
    @required this.size,
  }) : super(key: key);

  final BuildContext ?context;
  final String? text;
  final Color ?color;
  final Size ?size;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: Provider.of<Setting>(context,listen: false).nightmode!?Colors.blueGrey.shade900:Colors.white, border: Border.all(color:  Provider.of<Setting>(context,
                                                                          listen:
                                                                              false)
                                                                      .nightmode!
                                                                  ? Colors.grey
                                                                      .shade300
                                                                  : Colors.black, width: 2)),
          width: size!.width * 0.73,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text!,
              style: TextStyle(
                fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 20),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ));
  }
}
