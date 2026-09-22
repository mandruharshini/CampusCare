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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF6556E8)),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6556E8), Color(0xFFB49BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const CircleAvatar(radius: 38, child: Icon(Icons.school, size: 40)),
                      const SizedBox(height: 18),
                      const Text('Welcome to CampusCare', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Your smart student companion'),
                      const SizedBox(height: 28),
                      TextField(controller: email, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      TextField(controller: password, obscureText: hidden, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(), suffixIcon: IconButton(onPressed: () => setState(() => hidden = !hidden), icon: Icon(hidden ? Icons.visibility : Icons.visibility_off)))),
                      const SizedBox(height: 24),
                      SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())), icon: const Icon(Icons.login), label: const Text('Continue'))),
                      const SizedBox(height: 12),
                      const Text('Demo login • Any email and password', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController rotation;
  late final AnimationController pulse;
  int selected = 0;
  final tasks = <String>['Complete Flutter assignment', 'Revise Computer Networks'];
  final completed = <bool>[false, false];

  @override
  void initState() {
    super.initState();
    rotation = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2), lowerBound: .96, upperBound: 1.04)..repeat(reverse: true);
  }

  @override
  void dispose() {
    rotation.dispose();
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FF),
      body: SafeArea(child: Row(children: [
        NavigationRail(
          selectedIndex: selected,
          labelType: NavigationRailLabelType.all,
          onDestinationSelected: (value) => setState(() => selected = value),
          destinations: const [
            NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Home')),
            NavigationRailDestination(icon: Icon(Icons.task_alt), label: Text('Tasks')),
            NavigationRailDestination(icon: Icon(Icons.calendar_month), label: Text('Planner')),
            NavigationRailDestination(icon: Icon(Icons.person_outline), label: Text('Profile')),
            NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text('More')),
          ],
        ),
        Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: page())),
      ])),
      floatingActionButton: selected == 1 ? FloatingActionButton.extended(onPressed: addTask, icon: const Icon(Icons.add), label: const Text('Add task')) : null,
    );
  }

  Widget page() {
    switch (selected) {
      case 1: return taskPage();
      case 2: return plannerPage();
      case 3: return profilePage();
      case 4: return morePage();
      default: return dashboard();
    }
  }

  Widget dashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good morning, Harshini 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text('Your campus, your success.')])),
          AnimatedBuilder(animation: rotation, builder: (_, __) => Transform.rotate(angle: rotation.value * math.pi * 2, child: const Icon(Icons.auto_awesome, size: 40))),
        ]),
        const SizedBox(height: 28),
        ScaleTransition(scale: pulse, child: Container(width: double.infinity, padding: const EdgeInsets.all(26), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6556E8), Color(0xFF9A7BFF)]), borderRadius: BorderRadius.circular(28)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CAMPUSCARE', style: TextStyle(color: Colors.white70, letterSpacing: 3)), SizedBox(height: 12), Text('Learn. Connect. Grow.', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Everything you need for a better college journey.', style: TextStyle(color: Colors.white70))]))),
        const SizedBox(height: 26),
        const Text('Quick overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        Row(children: [stat('Tasks', '${tasks.length}', Icons.check_circle), stat('Events', '04', Icons.event), stat('Progress', '${completed.where((x) => x).length * 25 + 22}%', Icons.trending_up)]),
        const SizedBox(height: 26),
        const Text('Today’s focus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...tasks.asMap().entries.map((entry) => Card(child: CheckboxListTile(value: completed[entry.key], onChanged: (value) => setState(() => completed[entry.key] = value ?? false), title: Text(entry.value, style: TextStyle(decoration: completed[entry.key] ? TextDecoration.lineThrough : null)), secondary: const Icon(Icons.school)))),
      ]),
    );
  }

  Widget stat(String title, String value, IconData icon) => Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Icon(icon), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(title)]))));

  Widget taskPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('My Tasks', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...tasks.asMap().entries.map((entry) => Card(child: ListTile(title: Text(entry.value), leading: Icon(completed[entry.key] ? Icons.check_circle : Icons.task_alt), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() { tasks.removeAt(entry.key); completed.removeAt(entry.key); })))))]);

  Widget plannerPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('Study Planner', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...['08:00 AM • Data Structures', '10:00 AM • Database Management', '02:00 PM • Flutter practice', '05:00 PM • Revision and quiz'].map((item) => Card(child: ListTile(leading: const Icon(Icons.access_time), title: Text(item), subtitle: const Text('Planned study session'))))]);

  Widget profilePage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('Student Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 24), const Center(child: CircleAvatar(radius: 58, child: Icon(Icons.person, size: 70))), const SizedBox(height: 18), const Center(child: Text('Harshini Mandru', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))), const Center(child: Text('CSE • Student')), const SizedBox(height: 24), Card(child: Column(children: const [ListTile(leading: Icon(Icons.school), title: Text('Department'), subtitle: Text('Computer Science and Engineering')), Divider(), ListTile(leading: Icon(Icons.location_city), title: Text('College'), subtitle: Text('LBRCE')), Divider(), ListTile(leading: Icon(Icons.star_outline), title: Text('Goal'), subtitle: Text('Learn, build and grow'))]))]);

  Widget morePage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('More', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...['Notifications', 'Achievements', 'Help and Support', 'Settings'].map((item) => Card(child: ListTile(leading: const Icon(Icons.arrow_forward_ios), title: Text(item), trailing: const Icon(Icons.chevron_right))))]);

  void addTask() {
    final controller = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Add task'), content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Task name')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { if (controller.text.trim().isNotEmpty) setState(() { tasks.add(controller.text.trim()); completed.add(false); }); Navigator.pop(context); }, child: const Text('Add'))]));
  }
}
