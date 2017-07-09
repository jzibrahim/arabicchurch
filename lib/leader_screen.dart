import 'package:flutter/material.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/group_details.dart';
import 'package:arabicchurch/model/content.dart';
import 'package:arabicchurch/services/data_service.dart';

class LeaderScreen extends Widget {
  @override
  StatelessElement createElement() {
    var user = new DataService().userPreferences;

    var list = <Widget>[new ListTile(
        title: new Text(user.displayName,
            style: new TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20.0)),
        subtitle: new Text(
            'Thanks for leading: ${user.leadGroups.map((group) => group.name)
                .join(', ')}'))
    ];

    for (Group group in user.leadGroups) {
      list.add(new Builder(builder: (BuildContext context) {
        return new ListTile(
            title: new Text(group.title,
                style: new TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 20.0)),
            subtitle: new Text(group.name),
            onTap: () {
              Navigator.of(context).push(
                  new GroupDetailsRoute(group)
              );
            }
        );
      }));
    }

    return new StatelessElement(
        new ListView(children: list));
  }
/*
  goToGroupDetails(BuildContext context, Group group) async {
    var textOverlay = await Navigator.push(
        context, new GroupDetailsRoute(group));
    if (textOverlay == null) return;
    / * var message = {
      'sender': {'name': account.displayName, 'imageUrl': account.photoUrl},
      'imageUrl': downloadUrl.toString(),
      'textOverlay': textOverlay,
    };
    _messagesReference.push().set(message);
    Navigator.of(context).push(new MaterialPageRoute<bool>(
        builder: (BuildContext context) {
          return new GroupDetails(group);
        }
    ));
  * /
  }*/
}