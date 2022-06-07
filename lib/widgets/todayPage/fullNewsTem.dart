import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart' as intl;

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../provider/articleProvider.dart';
import '../../provider/auth.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';

class FullNews extends StatefulWidget {
  const FullNews({
    Key ?key,
    @required this.context,
    @required this.imageUrl,
    @required this.headline,
    @required this.arthur,
    @required this.place,
    @required this.size,
    @required this.color,
    @required this.opacity,
    @required this.id,
  }) : super(key: key);

  final BuildContext? context;

  final String ?imageUrl;
  final String ?headline;
  final String ?arthur;
  final String ?place;
  final Size ?size;
  final Color? color;
  final double? opacity;
  final String ?id;

  @override
  _FullNewsState createState() => _FullNewsState();
}

class _FullNewsState extends State<FullNews> {
  bool _isConnected=false;

  bool bookMarked = false;
  @override
  Widget build(BuildContext contextt) {
    final saved =
        Provider.of<AuthProvider>(context, listen: false).user!.savedArticles;

    for (int i = 0; i < saved!.length; i++) {
      if (widget.id == saved[i].id) {
        setState(() {
                  bookMarked = true;

        });
      }
    }
    return Center(
      child: Container(
        width: widget.size!.width * .96,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 2,color: Provider.of<Setting>(context,listen: false).nightmode!?Colors.grey.shade500  :
Colors.black), )
           ),
        child: Column(
          children: [
            SizedBox(height: widget.size!.height*.01,),

//titlSizede
 //headline
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  SizedBox(
                    width: widget.size!.width * .02,
                  ),
                  Container(
                    width: widget.size!.width * .8,
                    margin: EdgeInsets.only(bottom: 5, ),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      widget.headline!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
            fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 24, Provider.of<Setting>(context).fontSize),

                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.topLeft,
                    child: PopupMenuButton<String>(
                      child: bookMarked == true
                          ? Icon(
                              Icons.bookmark_added_outlined,
                              color: Colors.lightBlue,
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
                            
 String token =  Provider.of<AuthProvider>(
                                    widget.context!,
                                    listen: false)
                                .token!;
                            String res = await Provider.of<ArticlePrvider>(
                                    widget.context!,
                                    listen: false)
                                .savedArticleToUser(widget.id!,token);
                            print(res);

                            if (res == 'success') {
                              print('yes mother fucker');
                            
                              setState(() {
                                bookMarked = true;
                              });

                                ScaffoldMessenger.of(widget.context!)
                                  .showSnackBar(SnackBar(
                                content: Text("تم حفظ الخبر في الصفحة الشخصية"),
                              ));
                            } else {
                              ScaffoldMessenger.of(widget.context!)
                                  .showSnackBar(SnackBar(backgroundColor: 
                                  
                                   Provider.of<Setting>(context,listen: false).nightmode!? Colors.black.withOpacity(.7): Colors.blueGrey.shade300,
                                content: Text("خطأ, لم يتم حفظ الخير"),
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
                    width: widget.size!.width * .01,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                
                Spacer(),
                Container(
                  child: Text(
                    ': ${widget.place}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                                 fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 16, Provider.of<Setting>(context).fontSize),

                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.arthur!,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                                 fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(context, 16, Provider.of<Setting>(context).fontSize),

                    ),
                  ),
                ),
                SizedBox(
                  width: widget.size!.width * .015,
                ),

                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(
                      right: widget.size!.width * .04,  left: widget.size!.width * .001),
                  
                  child: Icon(Ionicons.glasses_outline,
                  size: widget.size!.width * .08* Provider.of<Setting>(context).fontSize,),
                ),
              ],
            ),
            
  SizedBox(
                    height: widget.size!.height * .005,
                  ),                                                                                                                                                                                                                                                                                                                                          
           Container(
             width: widget.size!.width*.85,
                child: CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        placeholder: (context, url) =>Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
          child: Container(
        width: widget.size!.width * .96,
            height: widget.size!.height*.34,
            color: Colors.white,
            
          ),
        )
,
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),),
     SizedBox(
                     height: widget.size!.height * .01,

     ),
     //TODO
      // Align(
      //           alignment: Alignment.topLeft,
                
      //           child: Padding(
      //             padding: EdgeInsets.only(
      //                 right: widget.size.width * .03, bottom: widget.size.height * .01 ,),
      //             child: Row(
      //               children: [
      //                 Text(
      //                         intl.DateFormat.Hm('ar_SA').format(
      //                          DateTime.now(),
      //                         ),)
      //               ],
      //             ),
      //           ),
      //         ),

            //description
            Container(
              height: widget.size!.height * .01,
              margin: EdgeInsets.all(10),
            ),

          ],
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'save article':
        break;
      case 'Settings':
        break;
    }
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
}
