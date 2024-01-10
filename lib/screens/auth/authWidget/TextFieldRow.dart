
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TextFieldRow extends StatelessWidget {
  const TextFieldRow({
    Key? key,
    required this.size,
     required this.authTextfield, required this.title,
  }) : super(key: key);

  final Size size;
  final Widget authTextfield;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 7.w,
        ),
        Center(
          child: Container(
              margin: EdgeInsets.all(2),
              width: size.width * .6,
              child: authTextfield),
        ),
        SizedBox(
          width: 2.w,
        ),
        SizedBox(
          width: 25.w,
          child: AutoSizeText(
            title,
            maxLines: 1,
            minFontSize: 2,
            maxFontSize: 20,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        )
      ],
    );
  }
}