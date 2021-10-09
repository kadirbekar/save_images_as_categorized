import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_images_as_categorized/core/extensions/context_extension.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';
import 'package:save_images_as_categorized/core/reusable_widgets/empty_state.dart';
import 'package:save_images_as_categorized/core/services/local_storage/hive_manager.dart';

class CategoryDetail extends StatefulWidget {
  const CategoryDetail({
    Key? key,
    required this.category,
  }) : super(key: key);

  final CategoryModel category;

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  ValueNotifier<List<String>>? _savedImagePathList;

  @override
  void initState() {
    super.initState();
    _savedImagePathList?.value = <String>[];
    _savedImagePathList?.value = _runAsyncMethod();
  }

  _runAsyncMethod() async {
    widget.category.images?.forEach((image) {
      _savedImagePathList?.value.add(image.path!);
    });
    _updateStateIfMounted();
  }

  _updateStateIfMounted() => mounted ? setState(() {}) : null;

  @override
  void dispose() {
    _savedImagePathList?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appbar = AppBar(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Colors.green,
      title: const Text(
        "Saved Images",
      ),
    );

    return Scaffold(
      floatingActionButton: _AddImage(widget: widget),
      appBar: _appbar,
      body: _savedImagePathList?.value != null
          ? ValueListenableBuilder(
              valueListenable: _savedImagePathList!,
              builder: (context, List<String> imageList, widget) {
                return _BuildCategorizedImageList(
                  imageList: imageList,
                );
              },
            )
          : const EmptyState(),
    );
  }
}

class _AddImage extends StatelessWidget {
  const _AddImage({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CategoryDetail widget;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () async {
        final _image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );

        if (_image != null) {
          await HiveManager.instance.addData(
            "${widget.category.id}",
            _image.path,
          );
        }
      },
      child: const Icon(
        Icons.add_a_photo,
        color: Colors.white,
      ),
    );
  }
}

class _BuildCategorizedImageList extends StatelessWidget {
  const _BuildCategorizedImageList({
    Key? key,
    required imageList,
  })  : _imageList = imageList,
        super(key: key);

  final String _imageList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(12),
          color: Colors.orange,
          child: Row(
            children: [
              Card(
                child: Image.file(
                  File(
                    _imageList[index],
                  ),
                  fit: BoxFit.contain,
                  height: context.height * 0.20,
                  width: context.width * 0.50,
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
  }
}
