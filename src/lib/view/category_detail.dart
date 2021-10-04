import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';
import 'package:save_images_as_categorized/core/services/local_storage/hive_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryDetail extends StatefulWidget {
  const CategoryDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  late Box<String> _savedImageBoxList;

  @override
  void initState() {
    super.initState();
    _savedImageBoxList = Hive.box(HiveManager.instance.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final _image =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (_image != null) {
            await HiveManager.instance.addData(
              HiveManager.instance.image,
              _image.path,
            );
          }
        },
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          "Saved Images",
        ),
      ),
      body: _savedImageBoxList.isNotEmpty
          ? ValueListenableBuilder(
              valueListenable: _savedImageBoxList.listenable(),
              builder: (context, Box<String> currentImage, widget) {
                return ListView.builder(
                  itemCount: currentImage.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _key = currentImage.keys.toList()[index];
                    final _value = currentImage.get(_key)!;
                    return Container(
                      margin: const EdgeInsets.all(12),
                      color: Colors.orange,
                      child: Row(
                        children: [
                          Card(
                            child: Image.file(
                              File(
                                _value,
                              ),
                              fit: BoxFit.contain,
                              height: MediaQuery.of(context).size.height * 0.20,
                              width: MediaQuery.of(context).size.width * 0.50,
                            ),
                          ),
                          const Center(
                            child: Text(
                              "Added Date : ",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text(
                "Empty Data",
              ),
            ),
    );
  }
}
