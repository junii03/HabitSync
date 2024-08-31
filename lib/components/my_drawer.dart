import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habbit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  DrawerHeader(
                      child: Image(
                    image: const AssetImage('assets/logo.png'),
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    colorBlendMode: BlendMode.srcATop,
                    fit: BoxFit.contain,
                  )),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'App Theme',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                            ),
                            DropdownButton<ThemeMode>(
                              isDense: true,
                              borderRadius: BorderRadius.circular(12),
                              value: themeProvider.themeMode,
                              isExpanded: true,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              items: [
                                DropdownMenuItem(
                                  value: ThemeMode.system,
                                  child: Text(
                                    'System Theme',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.dark,
                                  child: Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.light,
                                  child: Text(
                                    'Light Mode',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                ),
                              ],
                              onChanged: (ThemeMode? mode) {
                                if (mode != null) {
                                  themeProvider.setTheme(mode);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => SystemNavigator.pop(),
                    icon: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Exit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 17,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
