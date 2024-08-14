import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habbit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDark;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              // Optional: Add some opacity
              colorBlendMode: BlendMode.srcATop,
            ),
          ),
          // Switch for Dark Mode
          Center(
            child: ListTile(
              leading: Icon(
                isDarkMode ? CupertinoIcons.moon : CupertinoIcons.sun_max,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                isDarkMode ? 'Dark Mode' : 'Light Mode',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
