import 'dart:typed_data';

class Question {
  final int? id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String examType; // e.g., "October 2024"
  final Uint8List? image; // Optional image for the question

  Question({
    this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.examType,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options.join(';'), // Simple way to store list as string
      'correctAnswerIndex': correctAnswerIndex,
      'examType': examType,
      'image': image,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int?,
      text: map['text'] as String,
      options: (map['options'] as String).split(';'), // Split string back to list
      correctAnswerIndex: map['correctAnswerIndex'] as int,
      examType: map['examType'] as String,
      image: map['image'] as Uint8List?,
    );
  }

  @override
  String toString() {
    return 'Question(id: $id, text: $text, options: $options, correctAnswerIndex: $correctAnswerIndex, examType: $examType)';
  }
}