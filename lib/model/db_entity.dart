import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/user_preferences.dart';
import 'package:arabicchurch/services/data_service.dart';

class DBEntity {
  String tableName;

  DBEntity();

  DBEntity.fromDataSnapshot(String key, Map<String, dynamic> data);

  factory DBEntity.fromSnapshot(String table, String key,
      Map<String, dynamic> data) {
    switch (table) {
      case DataService.usersTable:
        return new UserPreferences.fromDataSnapshot(key, data);
      case DataService.groupsTable:
        return new Group.fromDataSnapshot(key, data);
    }

    return null;
  }

  String get key => '';

  Map<String, dynamic> get toDataSnapshot => null;
}