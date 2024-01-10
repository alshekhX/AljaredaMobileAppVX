
import 'package:aljaredanews/provider/settingProvider.dart';
import 'package:aljaredanews/screens/today/todayC.dart';
import 'package:aljaredanews/utils/adabtiveText.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HeadBox extends StatelessWidget {
  const HeadBox({
    Key? key,
    required this.size,
    required this.controller,
    required this.dayformated,
  }) : super(key: key);

  final Size size;
  final TodayController controller;
  final String dayformated;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        Container(
            height: size.height * 0.2,
            margin: EdgeInsets.only(
                left: 5, right: 5),
            decoration: BoxDecoration(
                color: Provider.of<Setting>(context, listen: false)
                        .nightmode!
                    ? Colors.blueGrey
                        .shade900
                    : Colors
                        .grey.shade200
                        .withOpacity(
                            .8),
                border: Border.all(
                    color: Provider.of<Setting>(
                                context,
                                listen: false)
                            .nightmode!
                        ? Colors.grey.shade500
                        : Colors.grey.shade900,
                    width: 1)),
            width: 73.w,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'عناوين اليوم',
                  textStyle:
                      GoogleFonts.arefRuqaa(
                    fontWeight:
                        FontWeight
                            .w500,
                    fontSize: AdaptiveTextSize()
                        .getadaptiveTextSizeSetting(
                            context,
                            50,
                            Provider.of<Setting>(
                                    context)
                                .fontSize),
                  ),
                  textAlign: TextAlign
                      .center,
                  speed:
                      const Duration(
                          milliseconds:
                              200),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(
                  milliseconds: 150),
              displayFullTextOnTap:
                  true,
              stopPauseOnTap: true,
            )
            //  Text(
            //   'عناوين اليوم',
            //   style: TextStyle(
            //     fontSize: AdaptiveTextSize()
            //         .getadaptiveTextSizeSetting(
            //             context,
            //             40,
            //             Provider.of<Setting>(
            //                     context)
            //                 .fontSize),
            //   ),
            //   textAlign:
            //       TextAlign.center,
            // ),
            ),
        Positioned(
            child: Column(
              children: [
                controller.weather == null
                    ? Text('',
                        style:
                            TextStyle(
                          fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                              context,
                              18,
                              Provider.of<Setting>(context)
                                  .fontSize),
                        ))
                    : AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            '${  controller.weather!.temperature!.celsius!.floor()} درجة مئوية',
                            textStyle:
                                GoogleFonts.arefRuqaa(
                              color:
                                    controller.wetherTextColor,
                              fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                  context,
                                  18,
                                  Provider.of<Setting>(context).fontSize),
                            ),
                            textAlign:
                                TextAlign
                                    .center,
                            speed: const Duration(
                                milliseconds:
                                    200),
                          ),
                        ],
                        totalRepeatCount:
                            1,
                        pause: const Duration(
                            milliseconds:
                                150),
                        displayFullTextOnTap:
                            true,
                        stopPauseOnTap:
                            true,
                      ),

                // Text(
                //     '${weather.temperature.celsius.floor()} درجة مئوية',
                //     style:
                //         TextStyle(
                //       fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                //           context,
                //           18,
                //           Provider.of<Setting>(context)
                //               .fontSize),
                //     ),
                //     textDirection:
                //         TextDirection
                //             .rtl,
                //   )
              ],
            ),
            left: size.width * .04,
            bottom:
                size.height * .035),
        Positioned(
            child: Column(
              children: [
                 controller.weather  == null
                    ? Text('',
                        style:
                            TextStyle(
                          fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                              context,
                              18,
                              Provider.of<Setting>(context)
                                  .fontSize),
                        ))
                    : AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            '${  controller.weather!.weatherDescription}',
                            textStyle:
                                GoogleFonts.arefRuqaa(
                              fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                                  context,
                                  18,
                                  Provider.of<Setting>(context).fontSize),
                            ),
                            textAlign:
                                TextAlign
                                    .center,
                            speed: const Duration(
                                milliseconds:
                                    200),
                          ),
                        ],
                        totalRepeatCount:
                            1,
                        pause: const Duration(
                            milliseconds:
                                150),
                        displayFullTextOnTap:
                            true,
                        stopPauseOnTap:
                            true,
                      ),
                //  Text(
                //     '${weather.weatherDescription}',
                //     style:
                //         TextStyle(
                //       fontSize: AdaptiveTextSize().getadaptiveTextSizeSetting(
                //           context,
                //           18,
                //           Provider.of<Setting>(context)
                //               .fontSize),
                //     ),
                //     textDirection:
                //         TextDirection
                //             .rtl,
                //   )
              ],
            ),
            left: size.width * .04,
            bottom:
                size.height * .01),
        Positioned(
          child: Container(
              child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                '${dayformated}',
                textStyle: GoogleFonts.arefRuqaa (
                  fontSize: AdaptiveTextSize()
                      .getadaptiveTextSizeSetting(
                          context,
                          24,
                          Provider.of<Setting>(
                                  context)
                              .fontSize),
                ),
                textAlign:
                    TextAlign.center,
                speed: const Duration(
                    milliseconds:
                        200),
              ),
            ],
            totalRepeatCount: 1,
            pause: const Duration(
                milliseconds: 150),
            displayFullTextOnTap:
                true,
            stopPauseOnTap: true,
          )),

          right: size.width * .04,
          bottom: size.height * .035,
        ),
        Positioned(
            right: size.width * .36,
            bottom: size.height * .09,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  '<<<',
                  textStyle:
                      TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize: AdaptiveTextSize()
                        .getadaptiveTextSizeSetting(
                            context,
                            26,
                            Provider.of<Setting>(
                                    context)
                                .fontSize),
                  ),
                  textAlign:
                      TextAlign.end,
                  speed:
                      const Duration(
                          milliseconds:
                              600),
                ),
              ],
              repeatForever: true,
              pause: const Duration(
                  milliseconds: 400),
              displayFullTextOnTap:
                  true,
              stopPauseOnTap: true,
            ))
      ],
    ));
  }
}
