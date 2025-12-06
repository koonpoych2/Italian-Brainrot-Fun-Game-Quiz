class Options {
  final String name;
  final String imgPath;
  final String soundPath;
  final String description;
  final bool isUnlocked;

  const Options({
    required this.name,
    required this.imgPath,
    this.soundPath = '',
    this.description = 'default',
    this.isUnlocked = false
  });
}