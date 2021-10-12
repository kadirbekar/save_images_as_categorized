import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:save_images_as_categorized/core/constants/design_constants.dart';
import 'package:save_images_as_categorized/core/constants/string_constants.dart';
import 'package:save_images_as_categorized/core/extensions/context_extension.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';
import 'package:save_images_as_categorized/core/reusable_widgets/busy_state.dart';
import 'package:save_images_as_categorized/core/services/file_service/file_service.dart';
import 'package:save_images_as_categorized/core/services/json_service/json_service.dart';
import 'package:save_images_as_categorized/view/category_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<CategoryModel?>? _imageCategoryList;

  @override
  void initState() {
    super.initState();
    _imageCategoryList = [];
    _runAsyncMethod();
  }

  _runAsyncMethod() async {
    final _categoryList = await _loadCategoryList();
    _updateStateIfMounted(() => _imageCategoryList = _categoryList);
  }

  _loadCategoryList() async =>
      await LocalJsonDataService.instance.loadCategoryJsonFromAssets();

  _updateStateIfMounted(f) => mounted ? setState(f) : null;

  @override
  Widget build(BuildContext context) {
    final _appbar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.green,
      title: const Text(
        StringConstants.mainTitle,
      ),
      actions: [
        TextButton(
          onPressed: () async => FileService.instance.createFolder(
            rootFolderName: "images",
            subFolders: _imageCategoryList
          ),
          child: Text(
            "Archive",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18 * context.textScaleFactor,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: _appbar,
      backgroundColor: Colors.green,
      body: _imageCategoryList!.isNotEmpty
          ? _ImageCardList(
              categories: _imageCategoryList,
            )
          : const BusyState(),
    );
  }
}

class _ImageCardList extends StatelessWidget {
  const _ImageCardList({
    Key? key,
    required List<CategoryModel?>? categories,
  })  : _categories = categories,
        super(key: key);

  final List<CategoryModel?>? _categories;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemCount: _categories!.length,
      crossAxisCount: 4,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryDetail(
                category: _categories![index]!,
              ),
            ),
          ),
          child: _ImageCard(
            category: _categories![index]!,
          ),
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(
        2,
        index.isEven ? 2 : 1.5,
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final CategoryModel category;
  const _ImageCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          DesignContants.borderRadius,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.009,
          ),
          _ImageTitle(
            imageText: category.name!,
          ),
          _Image(
            imageUrl: category.bannerUrl!,
          )
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String imageUrl;

  const _Image({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            DesignContants.borderRadius,
          ),
          child: CachedNetworkImage(
            height: double.infinity,
            width: double.infinity,
            imageUrl: imageUrl,
            repeat: ImageRepeat.noRepeat,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _ImageTitle extends StatelessWidget {
  final String imageText;
  const _ImageTitle({
    Key? key,
    required this.imageText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Text(
        imageText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: context.textScaleFactor * 18,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
