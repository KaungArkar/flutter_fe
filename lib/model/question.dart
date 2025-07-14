class Question {
  final int? id; // Make ID nullable
  final String? subQuestion; // Make subQuestion nullable if it can be null
  final String? answer1;
  final String? answer2;
  final String? answer3;
  final String? answer4;
  final String? correctAnswer; 
  Question({
    this.id,
    this.subQuestion,
    this.answer1,
    this.answer2,
    this.answer3,
    this.answer4,
    this.correctAnswer,
  });

Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sub_question': subQuestion,
      'answer_a': answer1,
      'answer_b': answer2,
      'answer_c': answer3,
      'answer_d': answer4,
      'correct_answer': correctAnswer,
    };
  }
    factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int?, // Use 'as int?' to allow null or cast to int
      subQuestion: map['sub_question'] as String?,
      answer1: map['answer_a'] as String?,
      answer2: map['answer_b'] as String?,
      answer3: map['answer_c'] as String?,
      answer4: map['answer_d'] as String?,
      correctAnswer: map['correct_answer']?.toString(), // no cast error
    );
  }

  get questionImage => null;


}