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
        '/upload': (context) => const Scaffold(body: DatasetUploadPage()),
        '/open': (context) =>
            const Scaffold(body: Center(child: DatasetInteractionPage())),
        '/saved': (context) =>
            const Scaffold(body: Center(child: DatasetViewPage())),
        '/results': (context) =>
            const Scaffold(body: Center(child: Text('Algorithm Results Page'))),
      },
    ),
  );
}
