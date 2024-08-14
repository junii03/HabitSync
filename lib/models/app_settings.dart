import 'package:isar/isar.dart';

// run cmd to generate file: run dart build_runner build
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunch;
}
