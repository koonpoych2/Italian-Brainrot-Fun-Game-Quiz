import 'package:flutter/material.dart';

class AdsBanner extends StatelessWidget {
  const AdsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2B2B2B),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: const Center(
        child: Text(
          'ADS',
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