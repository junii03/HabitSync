import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/my_drawer.dart';
import 'package:habbit_tracker/components/my_habit_tile.dart';
import 'package:habbit_tracker/components/my_heat_map.dart';
import 'package:habbit_tracker/database/habit_database.dart';
import 'package:habbit_tracker/models/habit.dart';
import 'package:habbit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  bool isSaveButtonEnabled = false;

  @override
  void initState() {
    // read existing habits on startup
    Provider.of<HabitDataBase>(context, listen: false).readHabit();
    textController.addListener(() {
      setState(() {
        isSaveButtonEnabled = textController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        centerTitle: true,
        title: Text('Habit Tracker',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: 'Add New Habit',
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: Stack(
        children: [
          isLandscape
              ? Center(
                  child: Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.1),
                      // Optional: Add some opacity
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                )
              : Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    // Optional: Add some opacity
                    colorBlendMode: BlendMode.srcATop,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                // Heat Map Heading
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Habit Heat Map',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ),

                // Heat Map
                _buildHeatMap(),

                // Habit List Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Your Habits',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ),

                // Habit List
                _buildHabitList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDataBase = context.watch<HabitDataBase>();
    List<Habit> currentHabits = habitDataBase.currentHabits;
    return FutureBuilder<DateTime?>(
        future: habitDataBase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHeatMap(
                startDate: snapshot.data!,
                datasets: prepHeatMapDataset(currentHabits));
          } else {
            return Container();
          }
        });
  }

  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDataBase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return List
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];
        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        // return habit tile
        return MyHabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }

  void createNewHabit() {
    // Ensure the text field is cleared and ready for new input
    textController.clear();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              'Create a New Habit',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500),
            ),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter habit name',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (text) {
                // Update the state of the dialog when the text changes
                setState(() {
                  // Rebuild the dialog to reflect changes in the save button state
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: textController.text.isNotEmpty
                    ? () {
                        // Get new habit name
                        String newHabitName = textController.text;
                        // Save to db
                        context.read<HabitDataBase>().addHabit(newHabitName);

                        // Pop box
                        Navigator.pop(context);

                        // Clear controller
                        textController.clear();
                      }
                    : null, // Disable the button if no text is entered
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: textController.text.isNotEmpty
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors
                            .grey, // Button text color based on enabled/disabled state
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Pop box and clear controller
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Confirm Habit Removal',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500),
        ),
        content: Text(
          'Do you really want to remove "${habit.name}" from your habits?',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // save to db
              context.read<HabitDataBase>().deleteHabit(habit.id);

              //pop box
              Navigator.pop(context);
            },
            child: Text('Yes, Remove',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
          TextButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);
            },
            child: Text('Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              'Edit Habit',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500),
            ),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Update habit name',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (text) {
                setState(() {}); // Rebuild dialog to update button state
              },
            ),
            actions: [
              TextButton(
                onPressed: textController.text.isNotEmpty
                    ? () {
                        String newHabitName = textController.text;
                        context
                            .read<HabitDataBase>()
                            .updateHabitName(habit.id, newHabitName);
                        Navigator.pop(context);
                        textController.clear();
                      }
                    : null,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: textController.text.isNotEmpty
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDataBase>().updateHabitCompletion(habit.id, value);
    }
  }
}
