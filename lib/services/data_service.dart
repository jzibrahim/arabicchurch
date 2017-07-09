import 'dart:async';
import 'dart:core';
import 'package:arabicchurch/model/church_data.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/user.dart';
import 'package:arabicchurch/model/user_preferences.dart';
import 'package:arabicchurch/services/signin_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DataService {
  static DataService _cached;

  final Completer<UserPreferences> loadComplete = new Completer();

  final _groups = <Group>[];
  final _signInService = new SignInService();
  final _analytics = new FirebaseAnalytics();
  final dbRef = FirebaseDatabase.instance.reference();

  UserPreferences userPreferences;

  factory DataService() {
    _cached ??= new DataService._internal();
    return _cached;
  }

  DataService._internal();

  initialize() async {
    await _signInService.ensureLoggedIn();
    await _initDatabase();
  }

  ChurchData getChurchData() => new ChurchData(_groups);

  _initDatabase() async {
    await FirebaseAuth.instance.signInAnonymously();
    await _loadGroups();
  }

  _loadGroups() async {
    _getGroupDBRef().onValue.forEach((Event event) async {
      Map<String, dynamic> data = event.snapshot.value;
      for (String key in data.keys) {
        _groups.add(new Group.fromDataSnapshot(key, data[key]));
      }

      await _loadUser();
    });
  }

  _loadUser() async {
    var event = await _getUserDBRef(_signInService.user).once();
    if (event.value != null) {
      // User is in our database already.
      userPreferences = new UserPreferences.fromDataSnapshot(
          _signInService.user.displayName, event, _groups,
          _leadGroups(_groups, _signInService.user));
      loadComplete.complete(userPreferences);
    } else {
      // User is not in the database, so put them in the database.
      userPreferences = new UserPreferences.fromUser(_signInService.user);
      _getUserDBRef(_signInService.user)
          .set(userPreferences.toDataSnapshot)
          .then((_) {
        loadComplete.complete(userPreferences);
        _analytics.logEvent(
            name: 'new_user',
            parameters: {'username': _signInService.user.username});
      }).catchError(() {
        _analytics.logEvent(
            name: 'new_user_failed',
            parameters: {'username': _signInService.user.username});
        loadComplete.completeError(new Error());
      });
    }

    _analytics.setUserId(_signInService.user.username);
    return loadComplete;
  }

  DatabaseReference _getGroupDBRef() => dbRef.child('groups');

  DatabaseReference _getUserDBRef(User user) =>
      dbRef.child('users/${user.username}');

  List<Group> _leadGroups(List<Group> groups, User user) =>
      groups.where((Group group) => group.managers.contains(user.username))
          .toList();

/*


//var snapshot = (await groupsReference.onValue.first).snapshot;
    //ref.set({'test': 'testvalue'});
    //TODO
    //print('dataservice: ${snapshot.key}');
    /*DataSnapshot snapshot = await _signInReference.root().reference().child(
        '/groups/').once();
*/ /*
    //TODO
    print('dataservice: got groups');
    Map<String, DataSnapshot> data = snapshot.value;
    //TODO
    print('groupskey: ${snapshot.key}');
    print('groupsvalue: ${snapshot.value}');
    for (var key in data.keys) {
      groups.add(new Group.fromDataSnapshot(data[key]));
    }*/

    FirebaseAuth.instance.signInAnonymously().then((user) {
      _signInReference.onChildAdded.listen((Event event) {
        switch (event.snapshot.key) {
          case 'users':
            print('users:::: ${event.snapshot.value}');
            break;
          case 'groups':
            print('groups:::: ${event.snapshot.value}');
            break;

        }
//TODO
        print('key: ${event.snapshot.key}');
        print('value: ${event.snapshot.value}');
     */
}

