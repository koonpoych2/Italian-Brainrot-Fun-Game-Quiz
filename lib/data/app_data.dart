import '../models/options.dart';
import '../models/options_data.dart';

class AppData {
  // --- SOUNDBOARD DATA ---
  static const String defaultSound = 'sounds/burbaloni_lulliloli.mp3';

  // --- WIKI DATA ---
  // Use the same data as italianBrainrotOptions
  static List<Options> get wikiItems => italianBrainrotOptions;
}
