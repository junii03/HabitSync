import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final void Function(bool?)? onChanged;
  final String text;
  final bool isCompleted;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    this.onChanged,
    this.editHabit,
    this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final textColor = theme.textTheme.bodyMedium!.color;
    final completedTextColor = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // Edit option
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: secondaryColor,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
            // Delete option
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.redAccent,
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(

              gradient: LinearGradient(
                colors: isCompleted
                    ? [
                        primaryColor.withOpacity(0.9),
                        primaryColor.withOpacity(0.2)
                      ] // Slightly more opaque for better readability
                    : [
                        secondaryColor.withOpacity(0.2),
                        primaryColor.withOpacity(0.5)
                      ], // More distinct color range
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: Row(
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: onChanged,
                  activeColor: primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isCompleted ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? completedTextColor : textColor,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
