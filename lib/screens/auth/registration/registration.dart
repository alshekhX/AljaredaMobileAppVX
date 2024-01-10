import 'package:aljaredanews/screens/auth/authWidget/AuthFooter.dart';
import 'package:aljaredanews/screens/auth/authWidget/AuthTextField.dart';
import 'package:aljaredanews/screens/auth/authWidget/TextFieldRow.dart';
import 'package:aljaredanews/screens/auth/login/login.dart';
import 'package:aljaredanews/screens/auth/registration/TextFieldGap.dart';
import 'package:aljaredanews/screens/auth/registration/registrationC.dart';
import 'package:aljaredanews/models/UserInfo.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/utils/utilMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegController controller;
  @override
  void initState() {
    controller = RegController();
    // TODO: implement initState
    super.initState();
  }
  
  @override
  void dispose() {
    controller.dispose();
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              const Center(
                child: Text(
                  'تسجيل جديد',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              Center(
                child: Container(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFieldRow(
                            size: size,
                            authTextfield: AuthTextField(
                                size: size,
                                validation: UtilMethod().usernameValidation,
                                controller: controller.usernameController!),
                            title: 'إسم المستخدم'),
                        const TextFieldGap(),
                        TextFieldRow(
                            size: size,
                            authTextfield: AuthTextField(
                                size: size,
                                validation:UtilMethod().emailValidation,
                                controller: controller.emailController!),
                            title: ' البريد الألكتروني'),
                        const TextFieldGap(),
                        TextFieldRow(
                            size: size,
                            authTextfield: AuthTextField(
                                size: size,
                                validation: UtilMethod().phoneValidation,
                                controller: controller.phoneController!),
                            title: '  رقم الهاتف'),
                        const TextFieldGap(),
                        TextFieldRow(
                            size: size,
                            authTextfield: AuthTextField(
                                size: size,
                                validation: UtilMethod().passwordValidation,
                                controller: controller.passwordController!),
                            title: 'كلمة السر'),
                        const TextFieldGap(),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Provider.of<Setting>(context,
                                              listen: false)
                                          .nightmode!
                                      ? Colors.grey.shade600
                                      : Colors.black,
                                  width: 1)),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary:
                                  Provider.of<Setting>(context, listen: false)
                                          .nightmode!
                                      ? Colors.blueGrey.shade900
                                      : Colors.white,
                            ),
                            onPressed: () async {
                              String email = controller.emailController!.text
                                  .replaceAll(' ', '');
                              String username =
                                  controller.usernameController!.text;
                              String phone = controller.phoneController!.text;

                              UserInfo user = UserInfo(
                                  email: email,
                                  phone: phone,
                                  userName: username);

                              controller.signUp(size, context,user);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5.sp,horizontal: 20.sp),
                              child: Text(
                                'تسجيل',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Provider.of<Setting>(context,
                                              listen: false)
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
              ),
              SizedBox(
                height: size.height * .14,
              ),
              AuthFooter(
                  size: size,
                  screenTitle: 'سجل دخولك',
                  screen: const LoginScreen(),
                  title: ' نمتلك حساباً ')
            ],
          ),
        ),
      ),
    );
  }
}

