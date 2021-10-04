import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:save_images_as_categorized/core/services/local_storage/hive_manager.dart';
import 'package:save_images_as_categorized/view/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  await HiveManager.instance.initializeHive();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(
    const CategorizedImages(),
  );
}

class CategorizedImages extends StatelessWidget {
  const CategorizedImages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily),
      title: 'Categorized Images',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
