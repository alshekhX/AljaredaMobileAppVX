import 'dart:ui';

import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../htmltest.dart';
import '../provider/articleProvider.dart';
import '../provider/auth.dart';
import '../provider/settingProvider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // final TextEditingController _filter = new TextEditingController();
  bool ?loading;
  // String _searchText = "";
  // List names = new List();
  // List filteredNames = new List();
  List? searchedArticles;
  Icon _searchIcon = new Icon(Icons.cancel);
  var newVariable = '';

  Future search(String text, context) async {
    setState(() {
      loading = true;
    });

    try {
       String token =
        await Provider.of<AuthProvider>(context, listen: false).token!;
      await Provider.of<ArticlePrvider>(context, listen: false)
          .getSearchedArticles(text,token);
      searchedArticles =
          Provider.of<ArticlePrvider>(context, listen: false).searchedArticles;
      print(searchedArticles);
      if (searchedArticles!.isEmpty) {
        newVariable = 'لا توجد نتيجة ';
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      newVariable = 'تاكد من تشغيل بياناتالهاتف';
      setState(() {
        loading = false;
      });
    }
  }

  Widget? _appBarTitle;
  // _examplePageState() {
  //   _filter.addListener(() {
  //     if (_filter.text.isEmpty) {
  //       setState(() {
  //         _searchText = "";
  //         filteredNames = names;
  //       });
  //     } else {
  //       setState(() {
  //         _searchText = _filter.text;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    _appBarTitle = TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: 'البحث',
          hintStyle: TextStyle(
            color: Provider.of<Setting>(context, listen: false).nightmode!
                ? Colors.white.withOpacity(.4)
                : Colors.black.withOpacity(.6),
            fontSize: 16,
          )),
      autofocus: true,
      onChanged: (value) async {
        await search(value, context);
      },
      onSubmitted: (String text) async {
        await search(text, context);
      },
      textInputAction: TextInputAction.search,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 18.0,
      ),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   _appBarTitle = TextField(
  //     decoration: InputDecoration(
  //         border: InputBorder.none,
  //         focusedBorder: InputBorder.none,
  //         enabledBorder: InputBorder.none,
  //         errorBorder: InputBorder.none,
  //         disabledBorder: InputBorder.none,
  //         contentPadding:
  //             EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  //         hintText:  AppLocalizations.of(context).searchTextSearchPG,
  //         hintStyle:
  //             TextStyle(color: Colors.white.withOpacity(.6), fontSize: 16)),
  //     autofocus: true,
  //     onSubmitted: (String text) {
  //       search(text);
  //     },
  //     textInputAction: TextInputAction.search,
  //     style: TextStyle(
  //       color: Colors.white,
  //       fontSize: 20.0,
  //     ),
  //   );
  //   loading = false;
  //   searchedCourses = List();
  //   super.initState();
  // }

  // _getSearchedCorses(String text) async {
  //   BaseOptions options = new BaseOptions(
  //     baseUrl: "http://192.168.43.250:8000",
  //     connectTimeout: 8000,
  //     receiveTimeout: 8000,
  //     contentType: 'application/json',
  //     validateStatus: (status) {
  //       return status < 600;
  //     },
  //   );
  //   try {
  //     Dio dio = new Dio(options);
  //     dio.options.headers['content-Type'] = 'application/json';
  //     dio.options.headers["authorization"] =
  //         "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDdhNTE0YjVkMmMxMmM3NDQ5YmUwNDMiLCJpYXQiOjE2Mjc5MDUxOTgsImV4cCI6MTYzMDQ5NzE5OH0._JRb_rsNQ_Q34M399GYAe7TOHGo-sodXyIQFzewsA0k";
  //     final response = await dio
  //         .get('https://api.kpsolla.com/api/v1/courses/get', queryParameters: {
  //       "title": text,
  //     });
  //     final coursesMap = json.decode(json.encode(response.data));
  //     final map = coursesMap["courses"];
  //     // print(coursesMap);
  //     List courses = map.map((i) => Course.fromMap(i)).toList();
  //     // searchedCourses = courses;
  //     return courses;
  //   } catch (e) {

  //     return null;
  //   }

  //   // List tempList = new List();
  //   //  for (int i = 0; i <courses.length; i++) {
  //   //    tempList.add(courses[i]);
  //   //  }

  //   //  setState(() {
  //   //    names = tempList;
  //   //    filteredNames = names;
  //   //  });
  // }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return  AppBar(
      centerTitle: true,
      actions: [
        IconButton(
            icon: _searchIcon,
            onPressed: () {
              setState(() {
                if (this._searchIcon.icon == Icons.search) {
                  this._searchIcon = Icon(Icons.cancel);
                  this._appBarTitle = TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: 'البحث',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(.6),
                          fontSize: 16,
                        )),
                    autofocus: true,
                    onSubmitted: (String text) {
                      search(text, context);
                    },
                    textInputAction: TextInputAction.search,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  );
                } else {
                  setState(() {
                    _searchIcon = Icon(Icons.search);
                    _appBarTitle = Text(
                      'البحث',
                      textDirection: TextDirection.rtl,
                    );
                  });
                }
              });
            }),
      ],
      title: _appBarTitle,
    );
  }

  // void _searchPressed() {

  //   setState(() {
  //     if (this._searchIcon.icon == Icons.search) {
  //       this._searchIcon = new Icon(Icons.close);
  //       this._appBarTitle = new TextField(
  //         controller: _filter,
  //         decoration: new InputDecoration(
  //             prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
  //       );

  //     } else {
  //       this._searchIcon = new Icon(Icons.search);
  //       this._appBarTitle = new Text('Search Example');
  //       filteredNames = names;
  //       _filter.clear();
  //     }
  //   });
  // }

  // Widget _buildList() {
  //   if (_searchText.isNotEmpty) {
  //     List tempList = new List();
  //     for (int i = 0; i < filteredNames.length; i++) {
  //       if (filteredNames[i].title
  //           .toLowerCase()
  //           .contains(_searchText.toLowerCase())) {
  //         tempList.add(filteredNames[i]);
  //       }
  //     }
  //     filteredNames = tempList;
  //   }
  //   return ListView.builder(
  //     itemCount: names == null ? 0 : filteredNames.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return new ListTile(
  //         title: Text(filteredNames[index].title),
  //         onTap: () => print(filteredNames[index].title),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildBar(context),
      body: (loading != true)
          ? SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height * .773,
                  child: (searchedArticles != null &&
                          searchedArticles!.length > 0)
                      ? ListView.builder(
                          itemCount: (this.searchedArticles == null)
                              ? 0
                              : searchedArticles!.length,
                          itemBuilder: (BuildContext context, int position) {
                            if (searchedArticles![position].articletype[0] ==
                                'breaking') {
                              return Container();
                            }
                            return InkWell(
                              onTap: () {
                                // MaterialPageRoute route = MaterialPageRoute(
                                //     builder: (_) => CourseDetailScreen());
                                // Navigator.push(context, route);

                                pushNewScreen(
                                  context,
                                  screen: test(searchedArticles![position]),
                                  withNavBar:
                                      false, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.scale,
                                );
                              },
                              child: ListTile(
                                trailing: Text(searchedArticles![position]
                                    .createdAt
                                    .toString()
                                    .substring(0, 10)),
                                title: Text(searchedArticles![position].title),
                                subtitle: Text(
                                    '${searchedArticles![position].user.firstName} ${searchedArticles![position].user.lastName}'),
                              ),
                            );
                          })
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: size.height * .3,
                                top: size.height * .3),
                            child: Container(
                              child: Text('$newVariable'),
                            ),
                          ),
                        )))
          : Center(
              child: LoadingJumpingLine.circle(),
            ),
      // resizeToAvoidBottomPadding: false,
    );
  }
}
