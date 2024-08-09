class Task {
  String id;
  String title;

  bool isMonday;
  bool isTuesday;
  bool isWednesday;
  bool isThursday;
  bool isFriday;
  bool isSaturday;
  bool isSunday;

  bool isMondeyDone;
  bool isTuesdayDone;
  bool isWednesdayDone;
  bool isThursdayDone;
  bool isFridayDone;
  bool isSaturdayDone;
  bool isSundayDone;

  bool isInbox;
  bool isNotice;
  int noticeHour;
  int noticeMinutes;

  int index;

  Task(
    this.id,
    this.title,
    this.isMonday,
    this.isTuesday,
    this.isWednesday,
    this.isThursday,
    this.isFriday,
    this.isSaturday,
    this.isSunday,
    this.isMondeyDone,
    this.isTuesdayDone,
    this.isWednesdayDone,
    this.isThursdayDone,
    this.isFridayDone,
    this.isSaturdayDone,
    this.isSundayDone,
    this.isInbox,
    this.isNotice,
    this.noticeHour,
    this.noticeMinutes,
    this.index,
  );
}
