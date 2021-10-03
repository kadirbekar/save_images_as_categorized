import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:save_images_as_categorized/core/constants/design_constants.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';
import 'package:save_images_as_categorized/core/reusable_widgets/busy_state.dart';
import 'package:save_images_as_categorized/core/services/json_service/json_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<CategoryModel?>? _categories;

  @override
  void initState() {
    super.initState();
    _categories = [];
    _runAsyncMethod();
  }

  _runAsyncMethod() async {
    final _categoryList = await _loadCategories();
    updateStateIfMounted(() => _categories = _categoryList);
  }

  updateStateIfMounted(f) {
    if (mounted) setState(f);
  }

  _loadCategories() async =>
      await LocalJsonDataService.instance.loadCategorieJsonFromAssets();

  @override
  Widget build(BuildContext context) {
    final _appbar = AppBar(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Colors.green,
      title: const Text(
        "Categorized Images",
      ),
    );

    return Scaffold(
      appBar: _appbar,
      body: _categories!.isNotEmpty
          ? Container(
              color: Colors.green,
              child: _ImageCardList(
                categories: _categories,
              ),
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
        return _ImageCard(
          category: _categories![index]!,
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
            height: MediaQuery.of(context).size.height * 0.009,
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
    final _textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Text(
        imageText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _textScaleFactor * 18,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
