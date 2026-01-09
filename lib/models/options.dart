class Options {
  final String name;
  final String imgPath;
  final String soundPath;
  final String description;
  final String conclusionAi;
  final bool isUnlocked;

  const Options({
    required this.name,
    required this.imgPath,
    this.soundPath = '',
    this.description = 'default',
    this.conclusionAi = '',
    this.isUnlocked = false
  });
}
