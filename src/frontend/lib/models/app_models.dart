class Question {
  final String id;
  final String content;
  final List<String> options;
  final int answerIndex;
  final String explanation;
  final String subject;
  final String year;

  Question({
    required this.id,
    required this.content,
    required this.options,
    required this.answerIndex,
    required this.explanation,
    required this.subject,
    this.year = '',
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      content: json['content'] as String,
      options: List<String>.from(json['options']),
      answerIndex: json['answerIndex'] as int,
      explanation: json['explanation'] as String,
      subject: json['subject'] as String,
      year: json['year'] as String? ?? '',
    );
  }
}

class School {
  final String id;
  final String name;
  final String location;
  final String type;
  final int score;
  final List<String> majorCategories;
  final String website;
  final String description;

  School({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.score,
    required this.majorCategories,
    this.website = '',
    this.description = '',
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      type: json['type'] as String,
      score: json['score'] as int,
      majorCategories: List<String>.from(json['majorCategories']),
      website: json['website'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class Comment {
  final String id;
  final String author;
  final String time;
  final String content;

  Comment({
    required this.id,
    required this.author,
    required this.time,
    required this.content,
  });
}

class Post {
  final String id;
  final String author;
  final String time;
  final String content;
  int likes;
  bool isLiked;
  final List<Comment> comments;

  int get commentsCount => comments.length;

  Post({
    required this.id,
    required this.author,
    required this.time,
    required this.content,
    this.likes = 0,
    this.isLiked = false,
    List<Comment>? comments,
  }) : comments = comments ?? [];
}
