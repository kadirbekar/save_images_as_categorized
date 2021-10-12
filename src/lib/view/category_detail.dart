import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_images_as_categorized/core/constants/string_constants.dart';
import 'package:save_images_as_categorized/core/extensions/context_extension.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';
import 'package:save_images_as_categorized/core/reusable_widgets/empty_state.dart';

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
  @override
  Widget build(BuildContext context) {
    final _appbar = AppBar(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Colors.green,
      title: Text(
        widget.category.name!,
      ),
    );

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Gallery",
            backgroundColor: Colors.green,
            onPressed: () async => _pickImage(ImageSource.gallery),
            child: const Icon(
              Icons.sd_storage_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: "Camera",
            backgroundColor: Colors.green,
            onPressed: () async => _pickImage(ImageSource.camera),
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
        ],
      ),
      appBar: _appbar,
      body: widget.category.images != null
          ? (widget.category.images!.isNotEmpty
              ? _BuildCategorizedImageList(
                  imageList: widget.category.images,
                )
              : const EmptyState())
          : const SizedBox.shrink(),
    );
  }

  _pickImage(ImageSource source) async {
    final _image = await ImagePicker().pickImage(
      source: source,
    );

    if (_image != null) {
      setState(
        () {
          widget.category.images?.add(
            ImageModel(
              addedDate: DateTime.now().toString(),
              path: _image.path,
            ),
          );
        },
      );
    }
  }
}

class _BuildCategorizedImageList extends StatelessWidget {
  const _BuildCategorizedImageList({
    Key? key,
    required imageList,
  })  : _imageList = imageList,
        super(key: key);

  final List<ImageModel> _imageList;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemCount: _imageList.length,
      crossAxisCount: 4,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              _ImageAddedDateText(addedDate: _imageList[index].addedDate!),
              _Image(imagePath: _imageList[index].path!),
            ],
          ),
        );
      },
      staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.file(
            File(
              imagePath,
            ),
            fit: BoxFit.cover,
            height: context.height * 0.35,
            width: context.width * 0.35,
          ),
        ),
      ),
    );
  }
}

class _ImageAddedDateText extends StatelessWidget {
  const _ImageAddedDateText({
    Key? key,
    required this.addedDate,
  }) : super(key: key);

  final String addedDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          StringConstants.formatter.format(
            DateTime.parse(
              addedDate,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
