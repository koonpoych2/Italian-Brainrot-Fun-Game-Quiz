import '../models/wiki_item.dart';

class AppData {
  // --- SOUNDBOARD DATA ---
  static const String defaultSound = 'sounds/burbaloni_lulliloli.mp3';

  // --- WIKI DATA ---
  static final List<WikiItem> wikiItems = [
    WikiItem(
      title: "Tararero",
      imagePath: 'assets/images/burbaloni_lulliloli.png',
      isUnlocked: true,
      description: "On the beach, there stands an intriguing shark character sporting three legs and fashionable Nike sneakers. This unique figure marks the inception of the Italian creation known as Brainot Mim, which is defined by its competitive spirit against Bardiro Crocodilo.",
    ),
    WikiItem(
      title: "Sharky Two",
      imagePath: 'assets/images/burbaloni_lulliloli.png',
      isUnlocked: true,
      description: "Another shark character description goes here...",
    ),
    WikiItem(
      title: "Locked Item",
      imagePath: 'assets/images/burbaloni_lulliloli.png',
      isUnlocked: false, // This will show the Lock icon
      description: "???",
    ),
    // Add more items here...
  ];
}