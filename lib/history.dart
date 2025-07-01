import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final int correct;
  final int wrong;
  final int skipped;
  final int total;

  const HistoryScreen({
    super.key,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = total == 0 ? 0 : (correct / total) * 100;
    final String percentage = percent.toStringAsFixed(1); // e.g., 83.3%

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Column(
            children: [
              Expanded(
                child: ClipPath(
                  clipper: ArcClipper(),
                  child:
                      Container(color: const Color.fromARGB(255, 70, 43, 190)),
                ),
              ),
              Expanded(
                child:
                    Container(color: const Color.fromARGB(255, 102, 116, 199)),
              ),
            ],
          ),
          // Foreground
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        width: 360,
                        padding: const EdgeInsets.only(top: 50, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'おめでとう！',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '計算得点 $percentage%',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _StatItem(
                                        icon: Icons.help_outline,
                                        label: '中止',
                                        count: skipped.toString()),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.black12,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                    _StatItem(
                                        icon: Icons.check_circle,
                                        label: '正解',
                                        count: correct.toString()),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.black12,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                    _StatItem(
                                        icon: Icons.cancel,
                                        label: '警告',
                                        count: wrong.toString()),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Image.asset('assets/images/trophy.png',
                          height: 80, width: 80),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('年月日',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text('試験タイプ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('計算得点',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Column(
                            children: [
                              HistoryItem(
                                rank: '1st',
                                name: '読解',
                                avatarAsset: 'assets/images/pf1.png',
                                score: '$percentage%',
                                coin: 50,
                                crowned: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _StatItem extends StatelessWidget {
  const _StatItem(
      {required this.icon, required this.label, required this.count});
  final IconData icon;
  final String label;
  final String count;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF6C4DF2), size: 24),
              const SizedBox(width: 6),
              Text(count,
                  style: const TextStyle(
                      color: Color(0xFF6C4DF2),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: const Color(0xFF6C4DF2).withOpacity(.7),
                  fontSize: 14)),
        ],
      );
}

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    required this.rank,
    required this.name,
    required this.avatarAsset,
    required this.score,
    required this.coin,
    this.crowned = false,
    super.key,
  });

  final String rank, name, avatarAsset, score;
  final int coin;
  final bool crowned;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(rank,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Stack(
              alignment: Alignment.topRight,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: AssetImage(avatarAsset),
                ),
                if (crowned)
                  const Positioned(
                    top: -2,
                    right: -2,
                    child:
                        Icon(Icons.emoji_events, size: 20, color: Colors.amber),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      const Text('Won', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 4),
                      const Icon(Icons.monetization_on,
                          size: 16, color: Colors.amber),
                      Text(' $coin',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Text(score,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF6C4DF2))),
          ],
        ),
      );
}
