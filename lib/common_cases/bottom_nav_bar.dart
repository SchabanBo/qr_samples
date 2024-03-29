import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static List<String> tabs = [
    "Home Page",
    "Store Page",
    "Settings Page",
  ];

  static int indexOf(String name) => tabs.indexWhere((e) => e == name);
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = [
      QRoute.withChild(
          path: '/home',
          builderChild: (c) => HomePage(c),
          children: [
            QRoute(
              name: tabs[0],
              path: '/',
              builder: () => Tab('Home', Colors.grey.shade900),
            ),
            QRoute(
              name: tabs[1],
              path: '/store',
              builder: () => Tab('Store', Colors.grey.shade700),
            ),
            QRoute(
              name: tabs[2],
              path: '/settings',
              builder: () => Tab('Settings', Colors.grey.shade500),
            ),
          ]),
    ];
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes, initPath: '/home'),
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}

class HomePage extends StatefulWidget {
  final QRouter router;
  const HomePage(this.router, {Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends RouterState<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('My App')),
        body: widget.router,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'store'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
          currentIndex: MyApp.indexOf(widget.router.routeName),
          onTap: (v) => QR.toName(MyApp.tabs[v]),
        ),
      );

  @override
  QRouter get router => widget.router;
}

class Tab extends StatelessWidget {
  final String name;
  final Color color;
  const Tab(this.name, this.color, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: Center(
          child: Text(name, style: const TextStyle(fontSize: 20)),
        ),
      );
}
