import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool isAuthed = false;
  final routes = [
    QRoute(path: '/', builder: () => LandingPage()),
    QRoute(path: '/login', builder: () => LoginScreen()),
    QRoute.withChild(
        path: '/dashboard',
        builderChild: (c) => Dashboard(c),
        initRoute: '/info', // Set the init route for this router
        middleware: [
          // Set Auth middleware to redirect user when is not authed
          QMiddlewareBuilder(
              redirectGuardFunc: (s) async => isAuthed ? null : '/login'),
        ],
        children: [
          QRoute(
              path: '/info',
              builder: () => DashboardChild('Info', Colors.blueGrey.shade900)),
          QRoute(
              path: '/orders',
              builder: () =>
                  DashboardChild('Orders', Colors.blueGrey.shade700)),
          QRoute(
              path: '/items',
              builder: () => DashboardChild('Items', Colors.blueGrey.shade500)),
        ]),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: QRouteInformationParser(),
        routerDelegate: QRouterDelegate(routes),
        theme: ThemeData.dark(),
      );
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Is Authed'),
                Switch(
                    value: MyApp.isAuthed,
                    onChanged: (v) {
                      setState(() {
                        MyApp.isAuthed = v;
                      });
                    })
              ],
            ),
            TextButton(
                onPressed: () => QR.navigator.replaceAll('/dashboard'),
                child: Text('Login')),
            TextButton(
                onPressed: () => QR.navigator.replaceAll('/signup'),
                child: Text('Or Signup'))
          ],
        ),
      );
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<bool>(
            future: Future.delayed(Duration(seconds: 2), () => true),
            builder: (c, s) {
              if (s.hasData) {
                QR.navigator.replaceAll('/dashboard');
                return Container();
              }
              return Center(
                  child: Text(
                'Wellcome To my Sample',
                style: TextStyle(fontSize: 25, color: Colors.amber),
              ));
            }),
      );
}

class Dashboard extends StatelessWidget {
  final QRouter router;
  Dashboard(this.router);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  MyApp.isAuthed = false;
                  QR.navigator.replaceAll('/login');
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Row(
          children: [
            Flexible(child: Sidebar()),
            Expanded(flex: 4, child: router)
          ],
        ),
      );
}

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey.shade800,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text('Info'),
              onTap: () => QR.to('/dashboard/info'),
            ),
            ListTile(
              title: Text('Orders'),
              onTap: () => QR.to('/dashboard/orders'),
            ),
            ListTile(
              title: Text('Items'),
              onTap: () => QR.to('/dashboard/items'),
            )
          ],
        ),
      );
}

class DashboardChild extends StatelessWidget {
  final String name;
  final Color color;
  DashboardChild(this.name, this.color);
  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: Center(child: Text(name, style: TextStyle(fontSize: 20))),
      );
}
