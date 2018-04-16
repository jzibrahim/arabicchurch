import 'package:arabicchurch/group_details.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/services/data_service.dart';
import 'package:flutter/material.dart';

class LeaderScreenRoute extends MaterialPageRoute<String> {
  LeaderScreenRoute()
      : super(
            builder: (BuildContext context) =>
                new Card(child: new LeaderScreen()));
}

class LeaderScreen extends Widget {
  final _dataService = new DataService();

  @override
  StatelessElement createElement() {
    var user = _dataService.userPreferences;

    var list = <Widget>[
      new ListTile(
          title: new Text(user.displayName,
              style:
                  new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
          subtitle: new Text(
              'Thanks for leading: ${user.leadGroups.map((group) => group.name)
                .join(', ')}'))
    ];

    for (Group group in user.leadGroups) {
      list.add(new Builder(builder: (BuildContext context) {
        return new ListTile(
            title: new Text(group.title,
                style:
                    new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            subtitle: new Text(group.name),
            onTap: () {
              Navigator
                  .of(context)
                  .push(new GroupDetailsRoute(group))
                  .then((_) {
                _dataService.saveDatabaseEntity(user.leadGroups
                    .firstWhere((Group grp) => grp.name == group.name));
              });
            });
      }));
    }

    return new StatelessElement(new ListView(children: list));
  }
}
