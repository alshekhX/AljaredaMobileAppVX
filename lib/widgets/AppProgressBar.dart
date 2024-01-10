import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sizer/sizer.dart';

class AppClassBar {
  final BuildContext? context;
  CustomProgressDialog? pr;

  AppClassBar({this.context}) {

pr= CustomProgressDialog(context!,
        blur: 10,
        loadingWidget: Container(
            height: 50.sp,
            width: 50.sp,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: LoadingFlipping.circle()));

  }
}
