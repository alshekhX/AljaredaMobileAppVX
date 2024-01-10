
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/navBar.dart';
import '../auth/login/login.dart';
import 'myHomePageC.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MyHomePageController controller;
  


  @override
  void initState() {
    controller =MyHomePageController();
     controller.verifyuserToken(context);
    controller. determinePosition();
    controller.loadSetting(context);
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder(
          future:      controller.verifyuserToken(context),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (controller.alredyLogged == true) {
                return BottomNavBar();
              } else
                return LoginScreen();
            } else {
              return Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    child: Lottie.asset('assets/lott/earth.json')),
              );
            }
          },
        ));
  }
}
