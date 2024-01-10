import 'package:aljaredanews/models/Article.dart';
import 'package:aljaredanews/models/Journlist.dart';
import 'package:aljaredanews/models/UserInfo.dart';
import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class JournlistController {

  List? articles;
  UserInfo? user;
  
  JournlistController(BuildContext context){
        user = Provider.of<AuthProvider>(context, listen: false).user;
  }


  

  getArticle(BuildContext  context ,User journlist) async {
    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getJournlistArticles(journlist.id!, token);
    if (res == 'success') {
      articles =
          Provider.of<ArticlePrvider>(context, listen: false).journlistArticles;
      print(articles);
    }
  }
}
