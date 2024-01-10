import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryController{
      List? news;
            List? articles;



CategoryController(){




}


  getNews(BuildContext context) async {
    String token =
        await Provider.of<AuthProvider>(context, listen: false).token!;

    // String cate = Provider.of<ArticlePrvider>(context, listen: false).category;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getCategoryArticles(token);
    if (res == 'success') {
      news = Provider.of<ArticlePrvider>(context, listen: false).articles;
    }
  }
  
  getArticles(BuildContext context) async {
    String token =
        await Provider.of<AuthProvider>(context, listen: false).token!;

    // String cate = Provider.of<ArticlePrvider>(context, listen: false).category;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getCategoryArticles(token);
    if (res == 'success') {
      articles = Provider.of<ArticlePrvider>(context, listen: false).articles;
    }
  }


}