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
  int? _playingIndex;
  bool _isPlaying = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ── Dummy data (replace with Firebase URLs later) ────────
  final List<Map<String, String>> recordings = const [
    {
      "title": "Emergency Recording 1",
      "url": "https://samplelib.com/lib/preview/mp3/sample-3s.mp3",
      "date": "21 Nov 2025",
      "time": "11:42 PM",
      "duration": "00:03",
      "size": "120 KB",
    },
    {
      "title": "Emergency Recording 2",
      "url": "https://samplelib.com/lib/preview/mp3/sample-6s.mp3",
      "date": "20 Nov 2025",
      "time": "08:15 PM",
      "duration": "00:06",
      "size": "230 KB",
    },
    {
      "title": "SOS Triggered Recording",
      "url": "https://samplelib.com/lib/preview/mp3/sample-9s.mp3",
      "date": "18 Nov 2025",
      "time": "10:30 PM",
      "duration": "00:09",
      "size": "340 KB",
    },
  ];

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
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open download link'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
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
            stops: [0.0, 0.32, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── APP BAR ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "Voice Recordings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    // Count badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white38, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.mic_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${recordings.length} files",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ── INFO NOTE ────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white70,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Recordings auto-saved during SOS events via IoT device",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── LIST ─────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: recordings.length,
                  itemBuilder: (context, index) {
                    final item = recordings[index];
                    final bool isThisPlaying =
                        _playingIndex == index && _isPlaying;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isThisPlaying
                            ? Border.all(
                                color: const Color(0xFF7B4F8E),
                                width: 1.5,
                              )
                            : null,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isThisPlaying
                                        ? const Color(
                                            0xFF7B4F8E,
                                          ).withOpacity(0.12)
                                        : Colors.purple.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: isThisPlaying
                                      ? ScaleTransition(
                                          scale: _pulseAnimation,
                                          child: const Icon(
                                            Icons.graphic_eq_rounded,
                                            color: Color(0xFF7B4F8E),
                                            size: 22,
                                          ),
                                        )
                                      : Icon(
                                          Icons.mic_rounded,
                                          color: Colors.purple.shade400,
                                          size: 22,
                                        ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item["title"]!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isThisPlaying)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF7B4F8E,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "PLAYING",
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF7B4F8E),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Info tags
                            Row(
                              children: [
                                _infoChip(
                                  Icons.calendar_today_rounded,
                                  item["date"]!,
                                  Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                _infoChip(
                                  Icons.access_time_rounded,
                                  item["time"]!,
                                  Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                _infoChip(
                                  Icons.timer_rounded,
                                  item["duration"]!,
                                  Colors.purple,
                                ),
                                const SizedBox(width: 8),
                                _infoChip(
                                  Icons.sd_storage_rounded,
                                  item["size"]!,
                                  Colors.teal,
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Waveform decoration
                            Row(
                              children: List.generate(28, (i) {
                                final double h = [
                                  10.0,
                                  20.0,
                                  14.0,
                                  24.0,
                                  8.0,
                                  18.0,
                                  28.0,
                                  12.0,
                                  22.0,
                                  16.0,
                                  26.0,
                                  10.0,
                                  20.0,
                                  30.0,
                                  14.0,
                                  22.0,
                                  8.0,
                                  18.0,
                                  26.0,
                                  12.0,
                                  20.0,
                                  16.0,
                                  24.0,
                                  10.0,
                                  18.0,
                                  14.0,
                                  22.0,
                                  8.0,
                                ][i % 28];
                                return Container(
                                  width: 3,
                                  height: h,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isThisPlaying
                                        ? const Color(
                                            0xFF7B4F8E,
                                          ).withOpacity(0.6)
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 14),

                            // Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _togglePlay(item["url"]!, index),
                                    child: Container(
                                      height: 42,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isThisPlaying
                                              ? [
                                                  Colors.grey.shade400,
                                                  Colors.grey.shade500,
                                                ]
                                              : [
                                                  const Color(0xFF7B4F8E),
                                                  const Color(0xFF9B6FA3),
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (isThisPlaying
                                                        ? Colors.grey
                                                        : const Color(
                                                            0xFF7B4F8E,
                                                          ))
                                                    .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isThisPlaying
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isThisPlaying ? "Pause" : "Play",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _download(item["url"]!),
                                    child: Container(
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.green.shade300,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.download_rounded,
                                            color: Colors.green.shade600,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Download",
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _infoChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
