import 'package:flutter/material.dart';

class CategoryModel {

  final int? id;
  final String? name;
  final String? bannerUrl;
  final List<Image>? images;

  const CategoryModel({
    @required this.id,
    @required this.name,
    @required this.images,
    @required this.bannerUrl
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        bannerUrl: json["bannerUrl"],
        images: List<Image>.from(
          json["images"].map(
            (x) => Image.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "images": List<dynamic>.from(
          images!.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class Image {
  
  final String? path;
  final String? addedDate;

  const Image({
    this.path,
    this.addedDate,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        path: json["path"],
        addedDate: json["addedDate"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "addedDate": addedDate,
      };
}
