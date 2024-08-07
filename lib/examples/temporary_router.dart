import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class AppRoutes {
  static const taskRoute = QRoute(
    path: '/task/:id',
    builder: TaskPage.new,
    children: [
      QRoute(
        path: '/icon',
        builder: IconPickerPage.new,
      ),
    ],
  );
  static final routes = [
    const QRoute(
      path: '/home',
      builder: HomePage.new,
    ),
    taskRoute,
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerDelegate: QRouterDelegate(AppRoutes.routes, initPath: '/home'),
      routeInformationParser: const QRouteInformationParser(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final tasks = Database.tasks;
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Hero(
              tag: tasks[index].heroTag,
              child: Icon(tasks[index].icon),
            ),
            title: Text(tasks[index].title),
            onTap: () {
              _onTap(tasks[index].id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onTap(0);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTap(int id) async {
    if (MediaQuery.of(context).size.width > 600) {
      await showModalBottomSheet(
        context: context,
        builder: (_) => TemporaryQRouter(
          path: '/sheet',
          initPath: 'task/$id',
          routes: const [AppRoutes.taskRoute],
        ),
      );
    } else {
      await QR.to('/task/$id', waitForResult: true);
    }
    setState(() {});
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TextEditingController _controller;
  final taskId = QR.params['id']!.asInt ?? 0;

  bool get isEditing => taskId != 0;
  IconData? _selectedIcon;
  late int _heroTag;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final task = Database.tasks.firstWhere((element) => element.id == taskId);
      _controller = TextEditingController(text: task.title);
      _selectedIcon = task.icon;
      _heroTag = task.heroTag;
    } else {
      _controller = TextEditingController();
      _selectedIcon = Icons.work;
      _heroTag = UniqueKey().hashCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Icon: '),
                IconButton(
                  icon: Hero(tag: _heroTag, child: Icon(_selectedIcon)),
                  onPressed: () async {
                    final selectedIcon = await QR.to<IconData>(
                      '/task/$taskId/icon',
                      waitForResult: true,
                    );
                    if (selectedIcon != null) {
                      setState(() {
                        _selectedIcon = selectedIcon;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  Database.updateTask(
                    Task(
                      id: taskId,
                      title: _controller.text,
                      icon: _selectedIcon!,
                      heroTag: _heroTag,
                    ),
                  );
                } else {
                  Database.addTask(_controller.text, _selectedIcon!);
                }
                QR.back();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class IconPickerPage extends StatelessWidget {
  final List<IconData> icons = [
    Icons.work,
    Icons.home,
    Icons.school,
    Icons.shopping_cart,
    Icons.fitness_center,
    Icons.flight,
    Icons.directions_run,
    Icons.fastfood,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.local_pizza,
    Icons.local_grocery_store,
  ];

  IconPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick an Icon')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          return IconButton(
            icon: Icon(icons[index]),
            onPressed: () {
              QR.back(icons[index]);
            },
          );
        },
      ),
    );
  }
}

class Task {
  final int id;
  String title;
  IconData icon;
  final int heroTag;

  Task({
    required this.id,
    required this.title,
    required this.icon,
    required this.heroTag,
  });
}

class Database {
  static List<Task> tasks = [];

  static void addTask(String title, IconData icon) {
    tasks.add(Task(
      id: tasks.length + 1,
      title: title,
      icon: icon,
      heroTag: UniqueKey().hashCode,
    ));
  }

  static void updateTask(Task task) {
    final index = tasks.indexWhere((element) => element.id == task.id);
    tasks[index] = task;
  }

  static void deleteTask(int index) {
    tasks.removeAt(index);
  }
}
