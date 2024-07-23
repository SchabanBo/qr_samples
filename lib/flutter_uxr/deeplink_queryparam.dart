import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(
        [QRoute(path: '/', builder: () => const BooksListScreen())],
      ),
    );
  }
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class BooksListScreen extends StatelessWidget {
  const BooksListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final books = [
      Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
      Book('Foundation', 'Isaac Asimov'),
      Book('Fahrenheit 451', 'Ray Bradbury'),
    ];
    print(QR.params.asStringMap());
    final filter = QR.params['filter'];
    final random = QR.params['random']?.asDouble ?? 0;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(random.toString()),
          TextField(
            decoration: const InputDecoration(hintText: 'filter'),
            onSubmitted: (v) {
              QR.params.addAsHidden('random', Random().nextDouble());
              print(QR.params.asStringMap());
              QR.to('/${v.isEmpty ? '' : '/?filter=$v'}');
            },
          ),
          for (var book in books)
            if (filter == null ||
                book.title.toLowerCase().contains(filter.toString()))
              ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
              )
        ],
      ),
    );
  }
}
