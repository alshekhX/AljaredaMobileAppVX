import 'dart:io';
import 'dart:math';

import 'package:aljaredanews/classes/nightmode.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:aljaredanews/widgets/CustomShimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../main.dart';
import '../../provider/articleProvider.dart';
import '../../provider/auth.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';

class ArticleWidget extends StatefulWidget {
  const ArticleWidget({
    Key? key,
    @required this.context,
    @required this.imageUrl,
    @required this.title,
    @required this.headline,
    @required this.arthur,
    @required this.description,
    @required this.size,
    @required this.category,
    @required this.id,
    @required this.userPhoto,
  }) : super(key: key);

  final BuildContext? context;
  final String? imageUrl;
  final String? title;
  final String? headline;
  final String? arthur;
  final String? description;
  final Size? size;
  final String? category;
  final String? id;
  final String? userPhoto;

  @override
  _ArticleWidgetState createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  bool? _isConnected;

  bool bookMarked = false;
  @override
  Widget build(BuildContext contextt) {
    Random rnd;
    int min = 3;
    int max = 6;
    rnd = new Random();
    int random = min + rnd.nextInt(max - min);

    final saved =
        Provider.of<AuthProvider>(context, listen: false).user!.savedArticles;

    for (int i = 0; i < saved!.length; i++) {
      if (widget.id == saved[i].id) {
        bookMarked = true;
      }
    }

    return Padding(
      padding: EdgeInsets.only(
          top: widget.size!.height * .02, bottom: widget.size!.height * .01),
      child: Container(
        width: widget.size!.width * .98,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Provider.of<Setting>(context, listen: false).nightmode!
              ? Colors.grey.shade500
              : Colors.black,
          width: 2,
        ))),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  SizedBox(
                    width: AljaredaConst().pagePadding,
                  ),
                  Container(
                    width: widget.size!.width * .80,
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.bottomRight,
                    child: Text(widget.headline!,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.w500,
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSizeSetting(context, 26,
                                  Provider.of<Setting>(context).fontSize),
                        )

                        // TextStyle(
                        //   fontWeight: FontWeight.w500,
                        //             fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 26, Provider.of<Setting>(context).fontSize),

                        // ),
                        ),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.topLeft,
                    child: PopupMenuButton<String>(
                      child: bookMarked == true
                          ? Icon(
                              Icons.bookmark_added_outlined,
                              color: Provider.of<Setting>(context,listen: false).nightmode!? Stylesss().nightElement: Colors.indigo.shade700,
                            )
                          : Icon(Icons.bookmark_add_outlined),
                      onSelected: (value) async {
                        switch (value) {
                          case 'حفظ في الصفحة الشخصية':
                            String internetConn =
                                await _checkInternetConnection();

                            if (internetConn == 'false') {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message:
                                      "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
                                ),
                              );
                              break;
                            }
                            String token = Provider.of<AuthProvider>(context,
                                    listen: false)
                                .token!;
                            String res = await Provider.of<ArticlePrvider>(
                                    widget.context!,
                                    listen: false)
                                .savedArticleToUser(widget.id!, token);
                            print(res);

                            if (res == 'success') {
                              print('yes mother fucker');

                              setState(() {
                                bookMarked = true;
                              });

                              ScaffoldMessenger.of(widget.context!)
                                  // ignore: prefer_const_constructors
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "تم حفظ المقال في الصفحة الشخصية"),
                              ));
                            } else {
                              ScaffoldMessenger.of(widget.context!)
                                  // ignore: prefer_const_constructors
                                  .showSnackBar(SnackBar(
                                content: const Text("خطأ ولم يتم حفظ المقال"),
                              ));
                              ScaffoldMessenger.of(widget.context!)
                                  // ignore: prefer_const_constructors
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "تم حفظ المقال في الصفحة الشخصية"),
                              ));
                            }
                            break;
                          case 'الغاء':
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'حفظ في الصفحة الشخصية', 'الغاء'}
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                   SizedBox(
                    width: AljaredaConst().pagePadding-3.w,
                  ),
                ],
              ),
            ),
//headline

            Padding(
              padding: EdgeInsets.only(
                  right: widget.size!.width * .02,
                  top: widget.size!.height * .01,
                  bottom: widget.size!.height * .01),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left:    
                     AljaredaConst().pagePadding-3.w,
                        bottom: widget.size!.height * .015,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Provider.of<Setting>(context, listen: false)
                                  .nightmode!
                              ? Colors.white.withOpacity(.70)
                              : Color(0xff212427).withOpacity(.8),

                          width: 0.3, // Underline thickness
                        ))),
                        child: Text(
                          widget.category!,
                          style: GoogleFonts.tajawal(
                            color: Provider.of<Setting>(context, listen: false)
                                    .nightmode!
                                ? Colors.white.withOpacity(.70)
                                : Color(0xff212427).withOpacity(.8),
                            fontWeight: FontWeight.w800,
                            fontSize: AdaptiveTextSize()
                                .getadaptiveTextSizeSetting(context, 22,
                                    Provider.of<Setting>(context).fontSize),
                          ),

                          //       style: TextStyle(color : Provider.of<Setting>(context,
                          //                                       listen: false)
                          //                                   .nightmode!
                          //                               ? Colors.white.withOpacity(.70)
                          //                               :  Color(0xff212427).withOpacity(.8),
                          //                   fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 16, Provider.of<Setting>(context).fontSize),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Provider.of<Setting>(context, listen: false)
                              .nightmode!
                          ? Colors.white.withOpacity(.70)
                          : Color(0xff212427).withOpacity(.8),
                          

                      width: 0.8, // Underline thickness
                    ))),
                    margin: EdgeInsets.only(bottom: widget.size!.height * .005),
                    alignment: Alignment.bottomRight,
                    child: Text(widget.arthur!,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.tajawal(
                          color: Provider.of<Setting>(context, listen: false)
                                  .nightmode!
                              ? Colors.white.withOpacity(.70)
                              : Color(0xff212427).withOpacity(.8),
                          fontWeight: FontWeight.w800,
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSizeSetting(context, 22,
                                  Provider.of<Setting>(context).fontSize),
                        )

                        //  TextStyle(
                        //   decorationStyle: TextDecorationStyle.wavy,
                        //   color : Provider.of<Setting>(context,
                        //                                   listen: false)
                        //                               .nightmode!
                        //                           ? Colors.white.withOpacity(.70)
                        //                           :  Color(0xff212427).withOpacity(.8),

                        //              fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 22, Provider.of<Setting>(context).fontSize),

                        // ),
                        ),
                  ),
                  SizedBox(
                    width: widget.size!.width * .01,
                  ),
                  Container(
                      margin:
                          EdgeInsets.only(bottom: widget.size!.height * .015),
                      height: widget.size!.height * .08,
                      width: widget.size!.height * .08,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            Provider.of<Setting>(context, listen: false)
                                    .nightmode!
                                ? Colors.white
                                : Colors.black,
                        backgroundImage: widget.userPhoto != 'no_image.jpg'
                            ? NetworkImage(
                                AljaredaConst.BasePicUrl +
                                    widget.userPhoto!) as ImageProvider
                            : AssetImage('assets/profilePlace.png')
                                as ImageProvider,
                      )),
                      SizedBox(width:  AljaredaConst().pagePadding-3.w,)
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       right: widget.size.width * .03, bottom:widget.size.height * .01),
                  //   width: widget.size.width * .07,
                  //   height: widget.size.height * .05,
                  //   child:  Provider.of<Setting>(context,listen: false).nightmode?Icon(Ionicons.pencil):Image.asset('assets/pen.png'),
                  // ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: widget.size!.height * .01),
              child: Container(
                width: widget.size!.width * .92,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  placeholder: (context, url) => CustomShimmer(height: 34.h,padding: 1.sp,),
                  errorWidget: (context, url, error) => CustomShimmer(height: 34.h,padding: 1.sp,),
                ),
              ),
            ),
            SizedBox(
              height: widget.size!.height * .02,
            )
            //description
          ],
        ),
      ),
    );
  }

  Future<String> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
        return 'success';
      }
      return 'success';
    } on SocketException catch (err) {
      return 'false';
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'save article':
        break;
      case 'Settings':
        break;
    }
  }
}
