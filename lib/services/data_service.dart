library services.data_service;

import 'dart:async';
import 'dart:core';

import 'package:arabicchurch/model/church_data.dart';
import 'package:arabicchurch/model/db_entity.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/user.dart';
import 'package:arabicchurch/model/user_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'signin_service.dart';

class DataService {
  static const groupsTable = 'groups';
  static const usersTable = 'users';

  static DataService _cached;

  final Completer<UserPreferences> loadComplete = new Completer();

  final _groups = <Group>[];
  final _signInService = new SignInService();
  final _analytics = new FirebaseAnalytics();
  final _dbRef = FirebaseDatabase.instance.reference();

  UserPreferences userPreferences = new UserPreferences.fromUser(new User());

  factory DataService() {
    _cached ??= new DataService._internal();
    return _cached;
  }

  DataService._internal();

  initialize() async {
    await _signInService._ensureLoggedIn();
    await _initDatabase();
  }

  ChurchData get churchData => new ChurchData(_groups);

  User get user => _signInService.user;

  bool get loggedIn => _signInService.loggedIn;

  Future<User> signIn() async {
    await _signInService._ensureLoggedIn();
    await _loadUser();
    return _signInService.user;
  }

  signOut() async {
    await _signInService._signOut();
    await _loadUser();
  }

  _initDatabase() async {
    _signInService._ensureLoggedIn();
    await _loadGroups();
    await _loadUser();
  }

  _loadGroups() async {
    await getDBReference(groupsTable).onValue.forEach((Event event) async {
      Map<dynamic, dynamic> data = event.snapshot.value;
      data.keys.forEach((key) =>
          _groups.add(new Group.fromDataSnapshot(key.toString(), data[key])));
    });
  }

  _loadUser() async {
    DBEntity userDBEntry =
        await loadDatabaseEntity(usersTable, _signInService.user.username);
    if (userDBEntry is UserPreferences) {
      // User is in our database already.
      userPreferences = (userDBEntry as UserPreferences)
        ..displayName = _signInService.user.displayName;

      if (!loadComplete.isCompleted) {
        loadComplete.complete(userPreferences);
      }
    } else {
      // User is not in the database, so put them in the database.
      userPreferences = new UserPreferences.fromUser(_signInService.user);
      saveDatabaseEntity(userPreferences).then((succesful) {
        // User was added successfully to the database.
        if (succesful == true) {
          loadComplete.complete(userPreferences);
          _analytics.logEvent(
              name: 'new_user',
              parameters: {'username': _signInService.user.username});
        } else {
          // User was not added successfully to the database.
          _analytics.logEvent(
              name: 'new_user_failed',
              parameters: {'username': _signInService.user.username});
          loadComplete.completeError(new Error());
        }
      });
    }

    _analytics.setUserId(_signInService.user.username);
    return loadComplete;
  }

  DatabaseReference getDBReference(String tableName, {String key}) {
    if (key == null) {
      return _dbRef.child(tableName);
    }

    return _dbRef.child('$tableName/$key');
  }

  Future<DBEntity> loadDatabaseEntity(String tableName, String key) async {
    var event = await _dbRef.child('$tableName/$key').once();
    if (event.value != null) {
      // Entity is in our database already.
      return new DBEntity.fromSnapshot(tableName, key, event.value);
    }

    return null;
  }

  Future<bool> saveDatabaseEntity(DBEntity entity) {
    return _dbRef
        .child('${entity.tableName}/${entity.key}')
        .set(entity.toDataSnapshot)
        .then((_) {
      return new Future.value(true);
    }).catchError((error) {
      print('error $error');
      return new Future.value(false);
    });
  }
}
