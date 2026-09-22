import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const CampusCareApp());

class CampusCareApp extends StatelessWidget {
  const CampusCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusCare',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF08BDBA)),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  late final AnimationController animationController;
  bool isRegister = false;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void submit() {
    final valid = emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty &&
        (!isRegister || nameController.text.trim().isNotEmpty);

    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (isRegister) {
      setState(() => isRegister = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please login.')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE9FCFF), Color(0xFFB8F5EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 850) {
                  return _loginCard();
                }
                return Row(
                  children: [
                    Expanded(child: _creativeSide(animationController.value)),
                    Expanded(child: _loginCard()),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _creativeSide(double value) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(48),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD9FAFF), Color(0xFF83E5EC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF075985),
                    child: Icon(Icons.school, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 12),
                  Text('Campus', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF164E7A))),
                  Text('Care', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF0891B2))),
                ],
              ),
              const SizedBox(height: 70),
              const Text('Your Campus Life', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF174B7D))),
              const Text('Made Easier', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF08A6A6))),
              const SizedBox(height: 16),
              const Text('Learn, plan, connect and grow with your smart student companion.', style: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF285C91))),
              const SizedBox(height: 24),
              _feature(Icons.menu_book, 'Study Planner'),
              _feature(Icons.calendar_month, 'Track Progress'),
              _feature(Icons.people, 'Student Community'),
              _feature(Icons.notifications, 'Smart Reminders'),
              const Spacer(),
              Center(
                child: Transform.translate(
                  offset: Offset(0, math.sin(value * math.pi * 2) * 10),
                  child: _studentArt(),
                ),
              ),
            ],
          ),
        ),
        Positioned(top: 70, right: 40, child: _bubble(58, const Color(0xFF0FC7C0), value)),
        Positioned(top: 190, right: 100, child: _bubble(28, const Color(0xFF0784C6), value + 0.3)),
        Positioned(bottom: 130, right: 35, child: _bubble(42, const Color(0xFF19BFD8), value + 0.6)),
      ],
    );
  }

  Widget _feature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF087EA4), size: 25),
          const SizedBox(width: 14),
          Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF245D91))),
        ],
      ),
    );
  }

  Widget _studentArt() {
    return Container(
      width: 270,
      height: 165,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(bottom: 8, child: Container(width: 225, height: 42, decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(14)))),
          Positioned(bottom: 45, child: Container(width: 205, height: 35, decoration: BoxDecoration(color: const Color(0xFF14B8A6), borderRadius: BorderRadius.circular(14)))),
          const Positioned(top: 18, child: CircleAvatar(radius: 33, backgroundColor: Color(0xFFF4B183), child: Icon(Icons.face, size: 48, color: Color(0xFF4B2E20)))),
          Positioned(top: 70, child: Container(width: 95, height: 80, decoration: BoxDecoration(color: const Color(0xFF0E7490), borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.laptop_mac, size: 55, color: Colors.white))),
          const Positioned(top: 0, right: 22, child: Icon(Icons.school, size: 52, color: Color(0xFF164E7A))),
        ],
      ),
    );
  }

  Widget _bubble(double size, Color color, double phase) {
    return Transform.translate(
      offset: Offset(math.sin(phase * math.pi * 2) * 12, math.cos(phase * math.pi * 2) * 12),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [color, Colors.white.withOpacity(0.4)]),
          boxShadow: const [BoxShadow(blurRadius: 14, color: Colors.white)],
        ),
      ),
    );
  }

  Widget _loginCard() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: Card(
            elevation: 20,
            shadowColor: const Color(0x5500788B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: CircleAvatar(radius: 35, backgroundColor: const Color(0xFFE0FBFA), child: const Icon(Icons.school, size: 42, color: Color(0xFF087EA4)))),
                  const SizedBox(height: 18),
                  Center(child: Text(isRegister ? 'Create Account ✨' : 'Welcome Back 👋', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Color(0xFF123A65)))),
                  const SizedBox(height: 8),
                  Center(child: Text(isRegister ? 'Start your campus journey' : 'Login to your CampusCare account', style: const TextStyle(color: Color(0xFF5D83AA)))),
                  const SizedBox(height: 25),
                  if (isRegister) ...[
                    _label('Full Name'),
                    _field(nameController, Icons.person_outline, 'Enter your name'),
                    const SizedBox(height: 15),
                  ],
                  _label('Email Address'),
                  _field(emailController, Icons.email_outlined, 'Enter your email', type: TextInputType.emailAddress),
                  const SizedBox(height: 15),
                  _label('Password'),
                  _field(passwordController, Icons.lock_outline, 'Enter your password', obscure: !showPassword, suffix: IconButton(onPressed: () => setState(() => showPassword = !showPassword), icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility))),
                  const SizedBox(height: 22),
                  SizedBox(width: double.infinity, height: 52, child: FilledButton.icon(onPressed: submit, icon: Icon(isRegister ? Icons.person_add : Icons.login), label: Text(isRegister ? 'Register' : 'Login'))),
                  const SizedBox(height: 14),
                  Center(child: TextButton(onPressed: () => setState(() => isRegister = !isRegister), child: Text(isRegister ? 'Already have an account? Login' : 'New user? Register'))),
                  const SizedBox(height: 8),
                  const Center(child: Text('Demo app • No real account is created', style: TextStyle(fontSize: 11, color: Colors.grey))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF24598D))),
    );
  }

  Widget _field(TextEditingController controller, IconData icon, String hint, {TextInputType? type, bool obscure = false, Widget? suffix}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF326A9C)),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF4FCFF),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF08BDBA), width: 2)),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CampusCare')),
      body: const Center(child: Text('Welcome to CampusCare 🎓', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
    );
  }
}
