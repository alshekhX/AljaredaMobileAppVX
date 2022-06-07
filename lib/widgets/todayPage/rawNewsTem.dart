import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../provider/articleProvider.dart';
import '../../provider/auth.dart';
import '../../provider/settingProvider.dart';
import '../../utils/adabtiveText.dart';

class RawNews extends StatefulWidget {
  const RawNews({
    Key? key,
    @required this.context,
    @required this.text,
    @required this.size,
    @required this.arthur,
    @required this.place,
    @required this.id,
    @required this.assets,
  }) : super(key: key);

  final BuildContext? context;
  final String? text;
  final Size? size;
  final String? arthur;
  final String? place;
  final String? id;
  final List? assets;

  @override
  _RawNewsState createState() => _RawNewsState();
}

class _RawNewsState extends State<RawNews> {
  bool bookMarked = false;
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    final saved =
        Provider.of<AuthProvider>(context, listen: false).user!.savedArticles;

    for (int i = 0; i < saved!.length; i++) {
      if (widget.id == saved[i].id) {
        setState(() {
          bookMarked = true;
        });
      }
    }
    return Container(
      margin: EdgeInsets.only(right: widget.size!.width * .02),
      width: widget.size!.width * 9,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: widget.size!.width * .03),
                child: Container(
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
                          String token = Provider.of<AuthProvider>(
                                  widget.context!,
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
                                .showSnackBar(SnackBar(
                              content: Text("تم حفظ الخبر في الصفحة الشخصية"),
                            ));
                          } else {
                            ScaffoldMessenger.of(widget.context!)
                                .showSnackBar(SnackBar(
                              backgroundColor:
                                  Provider.of<Setting>(context, listen: false)
                                          .nightmode!
                                      ? Colors.black.withOpacity(.7)
                                      : Colors.blueGrey.shade300,
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
              ),
              Spacer(),
              Container(
                width: widget.size!.width * .8,
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: widget.size!.width * .01),
                  child: Text(
                    widget.text!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                          context, 24, Provider.of<Setting>(context).fontSize),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: widget.size!.height * .005,
          ),
          Row(
            children: [
              Spacer(),
              Container(
                child: Text(
                  ': ${widget.place}',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSizeSetting(context, 16,
                            Provider.of<Setting>(context).fontSize),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  widget.arthur!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                        context, 16, Provider.of<Setting>(context).fontSize),
                  ),
                ),
              ),
              SizedBox(
                width: widget.size!.width * .005,
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    right: widget.size!.width * .03,
                    left: widget.size!.width * .001),
                child: Icon(
                  Ionicons.glasses_outline,
                  size: widget.size!.width *
                      .08 *
                      Provider.of<Setting>(context).fontSize,
                ),
              ),
            ],
          ),
          SizedBox(
            height: widget.size!.height * .005,
          ),
          widget.assets!.isNotEmpty
              ? widget.assets!.length > 1
                  ? CarouselSlider(
                      items: widget.assets!
                          .map(
                            (e) => Container(
                              width: widget.size!.width * .85,
                              child: CachedNetworkImage(
                                imageUrl:
                                    'http://192.168.43.250:8000/uploads/photos/$e',
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: Container(
                                    height: widget.size!.height * .34,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        disableCenter: false,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 2000),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                      ))
                  : CachedNetworkImage(
                      imageUrl:
                          'http://192.168.43.250:8000/uploads/photos/${widget.assets![0]}',
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        child: Container(
                          height: widget.size!.height * .34,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
              : Container(),
          SizedBox(
            height: widget.size!.height * .005,
          ),
        ],
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
}
