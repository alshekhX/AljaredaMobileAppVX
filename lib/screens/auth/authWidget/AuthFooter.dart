

import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    Key? key,
    required this.size, required this.screenTitle, required this.screen, required this.title,
  }) : super(key: key);

  final Size size;
  final String screenTitle;
  final Widget screen;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          left: size.width * .25,
          right: size.width * .10,
          bottom: size.height * .03),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => screen));
            },
            child: Container(
              child: Text(screenTitle,
              
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    
                    fontWeight: FontWeight.w900,
                  )),
            ),
          ),
          Container(
              child: Text(title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )))
        ],
      ),
    );
  }
}
