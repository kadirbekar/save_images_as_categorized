import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';

class FileService {

  static FileService? _instance;
  static FileService get instance => _instance ??= FileService._initialize();

  late Directory? _appDocumentDirectory;

  void createFolder({
    required String rootFolderName,
    required List<CategoryModel?>? categoryList,
  }) async {
    _appDocumentDirectory = await getExternalStorageDirectory();
    final Directory _rootFolder = Directory("${_appDocumentDirectory?.path}/$rootFolderName");
    if (!await _rootFolder.exists()) {
      await _rootFolder.create(recursive: true);
    }
    _createPerImageCategoryFolder(
      categoryList: categoryList,
      rootFolderName: rootFolderName,
    );
  }

  void _createPerImageCategoryFolder({
    required String rootFolderName,
    required List<CategoryModel?>? categoryList,
  }) {
    categoryList?.forEach(
      (category) async {
        final _imageCategoryFolderPath = "${_appDocumentDirectory?.path}/$rootFolderName/${category?.id}";
        final Directory _categoryFolderName = Directory(_imageCategoryFolderPath);
        if (!await _categoryFolderName.exists()) {
          await _categoryFolderName.create(recursive: true);
        }
        category?.images?.forEach((image) async {
          if(image.path == null) return;
          await _copyImageToItsRelatedCategoryFolder(
            path: image.path,
            folderDirectory: _categoryFolderName.path
          );
        });
      },
    );
  }

  Future _copyImageToItsRelatedCategoryFolder({
    required String? path, 
    required folderDirectory
  }) async {
    const _applicationDataFolderDirectory = "/data/user/0/com.example.save_images_as_categorized/cache/";
    final File _imageFile = File(path!);
    final _imageName = _imageFile.toString().split(_applicationDataFolderDirectory)[1].split("'")[0];
    await _imageFile.copy("$folderDirectory/$_imageName");
  }

  FileService._initialize();
}
