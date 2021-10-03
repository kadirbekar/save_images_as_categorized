import 'package:flutter/material.dart';

class BusyState extends StatelessWidget {
  const BusyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
