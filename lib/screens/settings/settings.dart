import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/screens/settings/settingsC.dart';
import 'package:aljaredanews/screens/settings/widgets/SettingsListTile.dart';
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SettingsController controller;
  loadSetting() async {
    await controller.loadSetting(context);
    setState(() {});
  }
  
  nightMode() async {
    await controller.nightMode();
  }

  @override
  void initState() {
    controller = SettingsController(context);
    nightMode();

    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_){
      loadSetting();
    });
    super.initState();
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
            fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 35),
          ),
        ),
      ),
      body: Container(
        
        child: Column(
          children: [
            SettingsListTile(
              fontsize: controller.fontsize,
              iconData: Icons.language,
              subTitle: 'إختر اللغة',
              title: 'اللغة',
              function: () {},
            ),
            SettingsListTile(
                fontsize: controller.fontsize,
                iconData: Icons.abc,
                subTitle: '${controller.fontSubtitle}',
                title: 'حجم الخط',
                function: () async {
                  return smartSelectFontSize();
                }),
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
                        .getadaptiveTextSizeSetting(context, 22,  controller.fontsize,),
                  ),
                ),
                trailing: Container(
                  child: Consumer<Setting>(builder: (context, settingsProv, _) {
                    return Switch(
                      value: settingsProv.nightmode!,
                      onChanged: (isDarkModeEnabled) async {
                        settingsProv.changeNightMode(isDarkModeEnabled);
                        controller.prefs!.setBool('nightmode', isDarkModeEnabled);
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
            SettingsListTile(
              fontsize:  controller.fontsize,
              iconData: Icons.exit_to_app,
              subTitle: 'إختر اللغة',
              title: 'تسجيل الخروج',
              function: () async {
                await controller. logOutDialg(context);
              },
            ),
          ],
        ),
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
                    accentColor:
                        Provider.of<Setting>(context, listen: false).nightmode!
                            ? Color(0xff93b2ff)
                            : Colors.indigo.shade700,
                    titleStyle: TextStyle(
                        color: Provider.of<Setting>(context, listen: false)
                                .nightmode!
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'Almari',
                        fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                            context, 20,  controller.fontsize,))),
                choiceItems: controller.options,
                onChange: (state) async {
                  Provider.of<Setting>(context, listen: false)
                      .changeFontSize(state.value!);
                  Provider.of<Setting>(context, listen: false)
                      .changeFontSizeString(state.placeholder!);
                  controller.fontSubtitle = Provider.of<Setting>(context, listen: false)
                      .fontSizeString;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setDouble('fontsize', state.value!);
                  await prefs.setString('fontsizestring', state.placeholder!);
                  loadSetting();
                  setState(() => controller.value = state.value!);
                },
                selectedValue: 0,
              ));
        });
  }

}
