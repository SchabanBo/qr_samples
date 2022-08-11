import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool isAuthed = false;
  static List<String> tabs = [
    "Home Page",
    "Store Page",
    "Settings Page",
  ];
  final routes = [
    QRoute(path: '/login', builder: () => LoginScreen()),
    QRoute(path: '/signup', builder: () => SignupScreen()),
    QRoute.withChild(
        path: '/home',
        builderChild: (c) => HomePage(c),
        middleware: [
          // Set Auth middleware to redirect user when is not authed
          QMiddlewareBuilder(
              redirectGuardFunc: (s) async => isAuthed ? null : '/login'),
        ],
        children: [
          QRoute(
              name: tabs[0],
              path: '/',
              builder: () => Tab('Home', Colors.blueGrey.shade900)),
          QRoute(
              name: tabs[1],
              path: '/store',
              builder: () => Tab('Store', Colors.blueGrey.shade700)),
          QRoute(
              name: tabs[2],
              path: '/settings',
              builder: () => Tab('Settings', Colors.blueGrey.shade500)),
        ]),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: QRouteInformationParser(),
        routerDelegate: QRouterDelegate(routes, initPath: '/home'),
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
                onPressed: () => QR.navigator.replaceAll('/home'),
                child: Text('Login')),
            TextButton(
                onPressed: () => QR.navigator.replaceAll('/signup'),
                child: Text('Or Signup'))
          ],
        ),
      );
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
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
                onPressed: () => QR.navigator.replaceAll('/home'),
                child: Text('Signup')),
            TextButton(
                onPressed: () => QR.navigator.replaceAll('/login'),
                child: Text('Have account? login.'))
          ],
        ),
      );
}

class HomePage extends StatefulWidget {
  final QRouter router;
  HomePage(this.router);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // We need to add listener here so the bottomNavigationBar
    // get updated (the selected tab) when we navigate to new page
    widget.router.navigator.addListener(_update);
  }

  void _update() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.router.navigator.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('My App'),
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
        body: widget.router,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'store'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
          currentIndex: MyApp.tabs
              .indexWhere((element) => element == widget.router.routeName),
          onTap: (v) => QR.toName(MyApp.tabs[v]),
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
              title: Text('Orders'),
              onTap: () => QR.to('/dashboard/orders'),
            ),
            ListTile(
              title: Text('Users'),
              onTap: () => QR.to('/dashboard/users'),
            ),
            ListTile(
              title: Text('Stores'),
              onTap: () => QR.to('/dashboard/stores'),
            )
          ],
        ),
      );
}

class Tab extends StatelessWidget {
  final String name;
  final Color color;
  Tab(this.name, this.color);
  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: Center(child: Text(name, style: TextStyle(fontSize: 20))),
      );
}
