class Attendance {
  String id;
  String stdId;
  bool singout;
  String date;

  Attendance({
    this.id,
    this.stdId,
    this.singout,
    this.date,
  });

  toMap() {
    return {
      'id':id,
      'stdId': stdId,
      'singout': singout,
      'date': date,
    };
  }
}
