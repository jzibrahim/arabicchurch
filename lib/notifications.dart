import 'package:arabicchurch/model/content.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/services/data_service.dart';
import 'package:flutter/material.dart';

class Notifications extends Widget {
  DataService _dataService = new DataService();

  @override
  StatelessElement createElement() {
    var user = _dataService.userPreferences;
    Iterable<Group> groups = user.defaultGroups;
    if (groups.isEmpty) {
      groups = _dataService.churchData.groups;
    }

    var list = <Widget>[new ListTile(
        title: new Text(user.displayName,
            style: new TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20.0)),
        subtitle: new Text(
            'news from: ${groups.map((group) => group.name).join(", ")}'))
    ];

    for (Group group in groups) {
      for (Content content in group.content) {
        list.add(new ListTile(
            title: new Text(group.title,
                style: new TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 20.0)),
            subtitle: new Text(content.text)
        ));
      }
    }

    return new StatelessElement(
        new ListView(children: list));
  }
}