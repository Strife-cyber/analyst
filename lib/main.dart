import 'package:analyst/pages/dataset_interaction_page.dart';
import 'package:analyst/pages/dataset_upload_page.dart';
import 'package:analyst/pages/dataset_view_page.dart';
import 'package:analyst/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/upload': (context) => const DatasetUploadPage(),
        '/open': (context) => const DatasetInteractionPage(),
        '/saved': (context) => const DatasetViewPage()
      },
    ),
  );
}
