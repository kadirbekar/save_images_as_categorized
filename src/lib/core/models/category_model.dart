class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.bannerUrl,
    required this.images,
  });

  final int? id;
  final String? name;
  final String? bannerUrl;
  final List<ImageModel>? images;

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
        "bannerUrl": bannerUrl,
        "images": List<dynamic>.from(
          images!.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class ImageModel {
  const ImageModel({
    this.path,
    this.addedDate,
  });

  final String? path;
  final String? addedDate;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        path: json["path"],
        addedDate: json["addedDate"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "addedDate": addedDate,
      };
}
