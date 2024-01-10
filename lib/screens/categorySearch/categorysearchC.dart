
import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySearchController {
  double? fontsize;
  List? journlists;
  
  CategorySearchController() {
  }

  void fontsizeSetting(BuildContext context) async {
    fontsize = Provider.of<Setting>(context, listen: false).fontSize;
    print(fontsize);
  }

  
  
  getJornlists(BuildContext context) async {
     String token =
        await Provider.of<AuthProvider>(context, listen: false).token!;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getAllJournlists(token);
    if (res == 'success') {
      journlists =  Provider.of<ArticlePrvider>(context, listen: false).journlists;
      print(journlists);
    }
  }
}







