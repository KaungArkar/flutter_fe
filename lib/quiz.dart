import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String examTitle;

  const QuizScreen({required this.examTitle, super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int? _selectedOption;
  List<int?> _userAnswers = [];

  final List<Map<String, dynamic>> _questions = List.generate(10, (index) {
    return {
      "questionText": "Question number ${index + 1}: What is the answer?",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correctAnswerIndex": index % 4,
    };
  });

  @override
  void initState() {
    super.initState();
    _userAnswers = List.filled(_questions.length, null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an option before proceeding!")),
      );
      return;
    }

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
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    int correctCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i]['correctAnswerIndex']) {
        correctCount++;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Results"),
        content: Text("You answered $correctCount out of ${_questions.length} questions correctly for the ${widget.examTitle} quiz!"),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topBlueHeight = screenHeight * 0.28;
    final circleDiameter = 70.0;
    final contentPadding = 20.0;
    final verticalSpacing = 15.0;

    final double questionCardTopOffset = topBlueHeight * 0.60;
    final double availableWidth = screenWidth - 2 * contentPadding;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topBlueHeight,
            child: Container(color: Colors.blue),
          ),
          Positioned(
            top: 16,
            left: contentPadding,
            right: contentPadding,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        const Text("7 / 40", style: TextStyle(color: Colors.deepPurple, fontSize: 14)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text("${_currentQuestionIndex + 1} / ${_questions.length}",
                        style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: questionCardTopOffset,
            left: 0,
            right: 0,
            bottom: 16 + 55 + 16,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _questions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentQuestionIndex = index;
                      _selectedOption = _userAnswers[_currentQuestionIndex];
                    });
                  },
                  itemBuilder: (context, index) {
                    final currentQuestion = _questions[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        top: circleDiameter / 2 + 8,
                        left: contentPadding,
                        right: contentPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text("Hint", style: TextStyle(color: Colors.orange, fontSize: 15)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text("問題", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey.shade700)),
                                      const SizedBox(width: 6),
                                      Text("${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Text(currentQuestion["questionText"], style: const TextStyle(fontSize: 19)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: currentQuestion["options"].length,
                              itemBuilder: (context, optionIndex) {
                                return SizedBox(
                                  width: availableWidth,
                                  child: Card(
                                    elevation: 3,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: _selectedOption == optionIndex ? Colors.orange : Colors.deepPurple.shade100,
                                        width: 1.5,
                                      ),
                                    ),
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: RadioListTile<int>(
                                      title: Text(currentQuestion["options"][optionIndex], style: const TextStyle(fontSize: 17)),
                                      value: optionIndex,
                                      groupValue: _selectedOption,
                                      onChanged: (int? val) {
                                        setState(() {
                                          _selectedOption = val;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      controlAffinity: ListTileControlAffinity.trailing,
                                      activeColor: Colors.orange,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: circleDiameter,
                    height: circleDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [Colors.deepPurple, Colors.orange, Colors.deepPurple],
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "20",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: contentPadding,
            right: contentPadding,
            bottom: 16,
            child: SizedBox(
              height: 55,
              width: availableWidth,
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
                  _currentQuestionIndex == _questions.length - 1 ? "Finish" : "次へ",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
