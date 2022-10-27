import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() => runApp(const MyApp());

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
          builderChild: (c) => NavRailExample(c),
          children: [
            QRoute(
              name: tabs[0],
              pageType: const QSlidePage(),
              path: '/',
              builder: () => Tab('Home', Colors.grey.shade900),
            ),
            QRoute(
              name: tabs[1],
              pageType: const QSlidePage(),
              path: '/store',
              builder: () => Tab('Store', Colors.grey.shade700),
            ),
            QRoute(
              name: tabs[2],
              pageType: const QSlidePage(),
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

class NavRailExample extends StatefulWidget {
  final QRouter router;
  const NavRailExample(this.router, {Key? key}) : super(key: key);

  @override
  State<NavRailExample> createState() => _NavRailExampleState();
}

class _NavRailExampleState extends RouterState<NavRailExample> {
  @override
  QRouter get router => widget.router;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: MyApp.indexOf(widget.router.routeName),
              onDestinationSelected: (v) => QR.toName(MyApp.tabs[v]),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.store),
                  label: Text('Store'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: widget.router),
          ],
        ),
      ),
    );
  }
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
