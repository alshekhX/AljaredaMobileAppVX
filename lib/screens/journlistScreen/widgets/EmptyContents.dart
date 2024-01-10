
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 200,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'لا توجد مقالات او أخبار للكاتب ',
            style: TextStyle(
              fontSize: AdaptiveTextSize()
                  .getadaptiveTextSize(context, 20),
            ),
          ),
          Center(
            child: Text(
              ':(',
              style: TextStyle(
                fontSize: AdaptiveTextSize()
                    .getadaptiveTextSize(
                        context, 20),
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        ],
      ),
    ));
  }
}
