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
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState() => _HomePageState(); }
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int selected = 0;
  final tasks = <String>['Complete Flutter assignment', 'Revise Computer Networks'];
  @override void initState() { super.initState(); controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(); }
  @override void dispose() { controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF6F5FF),
    body: SafeArea(child: Row(children: [
      NavigationRail(selectedIndex: selected, onDestinationSelected: (v) => setState(() => selected = v), labelType: NavigationRailLabelType.all, backgroundColor: Colors.white, destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Home')),
        NavigationRailDestination(icon: Icon(Icons.task_alt), label: Text('Tasks')),
        NavigationRailDestination(icon: Icon(Icons.event), label: Text('Events')),
      ]),
      Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: selected == 0 ? dashboard() : selected == 1 ? taskPage() : eventPage()))
    ])),
    floatingActionButton: selected == 1 ? FloatingActionButton.extended(onPressed: addTask, icon: const Icon(Icons.add), label: const Text('Add task')) : null,
  );
  Widget dashboard() => SingleChildScrollView(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good morning, Harshini 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text('Your campus, your success.', style: TextStyle(color: Colors.black54))]), AnimatedBuilder(animation: controller, builder: (_, __) => Transform.rotate(angle: controller.value * math.pi * 2, child: const Icon(Icons.auto_awesome, size: 42, color: Color(0xFF6556E8))))]),
    const SizedBox(height: 28),
    Container(width: double.infinity, padding: const EdgeInsets.all(26), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6556E8), Color(0xFF9A7BFF)]), borderRadius: BorderRadius.circular(28), boxShadow: const [BoxShadow(blurRadius: 18, color: Color(0x226556E8))]), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CAMPUSCARE', style: TextStyle(color: Colors.white70, letterSpacing: 3)), SizedBox(height: 12), Text('Learn. Connect. Grow.', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Everything you need for a better college journey.', style: TextStyle(color: Colors.white70))])),
    const SizedBox(height: 26), const Text('Quick overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 14),
    Row(children: [stat('Tasks', '${tasks.length}', Icons.check_circle), stat('Events', '04', Icons.event), stat('Progress', '72%', Icons.trending_up)]),
    const SizedBox(height: 26), const Text('Today’s focus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12), ...tasks.map((t) => Card(child: ListTile(leading: const Icon(Icons.school, color: Color(0xFF6556E8)), title: Text(t), trailing: const Icon(Icons.arrow_forward_ios, size: 16))))
  ]));
  Widget stat(String title, String value, IconData icon) => Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Icon(icon, color: const Color(0xFF6556E8)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: Colors.black54))]))));
  Widget taskPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('My Tasks', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...tasks.asMap().entries.map((e) => Card(child: ListTile(title: Text(e.value), leading: const Icon(Icons.task_alt), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => tasks.removeAt(e.key))))))]);
  Widget eventPage() => ListView(padding: const EdgeInsets.all(28), children: [const Text('Campus Events', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ...['Flutter Forge 2026', 'Technical Fest', 'Project Expo', 'Career Guidance'].map((e) => Card(child: ListTile(leading: const Icon(Icons.event_available), title: Text(e), subtitle: const Text('Campus activity • Stay updated'))))]);
  void addTask() { final c = TextEditingController(); showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Add task'), content: TextField(controller: c, decoration: const InputDecoration(hintText: 'Task name')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { if (c.text.trim().isNotEmpty) setState(() => tasks.add(c.text.trim())); Navigator.pop(context); }, child: const Text('Add'))])); }
}
