import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const CampusCareApp());

class CampusCareApp extends StatelessWidget {
  const CampusCareApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CampusCare',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF6556E8), fontFamily: 'Arial'),
        home: const LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool hide = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6556E8), Color(0xFFB49BFF)])),
      child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430), child: Card(elevation: 16, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), child: Padding(padding: const EdgeInsets.all(28), child: Column(children: [
        const CircleAvatar(radius: 36, backgroundColor: Color(0xFFEAE5FF), child: Icon(Icons.school, size: 38, color: Color(0xFF6556E8))),
        const SizedBox(height: 18), const Text('Welcome to CampusCare', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8), const Text('Your smart student companion', style: TextStyle(color: Colors.black54)), const SizedBox(height: 28),
        TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())), const SizedBox(height: 16),
        TextField(controller: password, obscureText: hide, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(), suffixIcon: IconButton(onPressed: () => setState(() => hide = !hide), icon: Icon(hide ? Icons.visibility : Icons.visibility_off)))), const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())), icon: const Icon(Icons.login), label: const Padding(padding: EdgeInsets.all(14), child: Text('Continue')))),
        const SizedBox(height: 12), const Text('Demo login • Any email and password', style: TextStyle(fontSize: 12, color: Colors.black45))
      ]))))),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController rotate;
  late AnimationController pulse;
  int selected = 0;
  final tasks = <String>['Complete Flutter assignment', 'Revise Computer Networks'];
  final completed = <bool>[false, false];
  @override void initState() { super.initState(); rotate = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat(); pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2), lowerBound: .96, upperBound: 1.04)..repeat(reverse: true); }
  @override void dispose() { rotate.dispose(); pulse.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF6F5FF),
    body: SafeArea(child: Row(children: [
      NavigationRail(selectedIndex: selected, onDestinationSelected: (v) => setState(() => selected = v), labelType: NavigationRailLabelType.all, backgroundColor: Colors.white, destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Home')),
        NavigationRailDestination(icon: Icon(Icons.task_alt), selectedIcon: Icon(Icons.task_alt), label: Text('Tasks')),
        NavigationRailDestination(icon: Icon(Icons.calendar_month_outlined), label: Text('Planner')),
        NavigationRailDestination(icon: Icon(Icons.person_outline), label: Text('Profile')),
        NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text('More')),
      ]),
      Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: page()))
    ])),
    floatingActionButton: selected == 1 ? FloatingActionButton.extended(onPressed: addTask, icon: const Icon(Icons.add), label: const Text('Add task')) : null,
  );
  Widget page() { switch (selected) { case 1: return taskPage(); case 2: return plannerPage(); case 3: return profilePage(); case 4: return morePage(); default: return dashboard(); } }
  Widget dashboard() => SingleChildScrollView(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good morning, Harshini 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text('Your campus, your success.', style: TextStyle(color: Colors.black54))]), AnimatedBuilder(animation: rotate, builder: (_, __) => Transform.rotate(angle: rotate.value * math.pi * 2, child: const Icon(Icons.auto_awesome, size: 42, color: Color(0xFF6556E8))))]),
    const SizedBox(height: 28), ScaleTransition(scale: pulse, child: Container(width: double.infinity, padding: const EdgeInsets.all(26), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6556E8), Color(0xFF9A7BFF)]), borderRadius: BorderRadius.circular(28), boxShadow: const [BoxShadow(blurRadius: 18, color: Color(0x226556E8))]), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CAMPUSCARE', style: TextStyle(color: Colors.white70, letterSpacing: 3)), SizedBox(height: 12), Text('Learn. Connect. Grow.', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Everything you need for a better college journey.', style: TextStyle(color: Colors.white70))]))),
    const SizedBox(height: 26), const Text('Quick overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 14), Row(children: [stat('Tasks', '${tasks.length}', Icons.check_circle), stat('Events', '04', Icons.event), stat('Progress', '${completed.where((x) => x).length * 25 + 22}%', Icons.trending_up)]),
    const SizedBox(height: 26), const Text('Today’s focus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12), ...tasks.asMap().entries.map((e) => Card(child: CheckboxListTile(value: completed[e.key], onChanged: (v) => setState(() => completed[e.key] = v ?? false), title: Text(e.value, style: TextStyle(decoration: completed[e.key] ? TextDecoration.lineThrough : null)), secondary: const Icon(Icons.school, color: Color(0xFF6556E8)))))
  ]));
  Widget stat(String title, String value, IconData icon) => Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Icon(icon, color: const Color(0xFF6556E8)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: Colors.black54))]))));
  Widget taskPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('My Tasks', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...tasks.asMap().entries.map((e) => Card(child: ListTile(title: Text(e.value), leading: Icon(completed[e.key] ? Icons.check_circle : Icons.task_alt), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() { tasks.removeAt(e.key); completed.removeAt(e.key); }))))) ]);
  Widget plannerPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('Study Planner', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...['08:00 AM  •  Data Structures', '10:00 AM  •  Database Management', '02:00 PM  •  Flutter practice', '05:00 PM  •  Revision and quiz'].map((e) => Card(child: ListTile(leading: const Icon(Icons.access_time, color: Color(0xFF6556E8)), title: Text(e), subtitle: const Text('Planned study session'))))]);
  Widget profilePage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('Student Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 24), const Center(child: CircleAvatar(radius: 58, child: Icon(Icons.person, size: 70))), const SizedBox(height: 18), const Center(child: Text('Harshini Mandru', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))), const Center(child: Text('CSE • Student', style: TextStyle(color: Colors.black54))), const SizedBox(height: 24), Card(child: Column(children: const [ListTile(leading: Icon(Icons.school), title: Text('Department'), subtitle: Text('Computer Science and Engineering')), Divider(), ListTile(leading: Icon(Icons.location_city), title: Text('College'), subtitle: Text('LBRCE')), Divider(), ListTile(leading: Icon(Icons.star_outline), title: Text('Goal'), subtitle: Text('Learn, build and grow'))]))]);
  Widget morePage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('More', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...[['Notifications', Icons.notifications_none], ['Achievements', Icons.emoji_events_outlined], ['Help and Support', Icons.help_outline], ['Settings', Icons.settings_outlined]].map((e) => Card(child: ListTile(leading: Icon(e[1] as IconData, color: const Color(0xFF6556E8)), title: Text(e[0] as String), trailing: const Icon(Icons.chevron_right))))]);
  void addTask() { final c = TextEditingController(); showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Add task'), content: TextField(controller: c, decoration: const InputDecoration(hintText: 'Task name')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { if (c.text.trim().isNotEmpty) setState(() { tasks.add(c.text.trim()); completed.add(false); }); Navigator.pop(context); }, child: const Text('Add'))])); }
}
