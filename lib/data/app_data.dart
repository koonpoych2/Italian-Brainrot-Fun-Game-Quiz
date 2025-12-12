import '../models/options.dart';


class AppData {
  // --- SOUNDBOARD DATA ---
  static const String defaultSound = 'sounds/burbaloni_lulliloli.mp3';

  // --- WIKI DATA ---
  static final List<Options> wikiItems = [
    Options(
      name: "Tararero",
      imgPath: 'assets/images/burbaloni_lulliloli.png',
      isUnlocked: true,
      description: "On the beach, there stands an intriguing shark character sporting three legs and fashionable Nike sneakers. This unique figure marks the inception of the Italian creation known as Brainot Mim, which is defined by its competitive spirit against Bardiro Crocodilo.",
    ),
    Options(
      name: "Sharky Two",
      imgPath: 'assets/images/burbaloni_lulliloli.png',
      isUnlocked: true,
      description: "Another shark character description goes here...",
    ),
    Options(
      name: "Locked Item",
      imgPath: 'assets/images/burbaloni_lulliloli.png',
      isUnlocked: false, // This will show the Lock icon
      description: "???",
    ),
    // Add more items here...
  ];
}