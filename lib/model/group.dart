import 'package:arabicchurch/model/content.dart';

class Group {
  String name;
  String title;
  List<Content> content;
  List<String> managers;

  Group(this.name, this.title, this.content, this.managers);

  Group.fromDataSnapshot(this.name, Map<String, dynamic> data) {
    title = data['title'];
    managers = data['managers']?.split(',');
    content = Content.createContent(data['content']);
  }

  @override
  String toString() =>
      'group $name, title $title, content: $content, manager: $managers';
}