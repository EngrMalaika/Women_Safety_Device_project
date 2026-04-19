import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UnifiedFeedbackScreen extends StatefulWidget {
  const UnifiedFeedbackScreen({super.key});

  @override
  State<UnifiedFeedbackScreen> createState() => _UnifiedFeedbackScreenState();
}

class _UnifiedFeedbackScreenState extends State<UnifiedFeedbackScreen>
    with TickerProviderStateMixin {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final _feedbackController = TextEditingController();
  int _rating = 0;
  String _selectedCategory = "General";
  bool _isLoading = false;

  // 2. Configuration Lists
  final List<String> _emojis = ["😞", "😕", "😐", "😊", "🤩"];
  final List<String> _labels = ["Terrible", "Bad", "Okay", "Good", "Excellent"];
  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.lightGreen,
    Colors.green,
  ];

  final List<String> _categories = [
    "General",
    "Bug Report",
    "Feature Request",
    "UI/UX",
    "Performance",
  ];
  final List<Map<String, dynamic>> _catConfig = [
    {'icon': Icons.chat_bubble_rounded, 'color': Colors.blue},
    {'icon': Icons.bug_report_rounded, 'color': Colors.red},
    {'icon': Icons.lightbulb_rounded, 'color': Colors.orange},
    {'icon': Icons.palette_rounded, 'color': Colors.purple},
    {'icon': Icons.speed_rounded, 'color': Colors.teal},
  ];

  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _submitFeedback() async {
    // Validation: Rating aur text check karein
    if (_rating == 0) {
      _showSnackBar("Please select a rating!", Colors.orange);
      return;
    }
    if (_feedbackController.text.trim().isEmpty) {
      _showSnackBar("Please share your thoughts!", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Data object taiyar karein
      final Map<String, dynamic> feedbackData = {
        'rating': _rating,
        'label': _labels[_rating - 1],
        'category': _selectedCategory,
        'message': _feedbackController.text.trim(),
        'timestamp': ServerValue.timestamp, // Server ka time
      };

      // Firebase mein push karein
      // Path: admin_side -> feedbacks -> [Unique_ID]
      await _dbRef.child('admin_side/feedbacks').push().set(feedbackData);

      _showSnackBar("Thank you! Feedback submitted. 🎉", Colors.green);

      // Reset state and close
      _feedbackController.clear();
      if (mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      _showSnackBar("Failed to send: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    children: [
                      _buildEmojiHeader(), //
                      const SizedBox(height: 20),
                      _buildFeedbackCard(), //
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Components
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "Feedback & Rating",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiHeader() {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _rating == 0
              ? _buildDefaultIcon()
              : ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                    CurvedAnimation(
                      parent: _scaleController,
                      curve: Curves.elasticOut,
                    ),
                  ),
                  child: Text(
                    _emojis[_rating - 1],
                    style: const TextStyle(fontSize: 70),
                  ),
                ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Enjoying the App?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            bool filled = i < _rating;
            return GestureDetector(
              onTap: () {
                setState(() => _rating = i + 1);
                _scaleController.forward(from: 0);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: filled ? Colors.amber : Colors.white.withOpacity(0.5),
                  size: filled ? 48 : 42,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(
            Icons.category_rounded,
            "Category",
            const Color(0xFF7B4F8E),
          ),
          const SizedBox(height: 12),
          _buildCategoryChips(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(),
          ),
          _sectionLabel(Icons.edit_rounded, "Your Feedback", Colors.purple),
          const SizedBox(height: 12),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Tell us what you think...",
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_categories.length, (i) {
        bool isSelected = _selectedCategory == _categories[i];
        Color color = _catConfig[i]['color'];
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = _categories[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _categories[i],
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submitFeedback,
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Submit Feedback",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: const Icon(Icons.star_rounded, size: 40, color: Colors.white),
    );
  }

  Widget _sectionLabel(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
