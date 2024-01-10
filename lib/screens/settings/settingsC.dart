import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/screens/settings/widgets/Buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {

  SharedPreferences? prefs;
  String? fontSubtitle;

double value = 1;
  double fontsize = .8;
  List<S2Choice<double>> options = [
    S2Choice<double>(value: .65, title: 'خط صغير'),
    S2Choice<double>(value: .8, title: 'خط متوسط'),
    S2Choice<double>(value: 1, title: 'خط كبير'),
  ];
  bool? nightmode;


  SettingsController(BuildContext context){
        fontsize = Provider.of<Setting>(context, listen: false).fontSize;


  }
  
  nightMode() async {
    prefs = await SharedPreferences.getInstance();
  }

  
  loadSetting(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fontsize = Provider.of<Setting>(context, listen: false).fontSize;
    print(fontsize);
    if (prefs.getString('fontsizestring') != null) {
      print(prefs.getString('fontsizestring'));

      fontSubtitle = prefs.getString('fontsizestring')!;
    } else {
      fontSubtitle = 'متوسط';
    }
  }

  
  logOutDialg(BuildContext context) {
    // set up the buttons
    Widget cancelButton = CancelButton();
    Widget continueButton = ContinueButton();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("تسجيل الخروج")),
      content: Text(
        "إضغط موافق لتأكيد العملية",
        textDirection: TextDirection.rtl,
      ),
      actions: [
        cancelButton,
        continueButton,
        Spacer(),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}