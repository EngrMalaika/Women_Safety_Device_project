import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class VoiceRecordingsScreen extends StatefulWidget {
  const VoiceRecordingsScreen({super.key});

  @override
  State<VoiceRecordingsScreen> createState() => _VoiceRecordingsScreenState();
}

class _VoiceRecordingsScreenState extends State<VoiceRecordingsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // --------- Dummy List (Later Replace with Firebase URLs) --------- //
  final List<Map<String, String>> recordings = const [
    {
      "title": "Recording 1",
      "url": "https://samplelib.com/lib/preview/mp3/sample-3s.mp3",
      "date": "21 Nov 2025",
      "duration": "00:03 sec",
      "size": "120 KB",
    },
    {
      "title": "Recording 2",
      "url": "https://samplelib.com/lib/preview/mp3/sample-6s.mp3",
      "date": "20 Nov 2025",
      "duration": "00:06 sec",
      "size": "230 KB",
    },
  ];

  // Play audio
  Future<void> playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  // Download audio (opens URL)
  Future<void> downloadAudio(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Voice Evidence Recordings",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: recordings.length,
        itemBuilder: (context, index) {
          final item = recordings[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.pink, width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"]!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    infoTag(Icons.calendar_month, item["date"]!),
                    infoTag(Icons.timer, item["duration"]!),
                    infoTag(Icons.sd_storage_rounded, item["size"]!),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text("Play",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () => playAudio(item["url"]!),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.white),
                      label: const Text("Download",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () => downloadAudio(item["url"]!),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget infoTag(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.pink),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
