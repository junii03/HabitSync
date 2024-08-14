import 'package:flutter/material.dart';
import 'package:habbit_tracker/models/app_settings.dart';
import 'package:habbit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDataBase extends ChangeNotifier {
  static late Isar isar;

/*

      S E T U P

*/

// I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

// Save first date of app start-up (for heat-map)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunch = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

// get first date of app start-up (for heat-map)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunch;
  }

/*

      C R U D - O P E R A T I O N S

*/

// List of habits
  final List<Habit> currentHabits = [];

// C R E A T E - add a new habit
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read habits from db
    readHabit();
  }

// R E A D - read saved habits from db
  Future<void> readHabit() async {
    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to current habit list
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();
  }

// U P D A T E - check habit on/off
  Future<void> updateHabitCompletion(int id, bool isComplete) async {
    // find specific habit
    final habit = await isar.habits.get(id);

    // update status
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        final todayDateOnly = DateTime(today.year, today.month, today.day);

        if (isComplete) {
          // Add today's date to completedDays if not already present
          if (!habit.completedDays.contains(todayDateOnly)) {
            habit.completedDays.add(todayDateOnly);
          }
        } else {
          // Remove today's date from completedDays if present
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }

        // Save the updated habit to the database
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabit();
  }

// U P D A T E - change name of habit
  Future<void> updateHabitName(int id, String newName) async {
    // find specific habit
    final habit = await isar.habits.get(id);

    // update the habit name
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        // Save the updated habit to the database
        await isar.habits.put(habit);
      });

      // re-read from db
      readHabit();
    }
  }

// D E L E T E - delete habit from db
  Future<void> deleteHabit(int id) async {
    // perform delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    // re-read from db
    readHabit();
  }
}
