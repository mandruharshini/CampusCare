import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const CampusCareApp());

class CampusCareApp extends StatelessWidget {
  const CampusCareApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CampusCare',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF08BDBA)),
        home: const LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  late final AnimationController animation;
  bool register = false;
  bool showPassword = false;
  bool remember = false;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    animation.dispose();
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  void submit() {
    if (email.text.trim().isEmpty || password.text.isEmpty || (register && name.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all required fields')));
      return;
    }
    if (register) {
      setState(() => register = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful. Please login.')));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animation,
        builder: (_, __) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFE9FCFF), Color(0xFFBFF7F4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 850;
              return Row(children: [
                if (wide) Expanded(flex: 11, child: _creativePanel(animation.value)),
                Expanded(flex: 10, child: _loginPanel()),
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget _creativePanel(double value) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(48, 42, 24, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFDAFAFF), Color(0xFF8CE8F0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              CircleAvatar(radius: 25, backgroundColor: Color(0xFF064E75), child: Icon(Icons.school, color: Colors.white, size: 30)),
              SizedBox(width: 12),
              Text('Campus', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800, color: Color(0xFF164E7A))),
              Text('Care', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800, color: Color(0xFF08BDBA))),
            ]),
            const SizedBox(height: 5),
            const Padding(padding: EdgeInsets.only(left: 63), child: Text('Learn  •  Plan  •  Grow', style: TextStyle(fontSize: 15, color: Color(0xFF2563A6)))),
            const Spacer(),
            const Text('Your Campus Life', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF174B7D))),
            const Text('Made Easier', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF08BDBA))),
            const SizedBox(height: 15),
            const SizedBox(width: 370, child: Text('Access your classes, plan your studies, track your goals and build a better tomorrow — all in one place.', style: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF285C91)))),
            const SizedBox(height: 22),
            _feature(Icons.menu_book_rounded, 'Study Planner'),
            _feature(Icons.calendar_month_rounded, 'Track Progress'),
            _feature(Icons.people_alt_rounded, 'Student Profile'),
            _feature(Icons.notifications_active_rounded, 'Smart Reminders'),
            const Spacer(),
            Center(child: Transform.translate(offset: Offset(0, math.sin(value * math.pi * 2) * 10), child: _studentIllustration())),
          ]),
        ),
        Positioned(top: 55, right: 40, child: _bubble(58, const Color(0xFF12C9C1), value)),
        Positioned(top: 170, right: 100, child: _bubble(28, const Color(0xFF0784C6), value + .3)),
        Positioned(bottom: 110, right: 35, child: _bubble(42, const Color(0xFF19BFD8), value + .6)),
      ],
    );
  }

  Widget _feature(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(.7), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: const Color(0xFF087EA4))),
          const SizedBox(width: 13),
          Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF245D91))),
        ]),
      );

  Widget _studentIllustration() => Container(
        width: 290,
        height: 180,
        decoration: BoxDecoration(color: Colors.white.withOpacity(.38), borderRadius: BorderRadius.circular(100)),
        child: Stack(alignment: Alignment.center, children: [
          Positioned(bottom: 10, child: Container(width: 235, height: 45, decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(12)))),
          Positioned(bottom: 48, child: Container(width: 220, height: 35, decoration: BoxDecoration(color: const Color(0xFF14B8A6), borderRadius: BorderRadius.circular(12)))),
          const Positioned(top: 18, child: CircleAvatar(radius: 35, backgroundColor: Color(0xFFF4B183), child: Icon(Icons.face_rounded, size: 52, color: Color(0xFF4B2E20)))),
          Positioned(top: 74, child: Container(width: 90, height: 85, decoration: BoxDecoration(color: const Color(0xFF0E7490), borderRadius: BorderRadius.circular(30)), child: const Icon(Icons.laptop_mac, size: 58, color: Colors.white))),
          const Positioned(top: 0, right: 24, child: Icon(Icons.school, size: 55, color: Color(0xFF164E7A))),
        ]),
      );

  Widget _bubble(double size, Color color, double phase) => Transform.translate(
        offset: Offset(math.sin(phase * math.pi * 2) * 14, math.cos(phase * math.pi * 2) * 12),
        child: Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [color.withOpacity(.95), Colors.white.withOpacity(.4)]), boxShadow: const [BoxShadow(blurRadius: 15, color: Colors.white)])),
      );

  Widget _loginPanel() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: Card(
            elevation: 22,
            shadowColor: const Color(0x5500788B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: const EdgeInsets.all(34),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFE0FBFA), border: Border.all(color: const Color(0xFF65E5E0), width: 2)), child: const Icon(Icons.school, size: 48, color: Color(0xFF087EA4)))),
                const SizedBox(height: 18),
                Center(child: Text(register ? 'Create Account ✨' : 'Welcome Back 👋', style: const TextStyle(fontSize: 29, fontWeight: FontWeight.bold, color: Color(0xFF123A65)))),
                const SizedBox(height: 8),
                Center(child: Text(register ? 'Start your campus journey' : 'Login to your CampusCare account', style: const TextStyle(color: Color(0xFF5D83AA), fontSize: 15))),
                const SizedBox(height: 28),
                if (register) ...[_label('Full Name'), _field(name, Icons.person_outline, 'Enter your name'), const SizedBox(height: 16)],
                _label('Email Address'),
                _field(email, Icons.email_outlined, 'Enter your email', type: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _label('Password'),
                _field(password, Icons.lock_outline, 'Enter your password', obscure: !showPassword, suffix: IconButton(onPressed: () => setState(() => showPassword = !showPassword), icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility))),
                const SizedBox(height: 8),
                Row(children: [Checkbox(value: remember, onChanged: (v) => setState(() => remember = v ?? false)), const Text('Remember me'), const Spacer(), TextButton(onPressed: () {}, child: const Text('Forgot password?'))]),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, height: 54, child: FilledButton.icon(onPressed: submit, icon: Icon(register ? Icons.person_add : Icons.arrow_forward), label: Text(register ? 'Register' : 'Login', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))),
                const SizedBox(height: 18),
                Row(children: const [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('OR')), Expanded(child: Divider())]),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red), label: const Text('Continue with Google')),
                const SizedBox(height: 20),
                Center(child: TextButton(onPressed: () => setState(() => register = !register), child: Text(register ? 'Already have an account? Login →' : 'Don’t have an account? Register →'))),
                const Center(child: Text('Demo app • No real account is created', style: TextStyle(fontSize: 11, color: Colors.grey))),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF24598D))));

  Widget _field(TextEditingController controller, IconData icon, String hint, {TextInputType? type, bool obscure = false, Widget? suffix}) => TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: const Color(0xFF326A9C)), suffixIcon: suffix, filled: true, fillColor: const Color(0xFFF4FCFF), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFB8DCEB))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFB8DCEB))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF08BDBA), width: 2))),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('CampusCare'), backgroundColor: const Color(0xFFBFF7F4)),
        body: const Center(child: Text('Welcome to CampusCare 🎓', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
      );
}
