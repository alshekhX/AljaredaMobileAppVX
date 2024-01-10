
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../utils/adabtiveText.dart';

class Article extends StatefulWidget {
  const Article({Key? key}) : super(key: key);

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController!.dispose();
    _scrollViewController!.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AnimatedContainer(
              height: _showAppbar ? 56.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: AppBar(
            automaticallyImplyLeading: false,
        title: Center(child: Text('الجريدة',style: TextStyle( fontSize:  AdaptiveTextSize().getadaptiveTextSize(context, 40),
       ),),),
      ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollViewController,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          bottom: size.height * .001,
                          top: size.height * .07,
                          left: size.width * .01,
                          right: size.width * .04),
                      alignment: Alignment.topRight,
                   
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: size.height * .02,
                          right: size.width * .03,
                          left: size.width * .05),
                      alignment: Alignment.topRight,
                      child: Text(
                        'الأقصى والتراشق العربي',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSize(context, 38),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => journlist()));
                      },
                      child: Row(
                        children: [
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'فيصل صالح',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 22),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * .01,
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(right: size.width * .03),
                            width: size.width * .07,
                            height: size.height * .07,
                            child: Image.asset('assets/pen.png'),
                          ),
                        ],
                      ),
                    ),

                    //   Container(
                    //              margin: EdgeInsets.only(bottom:size.height*.05,right:size.width*.03,left:size.width*.01),

                    //   alignment: Alignment.topRight,
                    //   child: Text(
                    //     'بقلم يوسف احمد الزين',
                    //     textDirection: TextDirection.rtl,
                    //     style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
                    //     fontFamily:'${amiri}'),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(bottom: size.height * .07),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.blue,
                          BlendMode.dstIn,
                        ),
                        child: Image.network(
                            "https://cnn-arabic-images.cnn.io/cloudinary/image/upload/w_1920,c_scale,q_auto/cnnarabic/2020/08/19/images/162849.jpg"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: size.width * .02,
                        left: size.width * .02,
                      ),
                      alignment: Alignment.topRight,
                      child: Text(
                        "في الوقت الذي اشتدت فيه الهجمات الصهيونية على المسجد الأقصى المبارك ممثلة في اعتداءات المستوطنين المتكررة على الفلسطينيين، ومضايقات قوات الاحتلال الإسرائيلي المتواصلة لهم، ومحاولات إسرائيل المستمرة لتهويد القدس الشريف، من المفترض أن يقف الفلسطينيون والعرب جميعًا يدًا واحدة وصفًّا واحدًا في وجه مخطط الاحتلال ونواياه الشريرة التي تسعى إلى التهام كامل أرض فلسطين التاريخية، وفرض الأمر الواقع للقضاء على أية إمكانية لقيام الدولة الفلسطينية المستقلة وعاصمتها القدس الشريف  في هذا الوقت الذي تتصاعد فيه العنجهية الإسرائيلية والغطرسة الصهيونية إذا بنا نرى بعض العرب ينقسمون شِيَعًا وأحزابًا في قضية محورية ومفصلية، من المفترض أنها محل للإجماع العربي. فحين كشف الاحتلال الإسرائيلي في شهر رمضان الماضي القناع عن وجهه القبيح، واقتحم المسجد الأقصى المبارك، واعتدى بالضرب على المصلين الأبرياء العزل، وأهان المصلين الركع السجود، واعتدى على الشيوخ والنساء والأطفال، حين حدثت كل هذه الاعتداءات كان ينبغي أن ينسى العرب خلافاتهم، وأن يقفوا مع أبناء الشعب الفلسطيني المستضعفين في القدس المحتلة وحي الشيخ جراح، لكننا رأينا انقسامات عربية في قضية ليست موضع خلاف، ولا ينبغي أن تكون مثارًا للخلافات والنزاعات والتراشق الإعلامي عبر منصات التواصل الاجتماعي المختلفة، فضلاً عن الفضائيات ومختلف وسائل الإعلام، وكان على الجميع أن يرتفعوا إلى مستوى المسؤولية؛ فمهما كانت الخلافات حول القضايا المختلفة إلا أن قضية المسجد الأقصى والقدس الشريف قضية جامعة، ينبغي أن يتجمع العرب والمسلمون خلفها؛ لأن هذا المسجد المبارك هو أولى القبلتين وثالث الحرمين الشريفين، ومسرى رسولنا الكريم ",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSize(context, 22),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: size.height * .2,
                    ),
                    Center(
                      child: Container(
                        width: size.width * .8,
                        alignment: Alignment.bottomRight,
                        child: Text('التعليقات',
                            style: TextStyle(
                                fontSize: AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 36))),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .04,
                    ),
                    comment('محمد علي', '', 'بختلف معاك في حاجات كتيرة لكن كلامك صاح', size),
                    comment(
                        'osman don',
                        'غلط ي دييين',
                        'انحنا مالانا ومال فلسطين انتا معرص ولا شنو ركز في بلدك ي سم',
                        size),
                    comment(
                        'مصطفى الجعلي',
                        'لا للتطبيع ولو متنا جوعا',
                        ' اي عميل رخيص ياخد في راسو طوالي فلسطين حرة والم عاجبو كسمو',
                        size),
                    comment('محمد علي', 'جهل شديد',
                        'التعليقات بتوريك كمية الجهل الموجود عندا', size),
                    comment('PETER TOCH', 'NOOO',
                        'STOP FIGHTING EVERY BODY WE ARE ALL BROTHER', size),
                        SizedBox(height: 50,)
                    //add your screen content here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //   return Scaffold(

  //     body:

  //     Container(
  //       margin: EdgeInsets.only(
  //           right: size.height * .001, left: size.height * .001),
  //       child: ListView(
  //         children: [
  //           Container(
  //             margin: EdgeInsets.only(
  //                 bottom: size.height * .001,
  //                 top: size.height * .07,
  //                 left: size.width * .01,
  //                 right: size.width * .04),
  //             alignment: Alignment.topRight,
  //             child: Text(
  //               'الاقصى',
  //               textDirection: TextDirection.rtl,
  //               style: TextStyle(
  //                 fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 44),
  //                 fontWeight: FontWeight.w800,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             margin: EdgeInsets.only(
  //                 bottom: size.height * .02,
  //                 right: size.width * .03,
  //                 left: size.width * .01),
  //             alignment: Alignment.topRight,
  //             child: Text(
  //               'الأقصى والتراشق العربي',
  //               textDirection: TextDirection.rtl,
  //               style: TextStyle(
  //                 fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 38),
  //                 fontWeight: FontWeight.w800,
  //               ),
  //             ),
  //           ),

  //           InkWell(
  //             onTap: () {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => journlist()));
  //             },
  //             child: Row(
  //               children: [
  //                 Spacer(),
  //                 Container(
  //                   margin: EdgeInsets.only(bottom: 15),
  //                   alignment: Alignment.bottomRight,
  //                   child: Text(
  //                     'فيصل صالح',
  //                     textDirection: TextDirection.rtl,
  //                     style: TextStyle(
  //                       fontSize:
  //                           AdaptiveTextSize().getadaptiveTextSize(context, 22),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: size.width * .01,
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.only(right: size.width * .03),
  //                   width: size.width * .07,
  //                   height: size.height * .07,
  //                   child: Image.asset('assets/pen.png'),
  //                 ),
  //               ],
  //             ),
  //           ),

  //           //   Container(
  //           //              margin: EdgeInsets.only(bottom:size.height*.05,right:size.width*.03,left:size.width*.01),

  //           //   alignment: Alignment.topRight,
  //           //   child: Text(
  //           //     'بقلم يوسف احمد الزين',
  //           //     textDirection: TextDirection.rtl,
  //           //     style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
  //           //     fontFamily:'${amiri}'),
  //           //   ),
  //           // ),
  //           Container(
  //             margin: EdgeInsets.only(bottom: size.height * .07),
  //             child: ColorFiltered(
  //               colorFilter: ColorFilter.mode(
  //                 Colors.blue,
  //                 BlendMode.dstIn,
  //               ),
  //               child: Image.network(
  //                   "https://cnn-arabic-images.cnn.io/cloudinary/image/upload/w_1920,c_scale,q_auto/cnnarabic/2020/08/19/images/162849.jpg"),
  //             ),
  //           ),
  //           Container(
  //             margin: EdgeInsets.only(
  //               right: size.width * .05,
  //               left: size.width * .05,
  //             ),
  //             alignment: Alignment.topRight,
  //             child: Text(
  //               "في الوقت الذي اشتدت فيه الهجمات الصهيونية على المسجد الأقصى المبارك ممثلة في اعتداءات المستوطنين المتكررة على الفلسطينيين، ومضايقات قوات الاحتلال الإسرائيلي المتواصلة لهم، ومحاولات إسرائيل المستمرة لتهويد القدس الشريف، من المفترض أن يقف الفلسطينيون والعرب جميعًا يدًا واحدة وصفًّا واحدًا في وجه مخطط الاحتلال ونواياه الشريرة التي تسعى إلى التهام كامل أرض فلسطين التاريخية، وفرض الأمر الواقع للقضاء على أية إمكانية لقيام الدولة الفلسطينية المستقلة وعاصمتها القدس الشريف  في هذا الوقت الذي تتصاعد فيه العنجهية الإسرائيلية والغطرسة الصهيونية إذا بنا نرى بعض العرب ينقسمون شِيَعًا وأحزابًا في قضية محورية ومفصلية، من المفترض أنها محل للإجماع العربي. فحين كشف الاحتلال الإسرائيلي في شهر رمضان الماضي القناع عن وجهه القبيح، واقتحم المسجد الأقصى المبارك، واعتدى بالضرب على المصلين الأبرياء العزل، وأهان المصلين الركع السجود، واعتدى على الشيوخ والنساء والأطفال، حين حدثت كل هذه الاعتداءات كان ينبغي أن ينسى العرب خلافاتهم، وأن يقفوا مع أبناء الشعب الفلسطيني المستضعفين في القدس المحتلة وحي الشيخ جراح، لكننا رأينا انقسامات عربية في قضية ليست موضع خلاف، ولا ينبغي أن تكون مثارًا للخلافات والنزاعات والتراشق الإعلامي عبر منصات التواصل الاجتماعي المختلفة، فضلاً عن الفضائيات ومختلف وسائل الإعلام، وكان على الجميع أن يرتفعوا إلى مستوى المسؤولية؛ فمهما كانت الخلافات حول القضايا المختلفة إلا أن قضية المسجد الأقصى والقدس الشريف قضية جامعة، ينبغي أن يتجمع العرب والمسلمون خلفها؛ لأن هذا المسجد المبارك هو أولى القبلتين وثالث الحرمين الشريفين، ومسرى رسولنا الكريم ",
  //               textDirection: TextDirection.rtl,
  //               style: TextStyle(
  //                 fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 22),
  //                 fontWeight: FontWeight.w800,
  //               ),
  //             ),
  //           ),

  //           SizedBox(
  //             height: size.height * .2,
  //           ),
  //           Center(
  //             child: Container(
  //               width: size.width * .8,
  //               alignment: Alignment.bottomRight,
  //               child: Text('التعليقات',
  //                   style: TextStyle(
  //                       fontSize: AdaptiveTextSize()
  //                           .getadaptiveTextSize(context, 36))),
  //             ),
  //           ),
  //           SizedBox(
  //             height: size.height * .04,
  //           ),
  //           comment('محمد علي', '', 'بختلف معاك في حاجات كتيرة لكن كلامك صاح', size)
  //           ,comment('osman don', 'غلط ي دييين', 'انحنا مالانا ومال فلسطين انتا معرص ولا شنو ركز في بلدك ي سم', size)
  //                       ,comment('مصطفى الجعلي', 'لا للتطبيع ولو متنا جوعا', ' اي عميل رخيص ياخد في راسو طوالي فلسطين حرة والم عاجبو كسمو', size)
  //          , comment('محمد علي', 'جهل شديد', 'التعليقات بتوريك كمية الجهل الموجود عندا', size)
  //                     , comment('PETER TOCH', 'NOOO', 'STOP FIGHTING EVERY BODY WE ARE ALL BROTHER', size)

  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget comment(String name, String headline, String comment, Size size) {
    return Container(
      child: Column(
        children: [
          Container(
              margin:
                  EdgeInsets.only(right: size.width * .05, bottom: 10, top: 10),
              alignment: Alignment.bottomRight,
              child: Text(name,
                  style: TextStyle(
                      fontSize: AdaptiveTextSize()
                          .getadaptiveTextSize(context, 26)))),
          headline.isEmpty == false
              ? Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(
                      right: size.width * .08,
                      bottom: size.height * .01,
                      left: size.width * .06),
                  child: Text(headline,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSize(context, 22))),
                )
              : SizedBox(
                  height: 1,
                ),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(
                right: size.width * .06, left: size.width * .02),
            child: Text(
              comment,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      AdaptiveTextSize().getadaptiveTextSize(context, 18)),
            ),
          ),
          Container(
              width: size.width * .9,
              child: Divider(
                color: Colors.black,
              ))
        ],
      ),
    );
  }
}
