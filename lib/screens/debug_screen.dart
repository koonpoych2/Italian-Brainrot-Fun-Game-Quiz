import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

/// Debug screen to test and demonstrate all persistence features
/// This screen is helpful for testing and understanding how the system works
class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text(
          'Debug & Testing',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Center(
              child: Text(
                'Persistence Demo',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Current State Section
            _buildSection(
              title: '📊 Current State',
              child: Column(
                children: [
                  _buildStatRow('High Score', '${appState.highScore}'),
                  _buildStatRow(
                    'Unlocked Sounds',
                    '${appState.unlockedSounds.length} / 20',
                  ),
                  _buildStatRow(
                    'Unlocked Wiki',
                    '${appState.unlockedWiki.length} items',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sound Indices: ${appState.unlockedSounds}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Wiki Indices: ${appState.unlockedWiki}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Score Testing Section
            _buildSection(
              title: '🏆 Score Testing',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await appState.updateHighScore(5);
                      _showSnackBar(context, 'Set high score to 5');
                    },
                    style: _buttonStyle(Colors.blue),
                    child: const Text('Set High Score: 5'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await appState.updateHighScore(10);
                      _showSnackBar(context, 'Set high score to 10');
                    },
                    style: _buttonStyle(Colors.blue),
                    child: const Text('Set High Score: 10'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await appState.onQuizComplete(8, 10);
                      _showSnackBar(
                        context,
                        'Quiz Complete! 8/10\nAuto-unlocks triggered!',
                      );
                    },
                    style: _buttonStyle(Colors.purple),
                    child: const Text('Simulate Quiz: 8/10'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await appState.onQuizComplete(10, 10);
                      _showSnackBar(
                        context,
                        'Perfect Score! 10/10\nAll auto-unlocks triggered!',
                      );
                    },
                    style: _buttonStyle(Colors.purple),
                    child: const Text('Simulate Quiz: 10/10 (Perfect)'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Unlock Testing Section
            _buildSection(
              title: '🔓 Unlock Testing',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await appState.unlockSound(5);
                      _showSnackBar(
                        context,
                        success
                            ? 'Sound #5 unlocked! (Free - video ads coming soon)'
                            : 'Already unlocked',
                        success ? Colors.green : Colors.orange,
                      );
                    },
                    style: _buttonStyle(Colors.teal),
                    child: const Text('Unlock Sound #5 (Free)'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await appState.unlockWiki(3);
                      _showSnackBar(
                        context,
                        success
                            ? 'Wiki #3 unlocked! (Free - video ads coming soon)'
                            : 'Already unlocked',
                        success ? Colors.green : Colors.orange,
                      );
                    },
                    style: _buttonStyle(Colors.teal),
                    child: const Text('Unlock Wiki #3 (Free)'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      bool soundUnlocked = appState.isSoundUnlocked(5);
                      bool wikiUnlocked = appState.isWikiUnlocked(3);
                      _showSnackBar(
                        context,
                        'Sound #5: ${soundUnlocked ? "✅" : "🔒"}\n'
                        'Wiki #3: ${wikiUnlocked ? "✅" : "🔒"}',
                      );
                    },
                    style: _buttonStyle(Colors.indigo),
                    child: const Text('Check Unlock Status'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Reset Section
            _buildSection(
              title: '🔄 Reset Data',
              child: Column(
                children: [
                  const Text(
                    'Reset all data (high score, unlocks) to test persistence.\nRestart the app to verify data was cleared.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmDialog(
                        context,
                        'Reset All Data?',
                        'This will clear all coins, scores, and unlocks.',
                        () async {
                          await appState.resetAll();
                          _showSnackBar(
                            context,
                            'All data reset! Restart app to verify.',
                            Colors.orange,
                          );
                        },
                      );
                    },
                    style: _buttonStyle(Colors.red),
                    child: const Text('⚠️ RESET ALL DATA'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Instructions
            _buildSection(
              title: '📖 Instructions',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Test buttons above to modify state',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '2. Unlock sounds/wiki items (free for now)',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '3. CLOSE and RESTART the app',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '4. Return to this screen',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '5. Verify data persisted! ✨',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'NOTE: Video ads will be added by your friend later',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: GoogleFonts.luckiestGuy(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, [
    Color? backgroundColor,
  ]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.black87,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: GoogleFonts.luckiestGuy()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
