import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const CampusCareApp());

class CampusCareApp extends StatelessWidget {
  const CampusCareApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CampusCare',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF0E7490), fontFamily: 'Arial'),
        home: const AuthPage(),
      );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final AnimationController animation;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool register = false;
  bool hidden = true;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    animation.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void continueToApp() {
    if (email.text.trim().isEmpty || password.text.isEmpty || (register && name.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }
    if (register) {
      setState(() => register = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful! Please login.')));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF083344), Color(0xFF0E7490), Color(0xFF67E8F9)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
        AnimatedBuilder(animation: animation, builder: (_, __) => Stack(children: [
          Positioned(left: -70 + 25 * math.sin(animation.value * math.pi * 2), top: 80, child: _bubble(180, Colors.white12)),
          Positioned(right: -60 + 20 * math.cos(animation.value * math.pi * 2), bottom: 70, child: _bubble(220, Colors.white10)),
        ])),
        Center(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Card(elevation: 18, color: Colors.white.withOpacity(.96), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), child: Padding(padding: const EdgeInsets.all(28), child: Column(children: [
          TweenAnimationBuilder<double>(tween: Tween(begin: 0.7, end: 1), duration: const Duration(milliseconds: 800), builder: (_, value, child) => Transform.scale(scale: value, child: child), child: const CircleAvatar(radius: 42, backgroundColor: Color(0xFFE0F2FE), child: Icon(Icons.school_rounded, size: 45, color: Color(0xFF0E7490)))),
          const SizedBox(height: 18),
          Text(register ? 'Create your account' : 'Welcome back!', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(register ? 'Join your smarter campus journey' : 'Your smart student companion', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 26),
          if (register) ...[TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())), const SizedBox(height: 16)],
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: password, obscureText: hidden, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(), suffixIcon: IconButton(onPressed: () => setState(() => hidden = !hidden), icon: Icon(hidden ? Icons.visibility : Icons.visibility_off)))),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 52, child: FilledButton.icon(onPressed: continueToApp, icon: Icon(register ? Icons.person_add_alt_1 : Icons.login), label: Text(register ? 'Register' : 'Login'))),
          const SizedBox(height: 16),
          TextButton(onPressed: () => setState(() => register = !register), child: Text(register ? 'Already have an account? Login' : 'New to CampusCare? Register')),
          const SizedBox(height: 4),
          const Text('Demo app • No real account is created', style: TextStyle(fontSize: 12, color: Colors.black45)),
        ]))))),
      ]),
    );
  }

  Widget _bubble(double size, Color color) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;
  final tasks = <String>['Complete Flutter assignment', 'Revise Computer Networks'];
  final done = <bool>[false, false];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF0FDFA),
        body: SafeArea(child: Row(children: [
          NavigationRail(selectedIndex: selected, labelType: NavigationRailLabelType.all, onDestinationSelected: (v) => setState(() => selected = v), destinations: const [
            NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Home')),
            NavigationRailDestination(icon: Icon(Icons.task_alt), label: Text('Tasks')),
            NavigationRailDestination(icon: Icon(Icons.calendar_month), label: Text('Planner')),
            NavigationRailDestination(icon: Icon(Icons.person_outline), label: Text('Profile')),
            NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text('More')),
          ]),
          Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 350), child: page())),
        ])),
        floatingActionButton: selected == 1 ? FloatingActionButton.extended(onPressed: addTask, icon: const Icon(Icons.add), label: const Text('Add task')) : null,
      );

  Widget page() { switch (selected) { case 1: return taskPage(); case 2: return plannerPage(); case 3: return profilePage(); case 4: return morePage(); default: return dashboard(); } }

  Widget dashboard() => ListView(padding: const EdgeInsets.all(28), children: [
        const Text('Good morning, Harshini 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8), const Text('Your campus, your success.'), const SizedBox(height: 26),
        Container(padding: const EdgeInsets.all(26), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0E7490), Color(0xFF14B8A6)]), borderRadius: BorderRadius.circular(28)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CAMPUSCARE', style: TextStyle(color: Colors.white70, letterSpacing: 3)), SizedBox(height: 12), Text('Learn. Connect. Grow.', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Everything you need for a better college journey.', style: TextStyle(color: Colors.white70))])),
        const SizedBox(height: 26), const Text('Today’s focus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
        ...tasks.asMap().entries.map((e) => Card(child: CheckboxListTile(value: done[e.key], onChanged: (v) => setState(() => done[e.key] = v ?? false), title: Text(e.value), secondary: const Icon(Icons.school)))),
      ]);

  Widget taskPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('My Tasks', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...tasks.asMap().entries.map((e) => Card(child: ListTile(title: Text(e.value), leading: Icon(done[e.key] ? Icons.check_circle : Icons.task_alt), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() { tasks.removeAt(e.key); done.removeAt(e.key); }))))) ]);
  Widget plannerPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('Study Planner', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...['08:00 AM • Data Structures', '10:00 AM • DBMS', '02:00 PM • Flutter practice', '05:00 PM • Revision'].map((x) => Card(child: ListTile(leading: const Icon(Icons.access_time), title: Text(x), subtitle: const Text('Planned study session'))))]);
  Widget profilePage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('Student Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 24), const Center(child: CircleAvatar(radius: 58, child: Icon(Icons.person, size: 70))), const SizedBox(height: 18), const Center(child: Text('Harshini Mandru', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))), const Center(child: Text('CSE • Student')), const SizedBox(height: 24), const Card(child: Column(children: [ListTile(title: Text('Department'), subtitle: Text('Computer Science and Engineering')), Divider(), ListTile(title: Text('College'), subtitle: Text('LBRCE')), Divider(), ListTile(title: Text('Goal'), subtitle: Text('Learn, build and grow'))]))]);
  Widget morePage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('More', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...['Notifications', 'Achievements', 'Help and Support', 'Settings'].map((x) => Card(child: ListTile(leading: const Icon(Icons.arrow_forward_ios), title: Text(x), trailing: const Icon(Icons.chevron_right))))]);

  void addTask() { final c = TextEditingController(); showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Add task'), content: TextField(controller: c, decoration: const InputDecoration(hintText: 'Task name')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { if (c.text.trim().isNotEmpty) setState(() { tasks.add(c.text.trim()); done.add(false); }); Navigator.pop(context); }, child: const Text('Add'))])); }
}
