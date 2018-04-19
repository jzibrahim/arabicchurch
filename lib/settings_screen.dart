import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/services/data_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _dataService = new DataService();
  final Map<String, bool> _values = {};

  @override
  Widget build(BuildContext context) {
    var user = _dataService.userPreferences;

    var list = <Widget>[
      new ListTile(
          title: new Text(user.displayName,
              style:
                  new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
          subtitle: new Text('Notifications'))
    ];

    for (Group group in _dataService.churchData.groups) {
      _values.putIfAbsent(group.name, () => user.defaultGroups.contains(group));
      list.add(new Builder(builder: (BuildContext context) {
        return new CheckboxListTile(
            title: new Text('${group.title} (${group.name})',
                style:
                    new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            value: _values[group.name],
            onChanged: (bool value) {
              setState(() {
                _values[group.name] = value;
                if (value) {
                  user.defaultGroups.add(group);
                } else {
                  user.defaultGroups.remove(group);
                }
                _dataService.saveDatabaseEntity(user);
              });
            });
      }));
    }

    return new ListView(children: list);
  }
}
