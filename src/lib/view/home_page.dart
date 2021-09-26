import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';
import 'package:save_images_as_categorized/core/services/json_service/json_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  _getCategories() async {
    final _categoryList = await _loadCategories();
    if (mounted) {
      setState(() {
        _categories = _categoryList;
      });
    }
  }

  _loadCategories() async {
    return await JsonService.instance.loadCategorieJsonFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[400],
        title: const Text(
          "Categorized Images",
        ),
      ),
      body: _categories.isNotEmpty
          ? StaggeredGridView.countBuilder(
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemCount: _categories.length,
              crossAxisCount: 4,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return Card(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          height: double.infinity,
                          width: double.infinity,
                          imageUrl: _categories[index].bannerUrl!,
                          repeat: ImageRepeat.noRepeat,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                );
              },
              staggeredTileBuilder: (int index) => StaggeredTile.count(
                2,
                index.isEven ? 2 : 1,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
