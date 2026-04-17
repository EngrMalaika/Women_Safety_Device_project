import 'package:flutter/material.dart';
import 'package:safety_app/screens/guardian_screens/guardian_dashboard_screen.dart';
import 'package:safety_app/screens/guardian_screens/login_guardian_screen.dart';

class SignupGuardianScreen extends StatefulWidget {
  @override
  _SignupGuardianScreenState createState() => _SignupGuardianScreenState();
}

class _SignupGuardianScreenState extends State<SignupGuardianScreen>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Controllers
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final cnicController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final deviceIdController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  AnimationController? _fadeController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    nameController.dispose();
    ageController.dispose();
    cnicController.dispose();
    phoneController.dispose();
    addressController.dispose();
    deviceIdController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _fadeController?.reset();
      setState(() => _currentStep++);
      _fadeController?.forward();
    } else {
      _createAccount();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _fadeController?.reset();
      setState(() => _currentStep--);
      _fadeController?.forward();
    }
  }

  void _createAccount() {
    // 🔴 Backend — Phase 2: Firebase save guardian data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GuardianDashboardScreen(role: "Guardian"),
      ),
    );
  }

  final List<Map<String, dynamic>> _stepMeta = [
    {
      'icon': Icons.person_rounded,
      'title': 'Personal Info',
      'subtitle': 'Tell us about yourself',
    },
    {
      'icon': Icons.location_on_rounded,
      'title': 'Contact Details',
      'subtitle': 'Your phone & address',
    },
    {
      'icon': Icons.link_rounded,
      'title': 'Link & Account',
      'subtitle': 'Connect to user & create account',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3), Color(0xFFD4B8DA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── HEADER ────────────────────────────────────
              _buildHeader(),
              const SizedBox(height: 12),

              // ── STEP INDICATORS ───────────────────────────
              _buildStepIndicators(),
              const SizedBox(height: 16),

              // ── FORM CARD ─────────────────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation ?? const AlwaysStoppedAnimation(1.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Step title
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF7B4F8E,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _stepMeta[_currentStep]['icon'] as IconData,
                                    color: const Color(0xFF7B4F8E),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _stepMeta[_currentStep]['title']
                                          as String,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF7B4F8E),
                                      ),
                                    ),
                                    Text(
                                      _stepMeta[_currentStep]['subtitle']
                                          as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(height: 1),
                            const SizedBox(height: 16),

                            // Step content
                            _buildCurrentStep(),

                            const SizedBox(height: 20),

                            // Nav buttons
                            _buildNavButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Already have account
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginGuardianScreen()),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
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

  // ── HEADER ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white38, width: 1.5),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Guardian Setup",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Step ${_currentStep + 1} of $_totalSteps",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── STEP INDICATORS ─────────────────────────────────────────
  Widget _buildStepIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white38,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── STEP CONTENT ────────────────────────────────────────────
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  // Step 1 — Personal Info
  Widget _buildStep1() {
    return Column(
      children: [
        _field(
          "Full Name",
          nameController,
          Icons.person_rounded,
          hint: "e.g. Ali Hassan",
        ),
        const SizedBox(height: 12),
        _field(
          "Age",
          ageController,
          Icons.cake_rounded,
          hint: "e.g. 30",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _field(
          "CNIC Number",
          cnicController,
          Icons.credit_card_rounded,
          hint: "XXXXX-XXXXXXX-X",
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Step 2 — Contact Details
  Widget _buildStep2() {
    return Column(
      children: [
        _field(
          "Phone Number",
          phoneController,
          Icons.phone_rounded,
          hint: "03XX-XXXXXXX",
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _field(
          "Home Address",
          addressController,
          Icons.home_rounded,
          hint: "Street, City",
        ),
      ],
    );
  }

  // Step 3 — Link User + Account
  Widget _buildStep3() {
    return Column(
      children: [
        // Link user section
        _sectionLabel("Link User's Device", Icons.link_rounded, Colors.orange),
        const SizedBox(height: 10),
        _field(
          "User's Device ID",
          deviceIdController,
          Icons.qr_code_rounded,
          hint: "e.g. SD-12455",
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade600, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Enter the Device ID from the user's ESP32 safety device to start monitoring.",
                  style: TextStyle(fontSize: 11, color: Colors.orange.shade800),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Account section
        _sectionLabel(
          "Create Account",
          Icons.lock_rounded,
          const Color(0xFF7B4F8E),
        ),
        const SizedBox(height: 10),
        _field(
          "Email Address",
          emailController,
          Icons.email_rounded,
          hint: "you@example.com",
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _passwordField(),
      ],
    );
  }

  // ── NAV BUTTONS ─────────────────────────────────────────────
  Widget _buildNavButtons() {
    final isLast = _currentStep == _totalSteps - 1;
    final isFirst = _currentStep == 0;

    return Row(
      children: [
        if (!isFirst)
          Expanded(
            child: GestureDetector(
              onTap: _prevStep,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF7B4F8E).withOpacity(0.4),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 16,
                        color: Color(0xFF7B4F8E),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Back",
                        style: TextStyle(
                          color: Color(0xFF7B4F8E),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (!isFirst) const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: _nextStep,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B4F8E).withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLast ? "Create Account" : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isLast
                          ? Icons.check_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── HELPERS ─────────────────────────────────────────────────
  Widget _sectionLabel(String label, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (v) => v!.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(icon, color: const Color(0xFF7B4F8E), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF7B4F8E),
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: passwordController,
          obscureText: _obscurePassword,
          validator: (v) => v!.length < 6 ? "Min 6 characters required" : null,
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: const Icon(
              Icons.lock_rounded,
              color: Color(0xFF7B4F8E),
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF7B4F8E),
                width: 1.8,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
          ),
        ),
      ],
    );
  }
}
