class Content {
  static List<Content> createContent(List<dynamic> data) {
    var list = <Content>[];
    for (var value in data) {
      if (value == null) continue;

      list.add(new Content.fromDataSnapshot(value));
    }
    return list;
  }

  ContentType type;
  String text;

  Content(this.type, this.text);

  Content.fromDataSnapshot(Map<dynamic, dynamic> data) {
    type = data['contentType'] == ContentType.TEXT.toString()
        ? ContentType.TEXT
        : ContentType.IMAGE;
    text = data['text'];
  }

  Map<dynamic, dynamic> get toDataSnapshot {
    return {
      'contentType': type.toString(),
      'text': text
    };
  }

}

enum ContentType { TEXT, IMAGE }