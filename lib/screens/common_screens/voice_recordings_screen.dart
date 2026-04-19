import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class VoiceRecordingsScreen extends StatefulWidget {
  const VoiceRecordingsScreen({super.key});

  @override
  State<VoiceRecordingsScreen> createState() => _VoiceRecordingsScreenState();
}

class _VoiceRecordingsScreenState extends State<VoiceRecordingsScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  // Firebase reference points to the recordings node
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(
    "recordings/user_123",
  );

  int? _playingIndex;
  bool _isPlaying = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
        if (state == PlayerState.completed) {
          setState(() => _playingIndex = null);
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // --- Functions for Audio & Download ---
  Future<void> _togglePlay(String url, int index) async {
    if (_playingIndex == index && _isPlaying) {
      await _audioPlayer.pause();
      setState(() => _playingIndex = null);
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() => _playingIndex = index);
    }
  }

  Future<void> _download(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3), Color(0xFFD4B8DA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 10),
              _buildInfoNote(),

              // --- Realtime List ---
              Expanded(
                child: StreamBuilder(
                  stream: _dbRef.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      final dynamic rawData = snapshot.data!.snapshot.value;
                      List<Map<String, dynamic>> recordings = [];

                      if (rawData is Map) {
                        rawData.forEach((key, value) {
                          // Har entry (rec_001, rec_002) ko map mein convert karein
                          recordings.add(Map<String, dynamic>.from(value));
                        });
                      }
                    }

                    // Convert Firebase Map to List
                    Map<dynamic, dynamic> data =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    List<Map<String, dynamic>> recordings = [];
                    data.forEach((key, value) {
                      recordings.add(Map<String, dynamic>.from(value));
                    });

                    // Sort by timestamp (newest first)
                    recordings.sort(
                      (a, b) =>
                          (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0),
                    );

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: recordings.length,
                      itemBuilder: (context, index) {
                        return _buildRecordingCard(recordings[index], index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Components optimized for real data
  Widget _buildRecordingCard(Map<String, dynamic> item, int index) {
    final bool isThisPlaying = _playingIndex == index && _isPlaying;
    final String title = item['title'] ?? "Emergency Recording";
    final String url = item['url'] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.mic_rounded, color: Colors.purple.shade400),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                if (isThisPlaying)
                  const Text(
                    "PLAYING",
                    style: TextStyle(fontSize: 10, color: Color(0xFF7B4F8E)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _actionButton(
                  "Play",
                  isThisPlaying ? Icons.pause : Icons.play_arrow,
                  () => _togglePlay(url, index),
                ),
                const SizedBox(width: 10),
                _actionButton(
                  "Download",
                  Icons.download,
                  () => _download(url),
                  isOutline: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isOutline = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isOutline ? Colors.transparent : const Color(0xFF7B4F8E),
            border: isOutline
                ? Border.all(color: const Color(0xFF7B4F8E))
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isOutline ? const Color(0xFF7B4F8E) : Colors.white,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isOutline ? const Color(0xFF7B4F8E) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header methods (AppBar & Empty state) omitted for brevity but remain same as your original style
  Widget _buildAppBar() => const Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      "Voice Recordings",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  Widget _buildInfoNote() =>
      const Text("Live from Hardware", style: TextStyle(color: Colors.white70));
  Widget _buildEmptyState() => const Center(
    child: Text(
      "No recordings found yet.",
      style: TextStyle(color: Colors.white),
    ),
  );
}
