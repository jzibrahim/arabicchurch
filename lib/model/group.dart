import 'package:arabicchurch/model/content.dart';
import 'package:arabicchurch/model/db_entity.dart';
import 'package:arabicchurch/services/data_service.dart';

class Group implements DBEntity {
  String tableName = DataService.groupsTable;
  String name;
  String title;
  List<Content> content;
  List<String> managers;

  Group(this.name, this.title, this.content, this.managers);

  Group.fromDataSnapshot(this.name, Map<dynamic, dynamic> data) {
    title = data['title'];
    managers = data['managers']?.split(',');
    content = Content.createContent(data['content']);
  }

  String get key => name;

  Map<dynamic, dynamic> get toDataSnapshot {
    return {
      'title': title,
      'managers': managers.join(','),
      'content': content.map((Content content) => content.toDataSnapshot)
          .toList()
    };
  }

  @override
  String toString() =>
      'group $name, title $title, content: $content, manager: $managers';
}