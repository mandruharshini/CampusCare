import 'package:flutter/material.dart';

void main() => runApp(const CampusCareApp());

class CampusCareApp extends StatelessWidget {
  const CampusCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusCare',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF0E7490)),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isRegister = false;
  bool hidePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        (isRegister && nameController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (isRegister) {
      setState(() => isRegister = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF083344), Color(0xFF0E7490), Color(0xFF67E8F9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 18,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 44,
                      backgroundColor: Color(0xFFE0F2FE),
                      child: Icon(Icons.school, size: 48, color: Color(0xFF0E7490)),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isRegister ? 'Create your account' : 'Welcome back!',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(isRegister ? 'Join your campus journey' : 'Your smart student companion'),
                    const SizedBox(height: 24),
                    if (isRegister) ...[
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => hidePassword = !hidePassword),
                          icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: submit,
                        icon: Icon(isRegister ? Icons.person_add : Icons.login),
                        label: Text(isRegister ? 'Register' : 'Login'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() => isRegister = !isRegister),
                      child: Text(isRegister ? 'Already have an account? Login' : 'New user? Register'),
                    ),
                    const Text('Demo app • No real account is created', style: TextStyle(fontSize: 12)),
                  ],
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

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final tasks = <String>['Complete Flutter assignment', 'Revise Computer Networks'];
  final completed = <bool>[false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (index) => setState(() => selectedIndex = index),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.task), label: Text('Tasks')),
                NavigationRailDestination(icon: Icon(Icons.calendar_month), label: Text('Planner')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
                NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text('More')),
              ],
            ),
            Expanded(child: _page()),
          ],
        ),
      ),
      floatingActionButton: selectedIndex == 1
          ? FloatingActionButton.extended(onPressed: addTask, icon: const Icon(Icons.add), label: const Text('Add task'))
          : null,
    );
  }

  Widget _page() {
    switch (selectedIndex) {
      case 1:
        return taskPage();
      case 2:
        return simplePage('Study Planner', ['08:00 AM • Data Structures', '10:00 AM • DBMS', '02:00 PM • Flutter practice']);
      case 3:
        return simplePage('Student Profile', ['Name: Harshini Mandru', 'Department: CSE', 'College: LBRCE']);
      case 4:
        return simplePage('More', ['Notifications', 'Achievements', 'Help and Support', 'Settings']);
      default:
        return dashboard();
    }
  }

  Widget dashboard() {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const Text('Good morning, Harshini 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Your campus, your success.'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0E7490), Color(0xFF14B8A6)]),
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('CAMPUSCARE', style: TextStyle(color: Colors.white70, letterSpacing: 3)),
            SizedBox(height: 12),
            Text('Learn. Connect. Grow.', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 24),
        const Text('Today’s focus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...tasks.asMap().entries.map((entry) => CheckboxListTile(
              value: completed[entry.key],
              onChanged: (value) => setState(() => completed[entry.key] = value ?? false),
              title: Text(entry.value),
            )),
      ],
    );
  }

  Widget taskPage() {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const Text('My Tasks', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ...tasks.asMap().entries.map((entry) => Card(
              child: ListTile(
                title: Text(entry.value),
                leading: Icon(completed[entry.key] ? Icons.check_circle : Icons.task_alt),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => setState(() {
                    tasks.removeAt(entry.key);
                    completed.removeAt(entry.key);
                  }),
                ),
              ),
            )),
      ],
    );
  }

  Widget simplePage(String title, List<String> items) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ...items.map((item) => Card(child: ListTile(title: Text(item)))),
      ],
    );
  }

  void addTask() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add task'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Task name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  tasks.add(controller.text.trim());
                  completed.add(false);
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
