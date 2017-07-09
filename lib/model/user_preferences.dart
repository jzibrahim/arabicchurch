import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPreferences {
  String userName;
  String displayName;
  bool isAdmin = false;
  List<Group> defaultGroups = [];
  List<Group> leadGroups = [];

  UserPreferences.fromUser(User user)
      : userName = user.username,
        displayName = user.displayName;

  UserPreferences.fromDataSnapshot(this.displayName, DataSnapshot snapshot,
      List<Group> groups, this.leadGroups) {
    userName = snapshot.key;
    isAdmin = snapshot.value['admin'];

    if (snapshot.value['defaultGroups'] != null) {
      List<String> defaultGroupNames = snapshot.value['defaultGroups']?.split(
          ',');
      defaultGroups = defaultGroupNames.map((name) =>
          groups.firstWhere((group) => group.name == name)).toList();
    }
  }

  Map<String, dynamic> get toDataSnapshot {
    List<String> defaultGroupNames = defaultGroups.map((Group group) =>
    group.name).toList();
    return {
      'admin': isAdmin,
      'defaultGroups': defaultGroupNames
    };
  }

  @override
  String toString() => '$userName: $displayName, admin? ${isAdmin
      ? "true"
      : "false"}, defaultGroups: ${defaultGroups.map((group) => group.name)
      .join(',')}, leadGroups: ${leadGroups.map((group) => group.name)
      .join(',')}';
}