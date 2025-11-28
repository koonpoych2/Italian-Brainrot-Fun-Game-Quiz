class WikiItem {
  final String title;
  final String imagePath;
  final String description;
  final bool isUnlocked;

  WikiItem({
    required this.title,
    required this.imagePath,
    required this.description,
    this.isUnlocked = false,
  });
}