

import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * .98,
      child: Divider(
        color: Provider.of<Setting>(context,
                    listen: false)
                .nightmode!
            ? Colors.grey.shade500
            : Color(0xff212427),
        thickness: 3,
      ),
    );
  }
}
