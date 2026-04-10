import '../models/app_models.dart';

class MockData {
  static List<School> get schools => [
    School(
      name: '深圳职业技术大学',
      shortName: '深职大',
      type: '公办',
      location: '南山区',
      rating: 4.9,
      logoUrl: '',
    ),
    School(
      name: '广州番禺职业技术学院',
      shortName: '番职院',
      type: '公办',
      location: '番禺区',
      rating: 4.8,
      logoUrl: '',
    ),
    School(
      name: '广东轻工职业技术大学',
      shortName: '广轻工',
      type: '公办',
      location: '海珠区',
      rating: 4.7,
      logoUrl: '',
    ),
    School(
      name: '顺德职业技术学院',
      shortName: '顺职院',
      type: '公办',
      location: '顺德区',
      rating: 4.6,
      logoUrl: '',
    ),
  ];

  static List<QuestionSubject> get subjects => [
    QuestionSubject(title: '语文', icon: '📚', count: '50套真题', colorHex: 'EF5350'),
    QuestionSubject(title: '数学', icon: '📐', count: '48套真题', colorHex: '42A5F5'),
    QuestionSubject(title: '英语', icon: '🔤', count: '52套真题', colorHex: 'FFA726'),
  ];
}
