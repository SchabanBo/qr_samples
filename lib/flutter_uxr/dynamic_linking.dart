import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(WishlistApp());
}

class Wishlist {
  final String id;

  Wishlist(this.id);
}

class AppState extends ChangeNotifier {
  final List<Wishlist> wishlists = <Wishlist>[];

  Wishlist getList() {
    final id = QR.params['id'].toString();
    if (!wishlists.any((element) => element.id == id)) {
      wishlists.add(Wishlist(id));
      notifyListeners();
    }
    return wishlists.firstWhere((element) => element.id == id);
  }
}

class WishlistApp extends StatelessWidget {
  final appState = AppState();

  WishlistApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wishlist App',
      routerDelegate: QRouterDelegate([
        QRoute(path: '/', builder: () => WishlistListScreen(appState)),
        QRoute(
            path: '/wishlist/:id',
            builder: () => WishlistScreen(appState.getList()))
      ]),
      routeInformationParser: const QRouteInformationParser(),
    );
  }
}

class WishlistListScreen extends StatefulWidget {
  final AppState appState;
  const WishlistListScreen(this.appState, {super.key});
  @override
  State<WishlistListScreen> createState() => _WishlistListScreenState();
}

class _WishlistListScreenState extends State<WishlistListScreen> {
  List<Wishlist> wishlists = [];
  @override
  void initState() {
    super.initState();
    widget.appState.addListener(() {
      setState(() {
        wishlists = widget.appState.wishlists;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Wishlist')),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  'Navigate to /wishlist/<ID> in the URL bar to dynamically '
                  'create a new wishlist.'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => QR.to('wishlist/${Random().nextInt(1000)}'),
                child: const Text('Create a new Wishlist'),
              ),
            ),
            for (var i = 0; i < wishlists.length; i++)
              ListTile(
                title: Text('Wishlist ${i + 1}'),
                subtitle: Text(wishlists[i].id),
                onTap: () => QR.to('wishlist/${wishlists[i].id}'),
              )
          ],
        ),
      );

  @override
  void dispose() {
    widget.appState.dispose();
    super.dispose();
  }
}

class WishlistScreen extends StatelessWidget {
  final Wishlist wishlist;
  const WishlistScreen(this.wishlist, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${QR.params['id']}',
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      );
}
