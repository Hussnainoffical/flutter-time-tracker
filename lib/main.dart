import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/time_entry_provider.dart';
import 'providers/project_provider.dart';
import 'providers/task_provider.dart';
import 'screens/debug_storage_screen.dart';
import 'screens/home_screen.dart';
import 'screens/project_screen.dart';
import 'screens/task_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      routes: {
        '/projects': (_) => ProjectScreen(),
        '/tasks': (_) => TaskScreen(),
        '/debug': (_) => DebugStorageScreen(),
      },
    );
  }
}
