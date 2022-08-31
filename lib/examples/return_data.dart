import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: const QRouteInformationParser(),
        routerDelegate: QRouterDelegate(
          [
            QRoute(path: '/', builder: () => const IndexPage()),
            QRoute(path: '/select', builder: () => const SelectIndex()),
          ],
        ),
      );
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int? selectedIndex;
  @override
  void initState() {
    QR.params.ensureExist('SelectedIndex', keepAlive: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected index: $selectedIndex'),
            ElevatedButton(
              onPressed: () {
                QR.to('/select');
                QR.params.ensureExist(
                  'UpdateIndex',
                  keepAlive: true,
                  onChange: (oldValue, newValue) {
                    setState(() {
                      selectedIndex = newValue as int;
                    });
                  },
                );
              },
              child: const Text('Change Index'),
            )
          ],
        ),
      ),
    );
  }
}

class SelectIndex extends StatelessWidget {
  const SelectIndex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, i) => ListTile(
          title: Text(i.toString()),
          onTap: () {
            QR.params.updateParam('UpdateIndex', i);
            QR.back();
          },
        ),
      ),
    );
  }
}
