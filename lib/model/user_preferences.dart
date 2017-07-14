import 'package:arabicchurch/model/db_entity.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/user.dart';
import 'package:arabicchurch/services/data_service.dart';

class UserPreferences extends DBEntity {
  static const adminFieldName = 'admin';
  static const defaultGroupsFieldName = 'defaultGroups';
  static const leadGroupsFieldName = 'leadGroups';

  String tableName = DataService.usersTable;
  String userName;
  String displayName;
  bool isAdmin = false;
  List<Group> defaultGroups = [];
  List<Group> leadGroups = [];

  UserPreferences.fromUser(User user)
      : userName = user.username,
        displayName = user.displayName,
        super();

  UserPreferences.fromDataSnapshot(String key, Map<String, dynamic> snapshot) {
    userName = key;
    isAdmin = snapshot[adminFieldName];

    if (snapshot[defaultGroupsFieldName] != null) {
      List<String> defaultGroupNames = snapshot[defaultGroupsFieldName]?.split(
          ',');
      List<Group> groups = new DataService().churchData.groups;
      defaultGroups = defaultGroupNames.map((name) =>
          groups.firstWhere((group) => group.name == name)).toList();
      leadGroups = _leadGroups(groups);
    }
  }

  String get key => userName;

  Map<String, dynamic> get toDataSnapshot {
    List<String> defaultGroupNames = defaultGroups.map((Group group) =>
    group.name).toList();
    return {
      adminFieldName: isAdmin,
      defaultGroupsFieldName: defaultGroupNames
    };
  }

  List<Group> _leadGroups(List<Group> groups) =>
      groups.where((Group group) => group.managers.contains(userName))
          .toList();

  @override
  String toString() {
    return '''
$userName: $displayName,
$adminFieldName ? ${isAdmin ? "true" : "false"},
$defaultGroupsFieldName: ${defaultGroups.map((group) => group.name).join(
        ',')}, $leadGroupsFieldName: ${leadGroups.map((group) => group.name)
        .join(',')}''';
  }
}