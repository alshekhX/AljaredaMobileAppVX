
import 'package:aljaredanews/widgets/AppProgressBar.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/utils/utilMethod.dart';
import 'package:aljaredanews/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginController {
  final formKey = GlobalKey<FormState>();

//textfields
  TextEditingController? emailController;
  TextEditingController? passwordController;

  LoginController() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  String? customValidtaor(String? fieldContent) =>
      fieldContent!.isEmpty ? 'Ce champ est obligatoire.' : null;


  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    formKey.currentState!.dispose();
  }


  login(Size size, BuildContext context) async {
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
              .signIN(emailController!.text.replaceAll(' ', ''),
                  emailController!.text);
          print(res);
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
