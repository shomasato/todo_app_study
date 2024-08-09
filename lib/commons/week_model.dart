class Week {
  final String title;
  final String id;

  Week({
    required this.title,
    required this.id,
  });
}

List<Week> weeks = [
  Week(title: 'M', id: 'monday'),
  Week(title: 'T', id: 'tuesday'),
  Week(title: 'W', id: 'wednesday'),
  Week(title: 'T', id: 'thursday'),
  Week(title: 'F', id: 'friday'),
  Week(title: 'S', id: 'saturday'),
  Week(title: 'S', id: 'sunday'),
];
