import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {

  static HiveManager? _instance;
  static HiveManager get instance => _instance ??= HiveManager._initialize();

  final String _imageList = "imageList";
  get image => _imageList;

  Future<void> initializeHive() async {
    final Directory _documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(_documentDirectory.path);
    await Hive.openBox<String>(_imageList);
  }

  Future<T?> getData<T>(String box, dynamic key) async {
    return Hive.box<T>(box).get(key);
  }

  Future<List<T>> getAll<T>(String boxName) async {
    return Hive.box<T>(boxName).values.toList();
  }

  Future<int> addData<T>(String box, T willBeAddedData) async {
    return await Hive.box<T>(box).add(willBeAddedData);
  }

  HiveManager._initialize();
}
