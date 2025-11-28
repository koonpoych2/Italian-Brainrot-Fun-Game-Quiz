import 'dart:ffi';
import 'package:audioplayers/audioplayers.dart';
import 'package:brainrot_quiz/components/text_show.dart';
import 'package:brainrot_quiz/home_screen.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  final String correctAnswer;
  final String correctAnswerType;
  final int score;
  final int maxScore;

  const ResultScreen({
    super.key,
    required this.correctAnswer,
    required this.score,
    required this.correctAnswerType,
    required this.maxScore,
  });
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    // เริ่มครั้งแรกที่หน้าเปิด ต่อให้เรียก setState() ก็จะไม่ทำฟังก์ชั่นนี้จะทำแค่ครั้งแรกที่ถูกสร้าางหน้านี้
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isclear = widget.maxScore == widget.score;

    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 1000),
            Column(
              children: [
                Stack(
                  children: [
                    // Outline/stroke layer
                    TextShow(
                      title: isclear ? 'YOU WIN' : 'YOU LOSE',
                      backgroundColor: Colors.white,
                      mainTextSize: 54,
                      mainbackgroundColor: Color(0xFFE76F51),
                    ),
                  ],
                ),

                TextShow(
                  title: '${widget.score.toString()}/${widget.maxScore}',
                  backgroundColor: Colors.black,
                  mainTextSize: 50,
                  mainbackgroundColor: Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),

            Column(
              children: [
                Text(
                  'CORRECT ANSWER IS',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            112,
                            236,
                            116,
                          ), // สีพื้นหลัง
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // มุมโค้ง 12px (ปรับได้)
                        ),
                      ),
                    ),

                    widget.correctAnswerType == "image"
                        ? SizedBox(
                            height: 250,
                            width: 250,
                            child: Image.asset(
                              "assets/${widget.correctAnswerType}",
                            ),
                          )
                        : widget.correctAnswerType == "text"
                        ? SizedBox(
                          width: 250,
                          child: Center(
                            child: TextShow(
                                title: '${widget.correctAnswer}',
                                backgroundColor: Colors.black,
                                mainTextSize: 30,
                                mainbackgroundColor: Color.fromARGB(255, 255, 255, 255),
                              ),
                          ),
                        )
                        : GestureDetector(
                            onTap: () async {
                              await _player.stop();
                              await _player.play(
                                AssetSource(widget.correctAnswer),
                              );
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Align(
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                    // Text("${widget.correctAnswer}", style: TextStyle(fontSize: 25))
                  ],
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'HOME',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'RETRY',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => QuizImgScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        color: const Color(0xFF2B2B2B),
        padding: EdgeInsets.only(
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        child: const Text(
          'ADS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
