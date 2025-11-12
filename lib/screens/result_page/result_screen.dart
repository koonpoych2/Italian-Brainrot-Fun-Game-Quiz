import 'dart:ffi';
import 'package:audioplayers/audioplayers.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

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
    required this.maxScore
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
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => {
        Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (_) => QuizImgScreen()
              )
          )
          }, 
          icon: SvgPicture.asset(
            "assets/icons/back.svg", 
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          )
        ),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 1000),
          Column(
            children: [
              Text(
                isclear 
                ? 'YOU WIN'
                : 'YOU LOSE',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                ' ${widget.score.toString()}/${widget.maxScore}',
                style: const TextStyle(fontSize: 50),
              ),
            ],
          ),

          Column(
            children: [
              Text(
                'CORRECT ANSWER IS',
                style: const TextStyle(fontSize: 30),
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
                      color: const Color.fromARGB(255, 112, 236, 116), // สีพื้นหลัง
                      borderRadius: BorderRadius.circular(12), // มุมโค้ง 12px (ปรับได้)
                    ),
                  ),
                ),

                widget.correctAnswerType == "image"
                ? 
                SizedBox(
                  height: 250,
                  width: 250,
                  child: 
                    Image.asset("assets/${widget.correctAnswerType}")
                )
                : 
                widget.correctAnswerType == "text"
                ? Text("${widget.correctAnswer}", style: TextStyle(fontSize: 25))
                :
                GestureDetector(
                    onTap: () async {
                      await _player.stop();
                      await _player.play(AssetSource(widget.correctAnswer));
                    },
                    child: Align(
                        child:Icon(
                          Icons.volume_up_rounded,
                          color: Colors.black,
                          size: 50
                        )
                      ),
                  )
                // Text("${widget.correctAnswer}", style: TextStyle(fontSize: 25))
              ],
            )
            ],
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  child: const Text("HOME", style: TextStyle(fontSize: 25)),
                  onPressed: () {},
                          ),
                FilledButton(
                  child: const Text("RETRY", style: TextStyle(fontSize: 25)),
                  onPressed: () {},
                          ),
              ],
            )
        ],
      ),
    );
  }
}