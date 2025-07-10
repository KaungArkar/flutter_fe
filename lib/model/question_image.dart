import 'dart:typed_data';

class QuestionImage {
  final int? id;
  final int questionId;
  final Uint8List questionImage;
  final int status;

  QuestionImage({
    this.id,
    required this.questionId,
    required this.questionImage,
    required this.status,
  });

  factory QuestionImage.fromMap(Map<String, dynamic> map) {
    return QuestionImage(
      id: map['id'] as int?,
      questionId: map['question_id'] as int,
      questionImage: map['question_image'] as Uint8List,
      status: map['status'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'question_image': questionImage,
      'status': status,
    };
  }
}
