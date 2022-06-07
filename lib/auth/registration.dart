
import 'package:aljaredanews/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../provider/auth.dart';
import '../provider/settingProvider.dart';
import '../utils/adabtiveText.dart';
import '../widgets/navBar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ?firstNameC, lastNameC, userNameC, passwordC;
  TextEditingController ?emailC;

  @override
  void initState() {
    firstNameC = TextEditingController();
    lastNameC = TextEditingController();
    userNameC = TextEditingController();
    emailC = TextEditingController();
    passwordC = TextEditingController();

   
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'الجريدة',
            style: TextStyle(
              
                fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 40),
                fontFamily: 'Elmiss',
                      fontWeight: FontWeight.w600,),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .05,
              ),
              Center(
                child: Container(
                  child: Text(
                    'تسجيل جديد',
                    style: TextStyle(
                      fontSize:
                          AdaptiveTextSize().getadaptiveTextSize(context, 38),
                      fontWeight: FontWeight.w700,
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
                        Container(
                          child: Row(
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
                                        contentPadding:
                                            EdgeInsets.all(size.height * .02),
                                        border: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(width: 2.0),
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
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يجب إدخال الاسم الأول';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: firstNameC,
                                      textAlign: TextAlign.right,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width * .02,
                                    right: size.width * .01),
                                child: Text(
                                  'الإسم الأول',
                                  style: TextStyle(
                                    fontSize: AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 18),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
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
                                        contentPadding:
                                            EdgeInsets.all(size.height * .02),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2.0),
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
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يجب إدخال الاسم الأخير';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: lastNameC,
                                      textAlign: TextAlign.right,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width * .02,
                                    right: size.width * .01),
                                child: Text(
                                  'الإسم الأخير',
                                  style: TextStyle(
                                    fontSize: AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 18),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
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
                                        contentPadding:
                                            EdgeInsets.all(size.height * .02),
                                        border: OutlineInputBorder(
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
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يجب إدخال الاسم المستعار';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: userNameC,
                                      textAlign: TextAlign.right,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width * .02,
                                    right: size.width * .01),
                                child: Text(
                                  'إسم المستخدم',
                                  style: TextStyle(
                                    fontSize: AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 18),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * .07,
                              ),
                              Center(
                                child: Container(
                                    margin: EdgeInsets.all(2),
                                    width: size.width * .6,
                                    child: TextFormField(
                                      validator:    (value) {
                                      Pattern pattern =
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                      RegExp regex =
                                          new RegExp(pattern.toString());
                                      if (!regex.hasMatch(value!) ||
                                          value.isEmpty)
                                        return 'الرجاء إدخال بريد الكتروني صحيح';
                                    },
                                      controller: emailC,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.all(size.height * .02),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2.0),
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
                                      // validator: validateEmail,
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.right,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width * .02,
                                    right: size.width * .01),
                                child: Text(
                                  'البريد الإلكتروني',
                                  style: TextStyle(
                                    fontSize: AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 18),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
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
                                        contentPadding:
                                            EdgeInsets.all(size.height * .02),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2.0),
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
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يجب إدخال  كلمة السر';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.go,
                                      controller: passwordC,
                                      textAlign: TextAlign.right,
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
                                      : Colors.black)),
                          child: FlatButton(
                            color: Provider.of<Setting>(context, listen: false)
                                    .nightmode!
                                ? Colors.blueGrey.shade900
                                : Colors.white,
                            onPressed: () async {
                                                                                                   CustomProgressDialog     pr = CustomProgressDialog(context, blur: 10,loadingWidget:   Container(
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
                                try {
                                  String res = await Provider.of<AuthProvider>(
                                          context,
                                          listen: false)
                                      .registerUser(
                                          firstNameC!.text,
                                          lastNameC!.text,
                                          userNameC!.text,
                                          emailC!.text.replaceAll(' ', ''),
                                          passwordC!.text);
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
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavBar()),
                                        (route) => false);
                                  } else {
                                    if (pr.isShowed) {
                                       pr.dismiss();
                                    }

                                    showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: "$res خطأ في التسجيل",
                                      ),
                                    );
                                  }
                                } catch (e) {
                                   pr.dismiss();
                                  print(e);
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: "$e خطأ في التسجيل",
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              child: Text(
                                'تسجيل',
                                style: TextStyle(
                                  fontSize: AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 18),
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
              SizedBox(
                height: size.height * .14,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: size.width * .2,
                  right: size.width * .1,
                  bottom: size.height * .01,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        child: Text('تسجيل الدخول',
                            style: TextStyle(
                              fontSize: AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 26),
                              fontWeight: FontWeight.w900,
                            )),
                      ),
                    ),
                    Container(
                        child: Text('  تمتلك حساب ؟ ',
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
    );
  }

   validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'الرجاء ادخال بريد الكتروني صحيح';
   
  }
}
