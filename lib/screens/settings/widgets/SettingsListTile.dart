import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    Key? key,
    required this.fontsize,
    required this.title,
    required this.subTitle,
    this.function, required this.iconData,
  }) : super(key: key);

  final double fontsize;
  final String title;
  final String subTitle;
  final IconData iconData;
  final void Function()? function;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: Icon(
        iconData,
          color: Provider.of<Setting>(context, listen: false).nightmode!
              ? Colors.white
              : Colors.black,
        ),
        title: Text(
          'اللغة',
          style: TextStyle(
            fontSize: AdaptiveTextSize()
                .getadaptiveTextSizeSetting(context, 22, fontsize),
          ),
        ),
        subtitle: Text('العربية',
            style: TextStyle(
              fontSize: AdaptiveTextSize()
                  .getadaptiveTextSizeSetting(context, 14, fontsize),
            )),
        onTap: function,
      ),
    );
  }
}
