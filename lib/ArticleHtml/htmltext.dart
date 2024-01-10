import 'dart:async';
import 'package:aljaredanews/screens/journlistScreen/journalist.dart';
import 'package:aljaredanews/provider/articleProvider.dart';
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:aljaredanews/utils/const.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:sizer/sizer.dart';
import '../models/Article.dart';






// ignore: must_be_immutable
class HtmlText extends StatefulWidget {
  ArticleModel? articleModel;

  HtmlText(this.articleModel);

  @override
  _HtmlTextState createState() => _HtmlTextState();
}

class _HtmlTextState extends State<HtmlText> {
  Timer? _timer;
  //you can choose between the two
  dom.Document document = dom.Document();
  String? thehtml;

  _AnimatedFlutterLogoState() {
    _timer = new Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        getArticle();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _timer!.cancel();
  }

  @override
  void initState() {
    print(widget.articleModel!.assets);
    //  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    _AnimatedFlutterLogoState();
    // TODO: implement initState
    super.initState();

    // TODO: implement initState
    // WidgetsBinding.instance?.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
    
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            forceElevated: true,
            shadowColor: Colors.black,
            elevation: 2,
            centerTitle: true,
            title: Text(
              'الجريدة',
              style: TextStyle(
                fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 40),
              ),
            ),
            pinned: false,
            snap: false,
            automaticallyImplyLeading: true,
            floating: false,
            expandedHeight: height * .42,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Column(
                children: [
                  SizedBox(
                    height: height * .1,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              journlist(widget.articleModel!.user!)));
                    },
                    child: Container(
                        height: height * .2,
                        width: height * .2,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              Provider.of<Setting>(context, listen: false)
                                      .nightmode!
                                  ? Colors.white
                                  : Colors.black,
                          child: Container(
                            height: height * .195,
                            width: height * .195,
                            child: CircleAvatar(
                                radius: 60,
                                backgroundImage: widget
                                            .articleModel!.user!.photo! !=
                                        'no_image.jpg'
                                    ? NetworkImage(AljaredaConst.BasePicUrl +
                                            widget.articleModel!.user!.photo!)
                                        as ImageProvider
                                    : AssetImage('assets/profilePlace.png')
                                        as ImageProvider),
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * .01),
                    child: Center(
                      child: Container(
                          width: width * .5,
                          child: Text(
                            '${widget.articleModel!.user!.firstName} ${widget.articleModel!.user!.lastName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: AdaptiveTextSize()
                                  .getadaptiveTextSizeSetting(context, 18,
                                      Provider.of<Setting>(context).fontSize),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .005,
                  ),
                  Center(
                    child: Container(
                        width: width * .5,
                        child: Text(
                          '${widget.articleModel!.user!.email}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AdaptiveTextSize()
                                .getadaptiveTextSizeSetting(context, 18,
                                    Provider.of<Setting>(context).fontSize),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: size.height * .005,
                  ),
                  Text(
                      intl.DateFormat.yMMMEd('ar_SA').format(
                        widget.articleModel!.createdAt!,
                      ),
                      style: TextStyle(
                          fontSize: AdaptiveTextSize()
                              .getadaptiveTextSize(context, 14))),
                  // Text(
                  //   '${widget.articleModel.createdAt.toString().substring(0, 11)}',
                  //   style: TextStyle(
                  //     fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                  //         context, 16, Provider.of<Setting>(context).fontSize),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            child: SliverToBoxAdapter(
                child: thehtml != null
                    ? Container(
                        child: SingleChildScrollView(
                          child: Consumer<ArticlePrvider>(
                              builder: (context, articleProv, _) {
                            // thehtml=articleProv.article.description;
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                  size.width * .05,
                                  size.aspectRatio * 5,
                                  size.width * .05,
                                  size.aspectRatio * 5),
                              child: FadeIn(
                                                              // Optional paramaters
                                                              duration: Duration(milliseconds: 250),
                                                              curve: Curves.easeIn,
                              
                                                              child: Html(
                                                                
                              style: {
                                
                                "img":Style(
                                    direction: TextDirection.rtl,
                                        
                                 
                                    // lineHeight: LineHeight.em(1.5),
                              
                                  ),
                               
                                "*": Style(
                                    textAlign: TextAlign.justify,
                                    direction: TextDirection.rtl,
                                    color: Provider.of<Setting>(context,

                                                listen: false)
                                            .nightmode!
                                        ? Colors.white.withOpacity(.87)
                                        : Color(0xff212427),
                                        
                                    wordSpacing: 1.5,
                                    
                                   //You can set your custom height here
                              
                                    // lineHeight: LineHeight.em(1.5),
                              
                                    fontFamily: 'Almari')
                              },
                              data: thehtml,
                                                              ),
                                                            ),
                            );
                          }),
                        ),
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Container(
                          child: LoadingFilling.square(
                            fillingColor:
                                Provider.of<Setting>(context, listen: false)
                                        .nightmode!
                                    ? Colors.white
                                    : Colors.black.withOpacity(.8),
                            borderColor:
                                Provider.of<Setting>(context, listen: false)
                                        .nightmode!
                                    ? Colors.white
                                    : Colors.black.withOpacity(1),
                          ),
                        ),
                      ))),
          ),
        ]),
      ),
    );
  }

  

  getArticle() async {
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getHtml(widget.articleModel!);
    if (res == 'success') {
      thehtml =
          Provider.of<ArticlePrvider>(context, listen: false).articleHtmlText;
      document = htmlparser.parse(thehtml);
      setState(() {});
      print(document);
    }
  }
}
