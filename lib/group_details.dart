import 'package:flutter/material.dart';
import 'package:arabicchurch/model/group.dart';
import 'package:arabicchurch/model/content.dart';
import 'package:arabicchurch/services/data_service.dart';

class GroupDetailsRoute extends MaterialPageRoute<String> {
  GroupDetailsRoute(Group group) : super(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return new GroupDetails(group);
      });
}

class GroupDetails extends StatefulWidget {
  final Group group;

  GroupDetails(this.group);

  @override
  State<StatefulWidget> createState() => new GroupDetailsState(group);
}

class GroupDetailsState extends State<GroupDetails> {
  Group _group;
  List<TextEditingController> _controllers = [];


  GroupDetailsState(this._group);

  @override
  void initState() {
    super.initState();
  }

  ListTile _createTextbox(Content content, int index) {
    _controllers.add(
        new TextEditingController(text: _group.content[index].text));
    return new ListTile(
        title: new TextField(
            controller: _controllers[index],
            onChanged: (String text) {
              setState(() {
                _group.content[index].text = _controllers[index].text;
              });
            }),
        trailing: new IconButton(
          icon: new Icon(Icons.delete),
          tooltip: 'Delete',
          onPressed: () {
            setState(() {
              _group.content.removeAt(index);
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < _group.content.length; i++) {
      list.add(_createTextbox(_group.content.elementAt(i), i));
    }

    return new Scaffold (appBar: new AppBar(
      // Here we take the value from the MyHomePage object that
      // was created by the App.build method, and use it to set
      // our appbar title.
        title: new Text(_group.title)), body:
    new Builder(
      // Create an inner BuildContext so that the onPressed methods
      // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return new ListView(shrinkWrap: true, children: list);
        }
    ), floatingActionButton: new FloatingActionButton(
        tooltip: 'Add',
        child: new Icon(Icons.add),
        onPressed: () {
          setState(() {
            _group.content.add(new Content(ContentType.TEXT, ''));
          });
        }));
  }
}