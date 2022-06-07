
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

import 'auth/login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  double value = 1;
  double fontsize=.8 ;
  List<S2Choice<double>> options = [
    S2Choice<double>(value: .65, title: 'خط صغير'),
    S2Choice<double>(value: .8, title: 'خط متوسط'),
    S2Choice<double>(value: 1, title: 'خط كبير'),
  ];
  bool? nightmode;

  loadSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fontsize = Provider.of<Setting>(context, listen: false).fontSize;
    print(fontsize);
    if (prefs.getString('fontsizestring') != null) {
      print(prefs.getString('fontsizestring'));

      fontSubtitle = prefs.getString('fontsizestring')!;
      setState(() {});
    } else {
      fontSubtitle = 'متوسط';
      setState(() {});
    }
  }

  SharedPreferences? prefs;
  String ?fontSubtitle;
  @override
  void initState() {
    nightMode();

    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadSetting();
    });
    super.initState();
  }

  nightMode() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          'الإعدادات',
          style: TextStyle(
  fontFamily: 'Elmiss' ,
                        fontWeight: FontWeight.w600,
            
              fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 35),
              ),
        ),
      ),
      body: Container(
        color: Provider.of<Setting>(context, listen: false).nightmode!
            ? Colors.blueGrey.shade900
            : Colors.white,
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(
                  Icons.language,
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
                onTap: () async {},
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(
                  Icons.text_fields,
                  color: Provider.of<Setting>(context, listen: false).nightmode!
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  'حجم الخط',
                  style: TextStyle(
                    fontSize: AdaptiveTextSize()
                        .getadaptiveTextSizeSetting(context, 22, fontsize),
                  ),
                ),
                subtitle: Text('$fontSubtitle',
                    style: TextStyle(
                      fontSize: AdaptiveTextSize()
                          .getadaptiveTextSizeSetting(context, 14, fontsize),
                    )),
                onTap: () async {
                  return smartSelectFontSize();
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(
                  Icons.language,
                  color: Provider.of<Setting>(context, listen: false).nightmode!
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  'الوضع الليلي',
                  style: TextStyle(
                    fontSize: AdaptiveTextSize()
                        .getadaptiveTextSizeSetting(context, 22, fontsize),
                  ),
                ),
                trailing: Container(
                  child: Consumer<Setting>(builder: (context, settingsProv, _) {
                    return Switch(
                      value: settingsProv.nightmode!,
                      onChanged: (isDarkModeEnabled) async {
                        settingsProv.changeNightMode(isDarkModeEnabled);
                        prefs!.setBool('nightmode', isDarkModeEnabled);
                        setState(() {});
                      },
                    );
                  }),
                ),
              ),
            ),

            
            Container(
              width: size.width * .9,
              child: Divider(
                thickness: 1,
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Provider.of<Setting>(context, listen: false).nightmode!
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontSize: AdaptiveTextSize()
                        .getadaptiveTextSizeSetting(context, 22, fontsize),
                  ),
                ),
                onTap: () async {
                  await showAlertDialog(context);
                },
              ),
            ),
            
          ],
        ),
        // child: SettingsList(
        //   backgroundColor: Colors.white,
        //   sections: [
        //     SettingsSection(
        //       tiles: [
        //         SettingsTile(
        //           title: 'اللغة',
        //           subtitle: 'العربية',
        //           leading: Icon(
        //             Icons.language,
        //             color: Colors.black,
        //           ),
        //           onPressed: (BuildContext context) {},
        //         ),
        //         SettingsTile(
        //             title: 'حجم الخط',
        //             subtitle: 'متوسط',
        //             leading: Icon(
        //               Icons.text_fields,
        //               color: Colors.black,
        //             ),
        //             onPressed: (BuildContext context) async {
        //               Provider.of<Setting>(context, listen: false)
        //                   .changeFontSize(1.5);
        //               double fSize =
        //                   Provider.of<Setting>(context, listen: false).fontSize;

        //               SharedPreferences prefs =
        //                   await SharedPreferences.getInstance();
        //               await prefs.setDouble('counter', fSize);
        //                 smartSelectFontSize();
        //             }),
        //         SettingsTile.switchTile(
        //           title: 'الوضع الليلي',
        //           leading: Icon(
        //             Icons.mode_night,
        //             color: Colors.black,
        //           ),
        //           switchValue: false,
        //           onToggle: (bool value) {},
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ),
    );
  }

  smartSelectFontSize() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 16,
              child: SmartSelect<double>.single(
                  modalHeader: false,
                  modalStyle: S2ModalStyle(
                    backgroundColor:
                        Provider.of<Setting>(context, listen: false).nightmode!
                            ? Colors.grey.shade800
                            : Colors.white,
                  ),
                  modalType: S2ModalType.popupDialog,
                  title: 'تغير الخط',
                  placeholder: 'إختر ',
                  choiceStyle: S2ChoiceStyle(
                      activeColor:
                          Provider.of<Setting>(context, listen: false).nightmode!
                              ? Color(0xff93b2ff)
                              : Colors.indigo.shade700,
                      titleStyle: TextStyle(
                          color: Provider.of<Setting>(context, listen: false)
                                  .nightmode!
                              ? Colors.white
                              : Colors.black,
                          fontFamily: 'Almari',
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSizeSetting(
                                  context, 20, fontsize))),
                  choiceItems: options,
                  onChange: (state) async {
                    Provider.of<Setting>(context, listen: false)
                        .changeFontSize(state.value);
                    Provider.of<Setting>(context, listen: false)
                        .changeFontSizeString(state.valueTitle);
                    fontSubtitle = Provider.of<Setting>(context, listen: false)
                        .fontSizeString;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setDouble('fontsize', state.value);
                    await prefs.setString('fontsizestring', state.valueTitle);
                    print(state.valueTitle);
                    print(state.value);
                    loadSetting();
                    setState(() => value = state.value);
                  }));
        });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء",style: TextStyle(color:  Provider.of<Setting>(context, listen: false).nightmode!
                            ? Colors.white
                            : Colors.black,)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("موافق",style: TextStyle(color:  Provider.of<Setting>(context, listen: false).nightmode!
                            ? Colors.white
                            : Colors.black,),),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('userToken');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("تسجيل الخروج")),
      content: Text("إضغط موافق لتأكيد العملية"
      ,textDirection: TextDirection.rtl,),
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
