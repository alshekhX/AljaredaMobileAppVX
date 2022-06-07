import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widgets/navBar.dart';
import 'auth/login.dart';
import 'classes/nightmode.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ArticlePrvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => Setting())
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  // final lightTheme = ThemeData(
  //   fontFamily: 'Almari',
  //   primarySwatch: Colors.grey,
  //   primaryColor: Colors.white,
  //   brightness: Brightness.light,
  //   backgroundColor: const Color(0xFFE5E5E5),
  //   accentColor: Colors.black,
  //   accentIconTheme: IconThemeData(color: Colors.white),
  //   dividerColor: Colors.white54,
  // );
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? prefs;
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);

    Provider.of<Setting>(context, listen: false).nightmode = false;
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   nightMode();
    //   setState(() {});
    // });
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
    return Consumer<Setting>(
      builder: (context, sProv, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: Stylesss.themeData(
              Provider.of<Setting>(context, listen: false).nightmode!, context),
          // ThemeData(
          //   // This is the theme of your application.
          //   //
          //   // Try running your application with "flutter run". You'll see the
          //   // application has a blue toolbar. Then, without quitting the app, try
          //   // changing the primarySwatch below to Colors.green and then invoke
          //   // "hot reload" (press "r" in the console where you ran "flutter run",
          //   // or simply save your changes to "hot reload" in a Flutter IDE).
          //   // Notice that the counter didn't reset back to zero; the application
          //   // is not restarted.
          //   primaryColor: Colors.white, fontFamily: 'Almari',

          //   // This makes the visual density adapt to the platform that you run
          //   // the app on. For desktop platforms, the controls will be smaller and
          //   // closer together (more dense) than on mobile platforms.
          //   visualDensity: VisualDensity.adaptivePlatformDensity,
          // ),
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? prefs;
  bool? alredyLogged;

  verifyuserToken() async {
    try {
      await initializeDateFormatting('ar_SA', null);

      prefs = await SharedPreferences.getInstance();
      if (prefs!.getString('userToken') != null) {
        Provider.of<AuthProvider>(context, listen: false).token =
            prefs!.getString('userToken')!;

        await Provider.of<AuthProvider>(context, listen: false).getUserData();
        alredyLogged = true;
      } else {
        alredyLogged = false;
      }
    } catch (e) {
      alredyLogged = false;
    }
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  loadSetting() async {
    //TODO
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble('fontsize') != null &&
        prefs.getString('fontsizestring') != null) {
      Provider.of<Setting>(context, listen: false).fontSize =
          prefs.getDouble('fontsize')!;

      Provider.of<Setting>(context, listen: false).fontSizeString =
          prefs.getString('fontsizestring')!;
    } else {
      Provider.of<Setting>(context, listen: false).fontSize = .8;
      Provider.of<Setting>(context, listen: false).fontSizeString = "متوسط";
    }
  }

  @override
  void initState() {
    verifyuserToken();
    _determinePosition();
    loadSetting();
    super.initState();
    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder(
          future: verifyuserToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (alredyLogged == true) {
                return BottomNavBar();
              } else
                return LoginScreen();
            } else {
              return Center(child:             Container(
                width: MediaQuery.of(context).size.width*.4,
                height:  MediaQuery.of(context).size.width*.4,
                child: Lottie.asset('assets/lott/earth.json')),
);
            }
          },
        ));
  }
}
