import 'package:flutter/material.dart';
import 'package:save_images_as_categorized/core/extensions/context_extension.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            "https://cdn-icons-png.flaticon.com/512/4076/4076259.png",
            height: context.height * 0.40,
            width: context.width * 0.40,
          ),
          Text(
            message ?? "No Data Saved",
            style: TextStyle(
              fontSize: context.textScaleFactor * 24,
            ),
          ),
        ],
      ),
    );
  }
}
