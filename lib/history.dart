import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Column(
            children: [
              // This container will be clipped to create the curve
              Expanded(
                child: ClipPath(
                  clipper: ArcClipper(), // Our custom clipper for the curve
                  child: Container(color: const Color.fromARGB(255, 70, 43, 190)),
                ),
              ),
              Expanded(child: Container(color: const Color.fromARGB(255, 102, 116, 199))),
            ],
          ),
          // Foreground
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // ─────────── Trophy Card ───────────
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
                            const Text('おめでとう！',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('計算得点 +80 points',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 16),
                            // :new: Added divider and vertical lines
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const _StatItem(
                                        icon: Icons.help_outline,
                                        label: '中止',
                                        count: '10'),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.black12,
                                      margin: const EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    const _StatItem(
                                        icon: Icons.check_circle,
                                        label: '正解',
                                        count: '08'),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.black12,
                                      margin: const EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    const _StatItem(
                                        icon: Icons.cancel,
                                        label: '警告',
                                        count: '02'),
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
              // ─────────── History List Card ───────────
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
                            children: const [
                              HistoryItem(
                                  rank: '1st',
                                  name: '読解',
                                  avatarAsset: 'assets/images/pf1.png',
                                  score: '80%',
                                  coin: 50,
                                  crowned: true),
                              HistoryItem(
                                  rank: '2nd',
                                  name: '潮解',
                                  avatarAsset: 'assets/images/pf2.png',
                                  score: '80%',
                                  coin: 60),
                              HistoryItem(
                                  rank: '3rd',
                                  name: '潮解',
                                  avatarAsset: 'assets/images/pf3.png',
                                  score: '70%',
                                  coin: 60),
                              HistoryItem(
                                  rank: '4th',
                                  name: '潮解',
                                  avatarAsset: 'assets/images/pf4.png',
                                  score: '60%',
                                  coin: 60),
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

/* ───────── Custom Clipper for the Arc ───────── */
class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start at bottom-left, go up
    // Quadratic Bezier curve to create the arc
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0); // Line to top-right
    path.close(); // Close the path to form the shape
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // Only clip once
  }
}

/* ───────── Stat Item Widget ───────── */
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

/* ───────── History Item Widget ───────── */
class HistoryItem extends StatelessWidget {
  const HistoryItem(
      {required this.rank,
      required this.name,
      required this.avatarAsset,
      required this.score,
      required this.coin,
      this.crowned = false,
      super.key});
  final String rank, name, avatarAsset, score;
  final int coin;
  final bool crowned;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1)))),
        child: Row(children: [
          SizedBox(
              width: 40,
              child: Text(rank,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Stack(alignment: Alignment.topRight, children: [
            CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: AssetImage(avatarAsset)),
            if (crowned)
              const Positioned(
                  top: -2,
                  right: -2,
                  child:
                      Icon(Icons.emoji_events, size: 20, color: Colors.amber))
          ]),
          const SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Row(children: [
                const Text('Won', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 4),
                const Icon(Icons.monetization_on,
                    size: 16, color: Colors.amber),
                Text(' $coin', style: const TextStyle(color: Colors.grey))
              ])
            ]),
          ),
          Text(score,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF6C4DF2)))
        ]),
      );
}