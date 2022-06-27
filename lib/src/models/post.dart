class Post {
  String id;
  String content;
  String date;
  String teacherId;

  Post({this.id, this.content, this.date, this.teacherId});

  toMap() {
    return {'id': id, 'content': content, 'date': date, 'teacherId': teacherId};
  }
}
