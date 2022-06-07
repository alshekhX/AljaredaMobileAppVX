import 'dart:io';

import 'package:aljaredanews/auth/registration.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../provider/articleProvider.dart';
import '../provider/auth.dart';
import '../provider/settingProvider.dart';
import '../utils/adabtiveText.dart';
import '../widgets/navBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? emailController;
  TextEditingController? passwordController;

  bool? _isConnected;

  // This function is triggered when the floating button is pressed
  Future<String> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
        return 'success';
      }
      return 'success';
    } on SocketException catch (err) {
      return 'false';
    }
  }

  @override
  void initState() {
   
    passwordController =  TextEditingController();
    emailController =  TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textfieldText = 'البريد الإلكتروني';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'الجريدة',
            style: TextStyle(
               fontFamily: 'Elmiss',
                      fontWeight: FontWeight.w600,
              
                fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 40),
               ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height * .865,
          ),
          child: IntrinsicHeight(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * .15,
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSize(context, 40),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Center(
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * .07,
                                ),
                                Center(
                                  child: Container(
                                      margin: EdgeInsets.all(2),
                                      width: size.width * .6,
                                      child: TextFormField(
                                           validator: (value) {
                                      Pattern pattern =
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                      RegExp regex =
                                          new RegExp(pattern.toString());
                                      if (!regex.hasMatch(value!) ||
                                          value.isEmpty)
                                        return 'الرجاء إدخال بريد الكتروني صحيح';
                                    },
                                        // validator: validateEmail,
                                        controller: emailController,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.all(size.height * .02),
                                          border: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(width: 2.0),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Provider.of<Setting>(
                                                                context,
                                                                listen: false)
                                                            .nightmode ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black,
                                                width: 2.0),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                        textAlign: TextAlign.right,
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: size.width * .02,
                                      right: size.width * .01),
                                  child: Text(
                                    textfieldText,
                                    style: TextStyle(
                                      fontSize: AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 18),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * .07,
                                ),
                                Center(
                                  child: Container(
                                      margin: EdgeInsets.all(2),
                                      width: size.width * .6,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(
                                              size.height * .02), // Added this

                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Provider.of<Setting>(
                                                                context,
                                                                listen: false)
                                                            .nightmode ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black,
                                                width: 2.0),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                        controller: passwordController,
                                        textAlign: TextAlign.right,
                                        validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'أدخل كلمة السر';
                                        }
                                        return null;
                                      },
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: size.width * .03,
                                      right: size.width * .01),
                                  child: Text(
                                    'كلمة السر',
                                    style: TextStyle(
                                      fontSize: AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 18),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Provider.of<Setting>(context,
                                                  listen: false)
                                              .nightmode!
                                          ? Colors.grey.shade600
                                          : Colors.black,
                                      width: 1)),
                              child: FlatButton(
                                color:
                                    Provider.of<Setting>(context, listen: false)
                                            .nightmode!
                                        ? Colors.blueGrey.shade900
                                        : Colors.white,

                                onPressed: () async {
                                                                     CustomProgressDialog     pr = CustomProgressDialog(context, blur: 10,loadingWidget:  Container(
                                                                       height:  size.width * .25,
                                                                       width:  size.width * .25,
decoration: BoxDecoration(
        color: Colors.white,

    border: Border.all(
      color: Colors.white,
      
    ),
    borderRadius: BorderRadius.all(Radius.circular(20))
  ),                                                                       child: LoadingFlipping.circle()));

                                  if (_formKey.currentState!.validate()) {
                                     pr.show();

                                    String internetConn =
                                        await _checkInternetConnection();

                                    if (internetConn == 'false') {
                                       pr.dismiss();
                                      setState(() {});

                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          message:
                                              "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
                                        ),
                                      );
                                    } else {
                                      try {
                                           await initializeDateFormatting('ar_SA', null);

                                      
                                        String res =
                                            await Provider.of<AuthProvider>(
                                                    context,
                                                    listen: false)
                                                .signIN(emailController!.text.replaceAll(' ', ''),
                                                    passwordController!.text);
                                        print(res);
                                        if (res == 'success') {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          prefs.setString(
                                              'userToken',
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .token!);
                                                  
                                          pr.dismiss();

                                         

                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BottomNavBar()),
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
                                },

                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => BottomNavBar(
                                //               // Center is a layout widget. It takes a single child and positions it
                                //               // in the middle of the parent.
                                //               )));

                                child: Container(
                                  child: Text(
                                    'تسجيل',
                                    style: TextStyle(
                                      fontSize: AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 20),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        left: size.width * .25,
                        right: size.width * .15,
                        bottom: size.height * .01),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationScreen()));
                          },
                          child: Container(
                            child: Text('سجل هنا',
                                style: TextStyle(
                                  fontSize: AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 26),
                                  fontWeight: FontWeight.w900,
                                )),
                          ),
                        ),
                        Container(
                            child: Text('   لا تمتلك حسابا ؟  ',
                                style: TextStyle(
                                  fontSize: AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 18),
                                  fontWeight: FontWeight.w900,
                                )))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'الرجاء ادخال بريد إلكتروني صحيح';
  
  }
}
