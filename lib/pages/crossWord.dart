import 'dart:math';


import 'package:aljaredanews/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

import '../provider/articleProvider.dart';
import '../utils/adabtiveText.dart';

//TODO
//divide the games into raws depending on word length
class CrossWords extends StatefulWidget {
  const CrossWords({Key? key}) : super(key: key);

  @override
  _CrossWordsState createState() => _CrossWordsState();
}

class _CrossWordsState extends State<CrossWords> {
  ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  List? crossWordGame;

  List<String> rowsQuestions = [
    'المكتب 1',
    'ميدان الرباط',
    'قسمتنا كدة',
    'المقابر في بعض الاحيان',
    'سجارتك قصبة'
  ];

  List<String> columnsQuestions = [
    'something kda',
    'something kda',
    'letters',
    'a word that have no meaning',
  ];
  List<Widget>? ccolumn;
  List<Widget>? rrow;

  List<String> wordListRows=['hjh','jkjk'];
  List<String> ?wordListCol;
  String? leetter;
  FocusNode? node;

  bool? ignorePointer;

  int? rowColorindex;
  // TextEditingController conto;
  String? gameQuRestion;

  List<TextEditingController>? rowController;

  Color? rowColor;

  String? fuck;

  Color? rightHight;

  List? readywords;
  bool showGame = false;

  int ?index;
  FocusNode? focusNode;

  List<TextEditingController>? controllers;
  Color ?color;

  @override
  void initState() {
    getAllGames();
    focusNode = FocusNode();

    readywords = [];
    controllers = [];

    rowController = [];
    // gameQuR(rowsQuestions);

    // gameControllers = [];
    rowColor = Colors.white;
    gameQuRestion = 'إضغط في احد الارقام';

    // TODO: implement initState
    super.initState();
  }

  getAllGames() async {
     String token =  Provider.of<AuthProvider>(
                                    context,
                                    listen: false)
                                .token!;
    String res =
        await Provider.of<ArticlePrvider>(context, listen: false).getAllGames(token);
    print(res);

    crossWordGame = Provider.of<ArticlePrvider>(context, listen: false).games;

    if (crossWordGame != null && res == 'success') {
      print(crossWordGame![crossWordGame!.length-1].rowsWords);
      wordListRows = crossWordGame![crossWordGame!.length-1].rowsWords;
      rowsQuestions = crossWordGame![crossWordGame!.length-1].rowsQuestions;
      columnsQuestions = crossWordGame![crossWordGame!.length-1].columnsQuestions;
      controllerGenerator();

      showGame = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    gameQuC(columnsQuestions, size);
    gameQuR(rowsQuestions, size);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: size.height * .06,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: size.width * .05, right: size.width * .05),
              alignment: Alignment.center,
              child: Text(
                gameQuRestion == null ? '' : gameQuRestion!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize:
                        AdaptiveTextSize().getadaptiveTextSize(context, 30)),
              ),
            ),
              SizedBox(
              height: size.height * .06,
            ),
            Center(
              child: Container(
                width: size.width * .9,
                height: size.height * .8,
                alignment: Alignment.center,
                child: showGame == true
                    ? Directionality(
                        textDirection: TextDirection.rtl,
                        child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: size.height * .05,
                                    left: size.height * .05,
                                    right: size.height * .05),
                                child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: biggestWordLetters(
                                                wordListRows)),
                                    itemCount:
                                        numberofLetters(wordListRows).length,
                                    itemBuilder:
                                        (BuildContext context, int pos) {
                                      fuck = numberofLetters(wordListRows);
                                      Color color= Colors.white;
                                      bool readable = false;

                                      if (fuck![pos] == '@') {
                                        color = Colors.black;
                                        readable = true;
                                      }

                                      if (controllers![pos].text.toLowerCase() ==
                                          fuck![pos].toLowerCase()) {
                                        color = Colors.green.withOpacity(.5);
                                      }

                                      return gameCell(color, controllers![pos],
                                          readable, size);
                                    }),
                              ),
                              Positioned(
                                child: Column(
                                  children: ccolumn!,
                                ),
                                right: size.width * .00,
                                top: size.height * .05,
                              ),
                              Positioned(
                                child: Row(
                                  children: rrow!,
                                ),
                                right: size.height * .06,
                                top: size.height * .00,
                              )
                            ],
                            fit: StackFit.expand),
                      )
                    : LoadingBouncingLine.square(),
              ),
            ),
          ],
        ),
      ),
    );
  }

//individual game cell
  Widget gameCell(Color coolor, TextEditingController controller, bool readable,
      Size size) {
    Color color = coolor;
    print(color);
    return Container(
      decoration: BoxDecoration(
          color: color, border: Border.all(color: Colors.black, width: 1)),
      width: size.width * .05,
      height: size.width * .05,
      child: Center(
        child: TextField(
          
          decoration: null,
          textAlign: TextAlign.center,
          readOnly: readable == false ? false : true,
          maxLength: 1,
          maxLengthEnforced: false,
          onChanged: (value) {
            setState(() {
              if (controller.text.length > 1) {
                controller.text = controller.text.substring(0, 0);
              }
            });
          },
          controller: controller,
          keyboardType: TextInputType.name,
          inputFormatters: [],
          textInputAction: TextInputAction.none,
          style: TextStyle(
            color: Colors.black,
              fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 26)),
        ),
      ),
    );
  }

//row questions
  gameQuR(List<String> rowsQ, Size size) {
    List<Widget> column = [];

    for (int i = 1; i <= rowsQ.length; i++) {
      column.add(
        InkWell(
            onTap: () {
              index = i;
              index2 = null;

              setState(() {
                print('index is $index');

                print(rowsQ[i - 1]);
                gameQuRestion = rowsQ[i - 1];
                print(color);
              });
            },
            
            child: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child:  Container(
                          height: ((size.width * .50)/ wordListRows.length+1),

              child: Container(
                alignment: Alignment.topRight,
                  child: ClipPath(
                    clipper: ArrowClipper(10, 25, Edge.LEFT),
                    child: Container(
                        decoration: BoxDecoration(
                            color: i == index
                                ? Colors.blue.withOpacity(.6)
                                : Colors.grey.withOpacity(.2)),
                        width: size.width * .1,
                        child: Padding(
                          padding: EdgeInsets.only(right: size.width * .01),
                          child: Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Text(
                              '$i',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            )),
      );
     
    }
    ccolumn = column;
  }

  int? index2;

//column questions
  gameQuC(List<String> rowsQC, Size size) {
    List<Widget> row = [];

    for (int i = 1; i <= rowsQC.length; i++) {
      row.add(
        InkWell(
            onTap: () {
              index2 = i;
              index = null;

              setState(() {
                print('index is $index');

                print(rowsQC[i - 1]);
                gameQuRestion = rowsQC[i - 1];
                print(color);
              });
            },
            child: Container(
                    // width:  i!=1?size.width * .18:size.height * .025,

                          width: (size.width * .8)/ (biggestWordLetters(wordListRows)+1),

              child: Container(
                alignment: Alignment.topRight,
                                          width: size.width * .1,
                child: ClipPath(
                  
                  clipper: ArrowClipper(10, 25, Edge.BOTTOM),
                  child: Container(
                      decoration: BoxDecoration(
                          color: i == index2
                              ? Colors.blue.withOpacity(.6)
                              : Colors.grey.withOpacity(.2)),
                      height: size.width * .1,
                      width: size.height * .025,
                      child: Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(left: 3),
                        child: Text(
                          '$i',
                          style: TextStyle(fontSize: 14),
                        ),
                      )),
                ),
              ),
            )),
      );

      if (i <= rowsQC.length) {
        // row.add(
        //   SizedBox(
        //     width: size.width * .5/ biggestWordLetters(wordListRows)-1
        //   ),
        // );
        print(biggestWordLetters(wordListRows));
      }
    }
    rrow = row;
  }

//ganarete controller according to words letters number
  controllerGenerator() {
    for (int i = 0; i < numberofLetters(wordListRows).length; i++) {
      TextEditingController controller = new TextEditingController();
      controllers!.add(controller);
    }
    print(controllers!.length);
  }

//returning the biggest number in the list
  int biggestWordLetters(List<String> words) {
    List<int> wordsNumber = [];
    for (int i = 0; i < words.length; i++) {
      wordsNumber.add(words[i].length);
    }
    return wordsNumber.reduce(max);
  }

  String numberofLetters(List<String> words) {
    for (int i = 0; i < words.length; i++) {
      String word = words[i];

      int length = word.length;

      if (length < biggestWordLetters(words)) {
        while (length < biggestWordLetters(words)) {
          word = word + '@';
          length++;
        }
      }
      if (readywords!.length < words.length) readywords!.add(word);
    }

    String letterList = '';
    for (int i = 0; i < readywords!.length; i++) {
      letterList = letterList + readywords![i];
    }
    return letterList;
  }
}
