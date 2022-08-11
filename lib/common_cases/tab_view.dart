import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(
        [MobileRoutes().route],
        initPath: '/mobile',
      ),
    );
  }
}

class MobileView extends StatefulWidget {
  final QRouter router;
  const MobileView(this.router, {Key? key}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: MobileRoutes.tabs.length,
      vsync: this,
    );

    // Add listener to update the selected tab when the route changes from outside of this widget.
    final navigator = widget.router.navigator;
    navigator.addListener(() {
      _tabController.animateTo(
        MobileRoutes.tabs.indexOf(navigator.currentRoute.name!),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          onTap: (value) {
            QR.toName(MobileRoutes.tabs[value]);
          },
          tabs: MobileRoutes.tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: widget.router,
    );
  }
}

class MobileRoutes {
  static const tabs = [
    'Stores',
    'Products',
    'Settings',
  ];

  final route = QRoute.withChild(
    path: '/mobile',
    initRoute: '/stores',
    builderChild: (router) => MobileView(router),
    children: [
      QRoute(
        path: '/stores',
        name: tabs[0],
        pageType: const QFadePage(),
        builder: () => const TabWidget(0),
      ),
      QRoute(
        path: '/products',
        name: tabs[1],
        pageType: const QFadePage(),
        builder: () => const TabWidget(1),
      ),
      QRoute(
        path: '/settings',
        name: tabs[2],
        pageType: const QSlidePage(),
        builder: () => const TabWidget(2),
      ),
    ],
  );
}

class TabWidget extends StatelessWidget {
  final int index;
  const TabWidget(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tab ${index + 1}',
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 16),
        Text(
          MobileRoutes.tabs[index],
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }
}
