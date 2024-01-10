
import 'package:aljaredanews/screens/auth/login/login.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ContinueButton extends StatelessWidget {
  const ContinueButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "موافق",
        style: TextStyle(
          color: Provider.of<Setting>(context, listen: false).nightmode!
              ? Colors.white
              : Colors.black,
        ),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('userToken');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      },
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text("إلغاء",
          style: TextStyle(
            color: Provider.of<Setting>(context, listen: false).nightmode!
                ? Colors.white
                : Colors.black,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
