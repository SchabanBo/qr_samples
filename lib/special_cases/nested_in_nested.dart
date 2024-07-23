import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final routes = [
      QRoute(path: '/', builder: () => const WelcomePage()),
      QRoute.withChild(
        path: 'nested-1',
        builderChild: (r) => Nested1(r),
        children: [
          QRoute(path: '/', builder: () => const WelcomePage()),
          QRoute(path: '/1', builder: () => const WelcomePage(index: 1)),
          QRoute(path: '/2', builder: () => const WelcomePage(index: 2)),
          QRoute.withChild(
            path: 'nested-2',
            builderChild: (r) => Nested2(r),
            children: [
              QRoute(path: '/', builder: () => const WelcomePage()),
              QRoute(path: '/3', builder: () => const WelcomePage(index: 3)),
              QRoute(path: '/4', builder: () => const WelcomePage(index: 4)),
            ],
          ),
        ],
      )
    ];

    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final int? index;
  const WelcomePage({super.key, this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(child: Text(index == null ? 'welcome' : index.toString())),
      ),
      floatingActionButton: QR.currentPath == '/'
          ? TextButton(
              child: const Text('Go to nested-1'),
              onPressed: () => QR.to('/nested-1'),
            )
          : TextButton(
              child: const Text('Go to Home'),
              onPressed: () => QR.to('/'),
            ),
    );
  }
}

class Nested1 extends StatelessWidget {
  final QRouter router;
  const Nested1(this.router, {super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () => QR.to('nested-1/1'),
                child: const Text('Go to 1')),
            TextButton(
                onPressed: () => QR.to('nested-1/2'),
                child: const Text('Go to 2')),
            TextButton(
                onPressed: () => QR.to('nested-1/nested-2'),
                child: const Text('Go to nested-2')),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.amber)),
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

class Nested2 extends StatelessWidget {
  final QRouter router;
  const Nested2(this.router, {super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () => QR.to('nested-1/nested-2/3'),
                child: const Text('Go to 3')),
            TextButton(
                onPressed: () => QR.to('nested-1/nested-2/4'),
                child: const Text('Go to 4')),
            SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.5,
              child: router,
            )
          ],
        ),
      ),
    );
  }
}
