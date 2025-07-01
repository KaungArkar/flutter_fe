import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fequiz/model/question.dart';
import 'package:fequiz/database/database_helper.dart';
import 'package:fequiz/history.dart';

class QuizScreen extends StatefulWidget {
  final String month;
  final String year;

  const QuizScreen({required this.month, required this.year, super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int? _selectedOption;
  List<int?> _userAnswers = [];
  List<Question> _questions = [];
  final double circleDiameter = 70.0;
  final double contentPadding = 20.0;

  Timer? _timer;
  int _secondsElapsed = 0;
  final int _maxSeconds = 150 * 60;

  int _correctCount = 0;
  int _wrongCount = 0;
  int _skippedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  Future<void> _loadQuestions() async {
    final dbHelper = DatabaseHelper.instance;
    final fetchedQuestions =
        await dbHelper.getQuestions(widget.year, widget.month);
    setState(() {
      _questions = fetchedQuestions;
      _userAnswers = List.filled(_questions.length, null);
      _selectedOption = _userAnswers.isNotEmpty ? _userAnswers[0] : null;
    });
  }

  void _startTimer() {
    _secondsElapsed = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        if (_secondsElapsed >= _maxSeconds) {
          _processAnswerSummaryAndNavigate();
        }
      });
    });
  }

  void _processAnswerSummaryAndNavigate() {
    _userAnswers[_currentQuestionIndex] = _selectedOption;
    _calculateAnswerSummary();
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          correct: _correctCount,
          wrong: _wrongCount,
          skipped: _skippedCount,
          total: _questions.length,
        ),
      ),
    );
  }

  void _calculateAnswerSummary() {
    _correctCount = 0;
    _wrongCount = 0;
    _skippedCount = 0;

    for (int i = 0; i < _questions.length; i++) {
      final userAnswer = _userAnswers[i];
      final correctAnswer = _questions[i].correctAnswer;

      String? userAnswerChar;
      switch (userAnswer) {
        case 0:
          userAnswerChar = 'a';
          break;
        case 1:
          userAnswerChar = 'b';
          break;
        case 2:
          userAnswerChar = 'c';
          break;
        case 3:
          userAnswerChar = 'd';
          break;
        default:
          userAnswerChar = null;
      }

      if (userAnswer == null) {
        _skippedCount++;
      } else if (userAnswerChar == correctAnswer) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
    }

    print("✅ Correct: $_correctCount");
    print("❌ Wrong: $_wrongCount");
    print("⏭ Skipped: $_skippedCount");
  }

  void _goNext() {
    _userAnswers[_currentQuestionIndex] = _selectedOption;

    if (_currentQuestionIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = _userAnswers[_currentQuestionIndex];
      });
    } else {
      _processAnswerSummaryAndNavigate();
    }
  }

  void _goBack() {
    if (_currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentQuestionIndex--;
        _selectedOption = _userAnswers[_currentQuestionIndex];
      });
    }
  }

  String _formatTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topBlueHeight = screenHeight * 0.28;
    final questionCardTopOffset = topBlueHeight * 0.60;

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Stack(
        children: [
          // background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topBlueHeight,
            child: Container(color: Colors.blue),
          ),

          // header
          Positioned(
            top: 90,
            left: contentPadding,
            right: contentPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person,
                          size: 18, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                          "${_currentQuestionIndex + 1} / ${_questions.length}",
                          style: const TextStyle(
                              color: Colors.deepPurple, fontSize: 14)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                      "${_currentQuestionIndex + 1} / ${_questions.length}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          ),

          // question card
          Positioned(
            top: questionCardTopOffset,
            left: 0,
            right: 0,
            bottom: 16 + 55 + 16,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final question = _questions[index];
                final answerOptions = [
                  question.answer1 ?? 'Answer 1',
                  question.answer2 ?? 'Answer 2',
                  question.answer3 ?? 'Answer 3',
                  question.answer4 ?? 'Answer 4',
                ];

                return Padding(
                  padding: EdgeInsets.only(
                    top: circleDiameter / 2 + 8,
                    left: contentPadding,
                    right: contentPadding,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text("Hint",
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 15)),
                                ),
                                const SizedBox(width: 10),
                                Text("問題",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.grey.shade700)),
                                const SizedBox(width: 6),
                                Text("${index + 1}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              question.subQuestion ?? "",
                              style: const TextStyle(fontSize: 19),
                            ),
                            const SizedBox(height: 25),
                            ...List.generate(answerOptions.length,
                                (optionIndex) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _selectedOption == optionIndex
                                          ? Colors.orange
                                          : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: _selectedOption == optionIndex
                                        ? Colors.orange.shade50
                                        : Colors.white,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedOption = optionIndex;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            answerOptions[optionIndex],
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Radio<int>(
                                          value: optionIndex,
                                          groupValue: _selectedOption,
                                          onChanged: (int? val) {
                                            setState(() {
                                              _selectedOption = val;
                                            });
                                          },
                                          activeColor: Colors.orange,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // timer
          Positioned(
            top: questionCardTopOffset - circleDiameter / 2 + 35,
            left: MediaQuery.of(context).size.width / 2 - circleDiameter / 2,
            child: Container(
              width: circleDiameter,
              height: circleDiameter,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [Colors.deepPurple, Colors.orange, Colors.deepPurple],
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    _formatTimer(_secondsElapsed),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // buttons
          Positioned(
            left: contentPadding,
            right: contentPadding,
            bottom: 16,
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("戻る", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E38CC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentQuestionIndex == _questions.length - 1
                          ? "Finish"
                          : "次へ",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
