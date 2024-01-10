import 'package:aljaredanews/screens/auth/authWidget/AuthFooter.dart';
import 'package:aljaredanews/screens/auth/authWidget/AuthTextField.dart';
import 'package:aljaredanews/screens/auth/authWidget/TextFieldRow.dart';
import 'package:aljaredanews/screens/auth/login/loginC.dart';
import 'package:aljaredanews/screens/auth/registration/TextFieldGap.dart';
import 'package:aljaredanews/screens/auth/registration/registration.dart';
import 'package:aljaredanews/utils/utilMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import '../../../provider/settingProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // This function is triggered when the floating button is pressed
  late LoginController loginController;

  @override
  void initState() {
    loginController = LoginController();

    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'الجريدة',
            style: TextStyle(
              fontFamily: 'Elmiss',
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            const Center(
              child: Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              height: 9.h,
            ),
            Center(
              child: Form(
                key: loginController.formKey,
                child: Column(
                  children: [
                    TextFieldRow(
                        size: size,
                        authTextfield: AuthTextField(
                          controller: loginController.emailController!,
                          validation: UtilMethod().emailValidation,
                          size: size,
                        ),
                        title: 'البريد الإلكتروني'),
                    const TextFieldGap(),
                    TextFieldRow(
                        size: size,
                        authTextfield: AuthTextField(
                            controller: loginController.passwordController!,
                            validation: UtilMethod().passwordValidation,
                            size: size),
                        title: ' كلمة السر'),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  Provider.of<Setting>(context, listen: false)
                                          .nightmode!
                                      ? Colors.grey.shade600
                                      : Colors.black,
                              width: 1)),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Provider.of<Setting>(context, listen: false)
                                  .nightmode!
                              ? Colors.blueGrey.shade900
                              : Colors.white,
                        ),
                        onPressed: () async {
                          loginController.login(size, context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.sp, horizontal: 20.sp),
                          child: Text(
                            'تسجيل',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color:
                                  Provider.of<Setting>(context, listen: false)
                                          .nightmode!
                                      ? Colors.white.withOpacity(.87)
                                      // ignore: prefer_const_constructors
                                      : Color(0xff212427),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            AuthFooter(
              size: size,
              title: ' لا تمتلك حساباً',
              screenTitle: 'سجل هنا',
              screen: RegistrationScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
