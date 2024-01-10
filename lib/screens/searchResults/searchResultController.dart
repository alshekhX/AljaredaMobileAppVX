import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultController{

bool? loading;

  List? searchedArticles;
  Icon searchIcon =   const Icon(Icons.cancel);
  var newVariable = '';

 

  Widget? appBarTitle;

SearchResultController(){
  

}


  Future search(String text, context) async {
   
    try {
      String token = Provider.of<AuthProvider>(context, listen: false).token!;
      await Provider.of<ArticlePrvider>(context, listen: false)
          .getSearchedArticles(text, token);
      searchedArticles =
          Provider.of<ArticlePrvider>(context, listen: false).searchedArticles;
      if (searchedArticles!.isEmpty) {
        newVariable = 'لا توجد نتيجة ';
      }
        loading = false;
      
    } catch (e) {
      newVariable = 'تاكد من تشغيل بيانات الهاتف';
        loading = false;
    }
  }






}