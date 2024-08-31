import 'package:flutter/material.dart';
import 'package:habbit_tracker/database/habit_database.dart';
import 'package:habbit_tracker/pages/home_page.dart';
import 'package:habbit_tracker/theme/dark_theme.dart';
import 'package:habbit_tracker/theme/light_theme.dart';
import 'package:habbit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize database
  await HabitDataBase.initialize();
  await HabitDataBase().saveFirstLaunchDate();
  runApp(MultiProvider(
    providers: [
      // Theme Provider
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      // Habit Provider
      ChangeNotifierProvider(create: (context) => HabitDataBase()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeProvider.themeMode,
    );
  }
}
