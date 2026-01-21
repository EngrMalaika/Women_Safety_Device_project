import 'package:flutter/material.dart';
import 'package:safety_app/screens/guardian_screens/guardian_dashboard_screen.dart';
import 'package:safety_app/screens/guardian_screens/login_guardian_screen.dart';

class SignupGuardianScreen extends StatefulWidget {
  @override
  _SignupGuardianScreenState createState() => _SignupGuardianScreenState();
}

class _SignupGuardianScreenState extends State<SignupGuardianScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final cnicController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final contact1Controller = TextEditingController();
  final contact2Controller = TextEditingController();

  void createAccount() {
    if (formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GuardianDashboardScreen(role: "Guardian"),
        ),
      );
    }
  }

  Widget buildField(String label, TextEditingController c, IconData icon) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          controller: c,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.pink.shade300),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.pink.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
            ),
            filled: true,
            fillColor: Colors.pink.shade50,
          ),
          validator: (v) => v!.isEmpty ? "Enter $label" : null,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Keep gradient visible
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // White back icon
      ),
      extendBodyBehindAppBar: true, // So gradient shows behind AppBar
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.pink.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ----- Header Icon & Title -----
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink.shade200.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                    Icons.security,
                    size: 80,
                    color: Colors.pink.shade400,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Create Your Guardian Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),

                // ----- Form Card -----
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildField("Name", nameController, Icons.person),
                        buildField("Age", ageController, Icons.calendar_today),
                        buildField("CNIC", cnicController, Icons.credit_card),
                        buildField(
                          "Phone Number",
                          phoneController,
                          Icons.phone,
                        ),
                        buildField("Address", addressController, Icons.home),
                        buildField(
                          "Emergency Contact 1",
                          contact1Controller,
                          Icons.contact_phone,
                        ),
                        buildField(
                          "Emergency Contact 2",
                          contact2Controller,
                          Icons.contact_phone,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: createAccount,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            backgroundColor: Colors.pink,
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Color.fromARGB(255, 251, 251, 251),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginGuardianScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
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
      ),
    );
  }
}