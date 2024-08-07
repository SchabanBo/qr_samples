import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(BooksApp());
}

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

abstract class Authentication {
  Future<bool> isSignedIn();

  Future<void> signOut();

  Future<bool> signIn(Credentials credentials);
}

class MockAuthentication extends QMiddleware implements Authentication {
  bool _signedIn = false;

  @override
  Future<bool> isSignedIn() async {
    return _signedIn;
  }

  @override
  Future<void> signOut() async {
    _signedIn = false;
    QR.to('/', ignoreSamePath: false);
  }

  @override
  Future<bool> signIn(Credentials credentials) async {
    return _signedIn = true;
  }

  @override
  Future<String?> redirectGuard(String path) async =>
      await isSignedIn() ? null : '/signin';
}

class AppRoutes {
  final auth = MockAuthentication();
  List<QRoute> routes() => [
        QRoute(
            path: '/',
            middleware: [auth],
            builder: () => HomeScreen(
                  onSignOut: auth.signOut,
                )),
        QRoute(
            path: '/books',
            middleware: [auth],
            builder: () => const BooksListScreen()),
        QRoute(
            path: '/signin',
            builder: () => SignInScreen(onSignedIn: auth.signIn)),
      ];
}

class BooksApp extends StatelessWidget {
  final routes = AppRoutes();

  BooksApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes.routes()));
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onSignOut;
  const HomeScreen({
    super.key,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => QR.to('/books'),
              child: const Text('View my bookshelf'),
            ),
            ElevatedButton(
              onPressed: onSignOut,
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignedIn;

  const SignInScreen({super.key, required this.onSignedIn});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'username (any)'),
              onChanged: (s) => _username = s,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'password (any)'),
              obscureText: true,
              onChanged: (s) => _password = s,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onSignedIn(Credentials(_username, _password));
                QR.navigator.replaceAll('/');
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}

class BooksListScreen extends StatelessWidget {
  const BooksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Stranger in a Strange Land'),
            subtitle: Text('Robert A. Heinlein'),
          ),
          ListTile(
            title: Text('Foundation'),
            subtitle: Text('Isaac Asimov'),
          ),
          ListTile(
            title: Text('Fahrenheit 451'),
            subtitle: Text('Ray Bradbury'),
          ),
        ],
      ),
    );
  }
}
