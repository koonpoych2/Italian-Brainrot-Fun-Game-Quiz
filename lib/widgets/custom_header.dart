import 'package:flutter/material.dart';
import 'outlined_title_text.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onHomeTap;

  const CustomHeader({
    super.key,
    required this.title,
    this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Title with Shadow/Outline effect
          OutlinedTitleText(text: title),
          // Home Button
          if (onHomeTap != null)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onHomeTap,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.home, color: Colors.black, size: 30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}