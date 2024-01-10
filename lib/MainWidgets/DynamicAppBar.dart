
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:flutter/material.dart';

class DynamicAppBar extends StatelessWidget {
  const DynamicAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
             shadowColor: Colors.black,
surfaceTintColor: Colors.white,             centerTitle: true,
             elevation: 0,
             title: Text(
               'الجريدة',
               style: TextStyle(
                 fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 32),
               ),
             ),
             pinned: false,
             floating: true,
             automaticallyImplyLeading: true,
             flexibleSpace: FlexibleSpaceBar(
               centerTitle: true,
          
           ),);
  }
}