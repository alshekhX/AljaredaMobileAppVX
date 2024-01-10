import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/provider/settingProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'classes/nightmode.dart';
import './screens/myHomePage/myHomePage.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ArticlePrvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => Setting())
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? prefs;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Provider.of<Setting>(context, listen: false).nightmode = false;
    super.initState();
  }

  nightMode() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs != null) {
      if (prefs!.getBool('nightmode') != null) {
        Provider.of<Setting>(context, listen: false)
            .changeNightMode(prefs!.getBool('nightmode')!);
      }
    } else {
      Provider.of<Setting>(context, listen: false).changeNightMode(false);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    nightMode();

    print('object');

    return Sizer(builder: (context, orientation, deviceType) {
      return Consumer<Setting>(
        builder: (context, sProv, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: Stylesss.themeData(
                Provider.of<Setting>(context, listen: false).nightmode!,
                context),
            home: const MyHomePage(),
          );
        },
      );
    });
  }
}
