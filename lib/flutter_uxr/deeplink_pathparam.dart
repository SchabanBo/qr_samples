import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
      Book('Foundation', 'Isaac Asimov'),
      Book('Fahrenheit 451', 'Ray Bradbury'),
    ];
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(
        [
          QRoute(path: '/', builder: () => BooksListScreen(books)),
          QRoute(
              path:
                  '/books/:id([0-${books.length - 1}])', // The only available pages are the pages in the list
              builder: () => BookDetailsScreen(books[QR.params['id']!.asInt!])),
        ],
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
  final List<Book> books;
  const BooksListScreen(this.books, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () => QR.to('/books/${books.indexOf(book)}'))
        ],
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  const BookDetailsScreen(this.book, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: Theme.of(context).textTheme.titleLarge),
            Text(book.author, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
