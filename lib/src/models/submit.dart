class Submit {
  String id;
  String stdId;
  String mark;
  String note;
  String file;
  String homeworkId;

  Submit(
      {this.stdId, this.mark, this.note, this.file, this.homeworkId, this.id});

  toMap() {
    return {
      'id': id,
      'stdId': stdId,
      'mark': mark,
      'note': note,
      'file': file,
      'homeworkId': homeworkId
    };
  }
}
