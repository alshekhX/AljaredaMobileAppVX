import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    Key? key,
    required this.size,
    required this.validation,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;
  final String? Function(String?)? validation;
 
  final Size size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validation,
      // validator: validateEmail,
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(size.height * .02),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 2.0),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color:
                  Provider.of<Setting>(context, listen: false).nightmode == true
                      ? Colors.white
                      : Colors.black,
              width: 2.0),
          borderRadius: BorderRadius.zero,
        ),
      ),
      textAlign: TextAlign.right,
    );
  }
}
