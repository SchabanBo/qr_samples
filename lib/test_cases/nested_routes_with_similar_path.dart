import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

// https://github.com/SchabanBo/qlevar_router/issues/45
void main() {
  runApp(MyApp());
}

List<String> tabs = [
  "test1",
  "test2",
  "test3",
];

const String _goToDetailsText = "GoToDetails";
int counter = 0;

class MyApp extends StatelessWidget {
  final routes = [
    QRoute.withChild(
      path: '/home',
      initRoute: '/test1',
      builderChild: (router) => HomeScreen(router: router),
      children: [
        PostRoute().routes(tabs[0]),
        PostRoute().routes(tabs[1]),
        PostRoute().routes(tabs[2]),
      ],
    )
  ];
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes, initPath: '/home'));
}

class PostRoute {
  QRoute routes(String name) => QRoute.withChild(
        path: '/$name',
        initRoute: '/grid',
        name: name,
        middleware: [QMiddlewareBuilder(onEnterFunc: () async => counter++)],
        builderChild: (child) => PostRouteWrapper(child, name),
        children: [
          QRoute(
            name: '$name-grid',
            path: '/grid',
            builder: () => const Text('grid page'),
          ),
          QRoute(
            name: '$name-detail',
            path: '/detail/:index',
            builder: () => const Text('detail page'),
          )
        ],
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.router}) : super(key: key);
  final QRouter router;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.router.navigator.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.router,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            tabs.indexWhere((element) => element == widget.router.routeName),
        onTap: (value) => QR.toName(tabs[value],
            pageAlreadyExistAction: PageAlreadyExistAction.BringToTop),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'test1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'test2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'test3',
          ),
        ],
      ),
    );
  }
}

class PostRouteWrapper extends StatelessWidget {
  final QRouter router;
  final String name;
  PostRouteWrapper(this.router, this.name);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(name),
            TextButton(
                onPressed: () => router.navigator.pushName('test1-detail',
                    params: {'index': Random().nextInt(1000)}),
                child: Text(_goToDetailsText)),
            Container(
              width: size.width * 0.7,
              height: size.height * 0.7,
              child: router,
            )
          ],
        ),
      ),
    );
  }
}
