import 'package:aljaredanews/screens/searchResults/searchResultController.dart';
import 'package:loading_animations/loading_animations.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../ArticleHtml/htmltext.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchResultController controller;

  @override
  void initState() {
    controller = SearchResultController();
    controller.appBarTitle = SearchTextField(
      onSub: (String text) async {
                           setState(() {
         controller. loading = true;
        });

                        await controller. search(text, context);
                         setState(() {

                         });
      },
    );

    setState(() {});

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildBar(context),
      body: (controller.loading != true)
          ? SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * .773,
                  child: (controller.searchedArticles != null &&
                          controller.searchedArticles!.length > 0)
                      ? ListView.builder(
                          itemCount: (controller.searchedArticles == null)
                              ? 0
                              : controller.searchedArticles!.length,
                          itemBuilder: (BuildContext context, int position) {
                            if (controller.searchedArticles![position]
                                    .articletype[0] ==
                                'breaking') {
                              return Container();
                            }
                            return InkWell(
                              onTap: () {
                                // MaterialPageRoute route = MaterialPageRoute(
                                //     builder: (_) => CourseDetailScreen());
                                // Navigator.push(context, route);

                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: HtmlText(
                                      controller.searchedArticles![position]),
                                  withNavBar:
                                      false, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.scale,
                                );
                              },
                              child: ListTile(
                                trailing: Text(controller
                                    .searchedArticles![position].createdAt
                                    .toString()
                                    .substring(0, 10)),
                                title: Text(controller
                                    .searchedArticles![position].title),
                                subtitle: Text(
                                    '${controller.searchedArticles![position].user.firstName} ${controller.searchedArticles![position].user.lastName}'),
                              ),
                            );
                          })
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: size.height * .3,
                                top: size.height * .3),
                            child: Container(
                              child: Text('${controller.newVariable}'),
                            ),
                          ),
                        )))
          : Center(
              child: LoadingJumpingLine.circle(),
            ),
      // resizeToAvoidBottomPadding: false,
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
            icon: controller.searchIcon,
            onPressed: () {
              setState(() {
                if (controller.searchIcon.icon == Icons.search) {
                  controller.searchIcon = Icon(Icons.cancel);
                  controller.appBarTitle = controller.appBarTitle = SearchTextField(
      onSub: (String text) async {
                           setState(() {
         controller. loading = true;
        });

                        await controller. search(text, context);
                         setState(() {

                         });
      },
    );
                } else {
                  setState(() {
                    controller.searchIcon = Icon(Icons.search);
                    controller.appBarTitle = const Text(
                      'البحث',
                      textDirection: TextDirection.rtl,
                    );
                  });
                }
              });
            }),
      ],
      title: controller.appBarTitle,
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key, required this.onSub,
  }) : super(key: key);
  final Future<void> Function(String) onSub;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          
          contentPadding:
              const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: 'البحث',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(.6),
            fontSize: 16,
          )),
      autofocus: true,
      onSubmitted: onSub,
      onChanged: onSub,
      textInputAction: TextInputAction.search,
      textDirection: TextDirection.rtl,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18.0,
      ),
    );
  }
}
