import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  const MyHeatMap({super.key, required this.startDate, required this.datasets});

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Define colors based on theme
    final Map<int, Color> colorsets = {
      1: Colors.teal.shade100,
      2: Colors.teal.shade300,
      3: Colors.teal.shade500,
      4: Colors.teal.shade700,
      5: Colors.teal.shade900,
    };

    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: colorScheme.surface, // Matches the surface color from the theme
      textColor: textTheme.headlineLarge!.color, // Matches the text color from the theme
      fontSize: 15,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: colorsets,
    );
  }
}
