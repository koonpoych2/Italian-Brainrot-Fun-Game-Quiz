import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../widgets/ads_banner.dart';
import '../widgets/custom_header.dart';
import 'wiki_detail_screen.dart';

class WikiListScreen extends StatelessWidget {
  const WikiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "WIKI",
              onHomeTap: () => Navigator.pop(context),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.0,
                ),
                itemCount: AppData.wikiItems.length,
                itemBuilder: (context, index) {
                  final item = AppData.wikiItems[index];

                  return GestureDetector(
                    onTap: item.isUnlocked
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WikiDetailScreen(item: item),
                        ),
                      );
                    }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: item.isUnlocked
                            ? Hero(
                          tag: item.title,
                          child: Image.asset(item.imagePath,
                              fit: BoxFit.cover),
                        )
                            : Container(
                          color: Colors.black.withOpacity(0.8),
                          child: const Center(
                              child: Icon(Icons.lock,
                                  color: Colors.white, size: 40)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const AdsBanner(),
          ],
        ),
      ),
    );
  }
}