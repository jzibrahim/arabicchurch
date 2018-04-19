import 'package:flutter/material.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/content.dart';
import 'package:arabicchurch/services/data_service.dart';

class ContentDetails extends Widget {
  //BuildContext context;
  Content content;

  //ContentDetails(this.context);

  @override
  StatelessElement createElement() {
    var list = <Widget>[new ListTile(
        title: new Text(content.text,
            style: new TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20.0)))
    ];

    list.add(new ListTile(
        title: new Text(content.text,
            style: new TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20.0))
      //TODO onTap: () =>
    ));


    return new StatelessElement(
        new ListView(children: list));
  }
}