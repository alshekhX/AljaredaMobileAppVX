// To parse this JSON data, do
//
//     final crossWordM = crossWordMFromMap(jsonString);

import 'dart:convert';

class CrossWordM {
    CrossWordM({
        this.rowsWords,
        this.columnsWords,
        this.rowsQuestions,
        this.columnsQuestions,
        this.createdAt,
        this.id,
        this.v,
    });

    List<String>? rowsWords;
    List<dynamic>? columnsWords;
    List<String> ?rowsQuestions;
    List<String> ?columnsQuestions;
    DateTime ?createdAt;
    String? id;
    int ?v;

    factory CrossWordM.fromJson(String str) => CrossWordM.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CrossWordM.fromMap(Map<String, dynamic> json) => CrossWordM(
        rowsWords: json["rowsWords"] == null ? null : List<String>.from(json["rowsWords"].map((x) => x)),
        columnsWords: json["columnsWords"] == null ? null : List<dynamic>.from(json["columnsWords"].map((x) => x)),
        rowsQuestions: json["rowsQuestions"] == null ? null : List<String>.from(json["rowsQuestions"].map((x) => x)),
        columnsQuestions: json["columnsQuestions"] == null ? null : List<String>.from(json["columnsQuestions"].map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        id: json["_id"] == null ? null : json["_id"],
        v: json["__v"] == null ? null : json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "rowsWords": rowsWords == null ? null : List<dynamic>.from(rowsWords!.map((x) => x)),
        "columnsWords": columnsWords == null ? null : List<dynamic>.from(columnsWords!.map((x) => x)),
        "rowsQuestions": rowsQuestions == null ? null : List<dynamic>.from(rowsQuestions!.map((x) => x)),
        "columnsQuestions": columnsQuestions == null ? null : List<dynamic>.from(columnsQuestions!.map((x) => x)),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "_id": id == null ? null : id,
        "__v": v == null ? null : v,
    };
}
