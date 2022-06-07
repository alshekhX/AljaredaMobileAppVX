// To parse this JSON data, do
//
//     final userInfo = userInfoFromMap(jsonString);

import 'dart:convert';

import 'package:aljaredanews/models/Article.dart';

class SavedArticle {
    SavedArticle({
        this.approved,
        this.category,
        this.articletype,
        this.photo,
        this.video,
        this.audio,
        this.id,
        this.title,
        this.place,
        this.user,
        this.description,
        this.createdAt,
        this.publishedAt,
        this.v,
    });

    bool? approved;
    List<String>? category;
    List<String>? articletype;
    String ?photo;
    String ?video;
    String ?audio;
    String ?id;
    String ?title;
    String ?place;
    UserInfo? user;
    String ?description;
    DateTime? createdAt;
    DateTime ?publishedAt;
    int? v;

    factory SavedArticle.fromJson(String str) => SavedArticle.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SavedArticle.fromMap(Map<String, dynamic> json) => SavedArticle(
        approved: json["approved"] == null ? null : json["approved"],
        category: json["category"] == null ? null : List<String>.from(json["category"].map((x) => x)),
        articletype: json["articletype"] == null ? null : List<String>.from(json["articletype"].map((x) => x)),
        photo: json["photo"] == null ? null : json["photo"],
        video: json["video"] == null ? null : json["video"],
        audio: json["audio"] == null ? null : json["audio"],
        id: json["_id"] == null ? null : json["_id"],
        title: json["title"] == null ? null : json["title"],
        place: json["place"] == null ? null : json["place"],
        user: json["user"] == null ? null : UserInfo.fromMap(json["user"]),
        description: json["description"] == null ? null : json["description"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
        v: json["__v"] == null ? null : json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "approved": approved == null ? null : approved,
        "category": category == null ? null : List<dynamic>.from(category!.map((x) => x)),
        "articletype": articletype == null ? null : List<dynamic>.from(articletype!.map((x) => x)),
        "photo": photo == null ? null : photo,
        "video": video == null ? null : video,
        "audio": audio == null ? null : audio,
        "_id": id == null ? null : id,
        "title": title == null ? null : title,
        "place": place == null ? null : place,
        "user": user == null ? null : user!.toMap(),
        "description": description == null ? null : description,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "publishedAt": publishedAt == null ? null : publishedAt!.toIso8601String(),
        "__v": v == null ? null : v,
    };
}

class UserInfo {
    UserInfo({
        this.photo,
        this.role,
        this.createdAt,
        this.savedArticles,
        this.id,
        this.firstName,
        this.userName,
        this.lastName,
        this.email,
        this.v,
    });

    String ?photo;
    String ?role;
    DateTime? createdAt;
    List<ArticleModel>? savedArticles;
    String? id;
    String? firstName;
    String ?userName;
    String ?lastName;
    String ?email;
    int ?v;

    factory UserInfo.fromJson(String str) => UserInfo.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserInfo.fromMap(Map<String, dynamic> json) => UserInfo(
        photo: json["photo"] == null ? null : json["photo"],
        role: json["role"] == null ? null : json["role"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        savedArticles: json["savedArticles"] == null ? null : List<ArticleModel>.from(json["savedArticles"].map((x) => ArticleModel.fromMap(x))),
        id: json["_id"] == null ? null : json["_id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        userName: json["userName"] == null ? null : json["userName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        email: json["email"] == null ? null : json["email"],
        v: json["__v"] == null ? null : json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "photo": photo == null ? null : photo,
        "role": role == null ? null : role,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "savedArticles": savedArticles == null ? null : List<dynamic>.from(savedArticles!.map((x) => x.toMap())),
        "_id": id == null ? null : id,
        "firstName": firstName == null ? null : firstName,
        "userName": userName == null ? null : userName,
        "lastName": lastName == null ? null : lastName,
        "email": email == null ? null : email,
        "__v": v == null ? null : v,
    };
}
