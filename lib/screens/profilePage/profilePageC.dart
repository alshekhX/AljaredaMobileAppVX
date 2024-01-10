import 'package:aljaredanews/ArticleHtml/htmltext.dart';
import 'package:aljaredanews/models/Article.dart';
import 'package:aljaredanews/models/UserInfo.dart';
import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/auth.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/utils/utilMethod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileController {
  bool? _isConnected;
  List? articles;
  double? fontsize;

  final FaderController faderController = new FaderController();
  UserInfo? user;
  final RefreshController refreshController = RefreshController();

  ProfileController(BuildContext context) {
    user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  void fontsizeSetting(BuildContext context) async {
    fontsize = Provider.of<Setting>(context, listen: false).fontSize;
    print(fontsize);
  }

  Future<void> getJournlistArt(BuildContext context) async {
    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    await Provider.of<ArticlePrvider>(context, listen: false)
        .getJournlistArticles(user!.id!, token);
    articles =
        Provider.of<ArticlePrvider>(context, listen: false).journlistArticles;
  }

  onRefresh(BuildContext context) async {
    String internetConn = await UtilMethod().checkInternetConnection();

    if (internetConn == 'false') {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
        ),
      );
      refreshController.refreshFailed();
    } else {
      // monitor network fetch
      await getUserSavedArtiNew(context);
            print('shit');

      // if failed,use refreshFailed()
      refreshController.refreshCompleted();
    }
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return ' نهارك سعيد';
    } else {
      return 'مساء الخير ';
    }
  }

  Future<void> getUserSavedArtiNew(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).getUserData();
    user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  Padding getJournlistArticlesWid(
      ArticlePrvider articleProv, BuildContext context) {
    List<Widget> articlesColumn = [];

    for (int i = 0; i < articleProv.articles!.length; i++) {
      if (articles![i].articletype[0] != 'breaking') {
        articlesColumn.add(InkWell(
            onTap: () async {
              articleProv.article = articles![i];
              ArticleModel articleModel = articles![i];

              PersistentNavBarNavigator.pushNewScreen(context,
                  pageTransitionAnimation: PageTransitionAnimation.scale,
                  screen: HtmlText(articleModel),
                  withNavBar: false);
            },
            child: Container(
              alignment: Alignment.bottomRight,
              width: 90.w,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Card(
                  margin: EdgeInsets.all(10),
                ),
              ),
            )));
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: articlesColumn,
      ),
    );
  }
}
