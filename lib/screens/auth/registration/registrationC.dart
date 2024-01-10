import 'dart:io';

import 'package:aljaredanews/widgets/AppProgressBar.dart';
import 'package:aljaredanews/models/Article.dart';
import 'package:aljaredanews/models/UserInfo.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/utils/utilMethod.dart';
import 'package:aljaredanews/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegController {
  final formKey = GlobalKey<FormState>();
//controller
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? usernameController;
  TextEditingController? phoneController;

//constructor
  RegController() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    usernameController = TextEditingController();
    phoneController = TextEditingController();
  }


//disposer
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    phoneController!.dispose();
    usernameController!.dispose();
    formKey.currentState!.dispose();
  }

  signUp(Size size, BuildContext context, UserInfo userInfo) async {
    CustomProgressDialog pr = AppClassBar(context: context).pr!;

    if (formKey.currentState!.validate()) {
      pr.show();

      String internetConn = await UtilMethod().checkInternetConnection();

      if (internetConn == 'false') {
        pr.dismiss();

        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
          ),
        );
      } else {
        try {
          await initializeDateFormatting('ar_SA', null);

          String res = await Provider.of<AuthProvider>(context, listen: false)
              .registerUser(userInfo, passwordController!.text);
          if (res == 'success') {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setString('userToken',
                Provider.of<AuthProvider>(context, listen: false).token!);

            pr.dismiss();

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => BottomNavBar()),
                (route) => false);
          } else {
            pr.dismiss();
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: "$res خطأ في التسجيل",
              ),
            );
          }
        } catch (e) {
          pr.dismiss();

          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: "$e",
            ),
          );
        }
      }
    }
  }
}
