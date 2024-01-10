import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    Key? key, required this.padding, required this.height,
  }) : super(key: key);
  final double padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: padding),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: true,
        child: Container(
          height: height,
          color: Colors.white,
        ),
      ),
    );
  }
}
