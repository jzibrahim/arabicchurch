import 'package:flutter/material.dart';
import 'package:arabicchurch/group_details.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/content.dart';
import 'package:arabicchurch/notifications.dart';

import 'package:arabicchurch/services/data_service.dart';

class AdminScreenRoute extends MaterialPageRoute<String> {
  AdminScreenRoute()
      : super(builder: (BuildContext context) {
          return new AdminScreen();
        });
}

class AdminScreen extends Widget {
  @override
  Widget build(BuildContext context) {
    return new AdminScreen();
  }

  @override
  StatelessElement createElement() {
    var user = new DataService().userPreferences;

    var list = <Widget>[
      new ListTile(
          title: new Text(user.displayName,
              style:
                  new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
          subtitle: new Text('Thanks for being an admin!'))
    ];

    for (Group group in user.leadGroups) {
      list.add(new Builder(
        // Create an inner BuildContext so that the onPressed methods
        // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return new ListTile(
              title: new Text(group.title,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20.0)),
              subtitle: new Text(
                  '${group.name} leaders: ${group.managers.join(', ')}'),
              onTap: () {
                Navigator.of(context).push(new GroupDetailsRoute(group));
              });
        },
      ));
    }

    return new StatelessElement(new ListView(children: list)
        //TODO: ADD FAB to create new groups.
        );
  }
}
