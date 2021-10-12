import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';

class FileService {

  static FileService? _instance;
  static FileService get instance => _instance ??= FileService._initialize();

  late final Directory _appDocumentDirectory;

  void createFolder({
    required String rootFolderName,
    required List<CategoryModel?>? subFolders,
  }) async {
    _appDocumentDirectory = await getApplicationDocumentsDirectory();
    Directory _rootFolder = Directory("${_appDocumentDirectory.path}/$rootFolderName");
    if (await _rootFolder.exists()) return;
    await _rootFolder.create(recursive: true);
    _createPerImageCategoryFolder(
      subFolders: subFolders,
      rootFolderName: rootFolderName,
    );
  }

  void _createPerImageCategoryFolder({
    required List<CategoryModel?>? subFolders,
    required String rootFolderName,
  }) {
    subFolders?.forEach((category) async {
      final Directory _categoryFolderName = Directory("${_appDocumentDirectory.path}/$rootFolderName/${category?.id}");
      if (await _categoryFolderName.exists()) return;
      await _categoryFolderName.create(recursive: true);
    });
  }

  FileService._initialize();
}
