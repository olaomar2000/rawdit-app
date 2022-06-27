
class Homework {
  String id;
  String title;
  String description;
  String endDate;
  String fileUrl;

  String teacherId;

  Homework(
      {this.id,
      this.title,
      this.description,
      this.endDate,
      this.fileUrl,
      this.teacherId});

  toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'endDate': endDate,
      'fileUrl': fileUrl,
      'teacherId': teacherId
    };
  }
}
