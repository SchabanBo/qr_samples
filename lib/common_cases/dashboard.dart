import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static bool isAuthed = false;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = [
      QRoute(path: '/', builder: () => const SplashPage()),
      QRoute(path: '/login', builder: () => const LoginScreen()),
      QRoute.withChild(
          path: '/dashboard',
          builderChild: (c) => Dashboard(c),
          initRoute: '/info', // Set the init route for this router
          middleware: [
            // Set Auth middleware to redirect user when is not authed
            QMiddlewareBuilder(
              redirectGuardFunc: (s) async => isAuthed ? null : '/login',
            ),
          ],
          children: [
            QRoute(
                path: '/info',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Info', Colors.grey.shade900)),
            QRoute(
                path: '/orders',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Orders', Colors.grey.shade700)),
            QRoute(
                path: '/items',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Items', Colors.grey.shade500)),
          ]),
    ];
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes),
      theme: ThemeData.dark(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Is Authed'),
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
              child: const Text('Login'),
            ),
          ],
        ),
      );
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<bool>(
            future: Future.delayed(const Duration(seconds: 2), () => true),
            builder: (c, s) {
              if (s.hasData) {
                QR.navigator.replaceAll('/dashboard');
                return Container();
              }
              return const Center(
                  child: Text(
                'Welcome To my Sample',
                style: TextStyle(fontSize: 25, color: Colors.amber),
              ));
            }),
      );
}

class Dashboard extends StatelessWidget {
  final QRouter router;
  const Dashboard(this.router, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  MyApp.isAuthed = false;
                  QR.navigator.replaceAll('/login');
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: const Sidebar(),
            ),
            Expanded(flex: 4, child: router)
          ],
        ),
      );
}

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: const Text('Info'),
            //onTap: () => QR.navigatorOf('/dashboard').replaceAll('/info'),
            onTap: () => QR.to('/dashboard/info'),
          ),
          ListTile(
            title: const Text('Orders'),
            //onTap: () => QR.navigatorOf('/dashboard').replaceAll('/orders'),
            onTap: () => QR.to('/dashboard/orders'),
          ),
          ListTile(
            title: const Text('Items'),
            //onTap: () => QR.navigatorOf('/dashboard').replaceAll('/items'),
            onTap: () => QR.to('/dashboard/items'),
          )
        ],
      ),
    );
  }
}

class DashboardChild extends StatelessWidget {
  final String name;
  final Color color;
  const DashboardChild(this.name, this.color, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(name, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
