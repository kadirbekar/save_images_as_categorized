import 'package:flutter/material.dart';

class CategoryModel {

  final int? id;
  final String? name;
  final String? bannerUrl;
  final List<ImageModel>? images;

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
        images: List<ImageModel>.from(
          json["images"].map(
            (x) => ImageModel.fromJson(x),
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

class ImageModel {
  
  final String? path;
  final String? addedDate;

  const ImageModel({
    this.path,
    this.addedDate,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        path: json["path"],
        addedDate: json["addedDate"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "addedDate": addedDate,
      };
}
