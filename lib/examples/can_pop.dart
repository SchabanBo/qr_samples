import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(MyApp());
}

bool canpop = true;

class MyApp extends StatelessWidget {
  final books = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: QRouteInformationParser(),
      routerDelegate: QRouterDelegate([
        QRoute(path: '/', builder: () => BooksListScreen(books)),
        QRoute(
            path:
                '/books/:id([0-${books.length - 1}])', // The only available pages are the pages in the list
            middleware: [
              QMiddlewareBuilder(canPopFunc: () async => canpop),
            ],
            builder: () => BookDetailsScreen(books[QR.params['id']!.asInt!])),
      ]));
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class BooksListScreen extends StatelessWidget {
  final List<Book> books;
  BooksListScreen(this.books);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  BookDetailsScreen(this.book);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: Theme.of(context).textTheme.headline6),
            Text(book.author, style: Theme.of(context).textTheme.subtitle1),
            Row(
              children: [
                Text('Can you return  ?'),
                CanPopWidget(),
              ],
            ),
            TextButton(onPressed: QR.back, child: Text('Back')),
          ],
        ),
      ),
    );
  }
}

class CanPopWidget extends StatefulWidget {
  const CanPopWidget({Key? key}) : super(key: key);

  @override
  _CanPopWidgetState createState() => _CanPopWidgetState();
}

class _CanPopWidgetState extends State<CanPopWidget> {
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: canpop,
        onChanged: (s) {
          canpop = s;
          setState(() {});
        });
  }
}
