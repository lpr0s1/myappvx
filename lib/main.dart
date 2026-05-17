import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111111),
          elevation: 2,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final pages = const [
    HomePage(),
    ToolsPage(),
    VersionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: pages[index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.blue),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal, color: Colors.red),
            label: 'Outils',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info, color: Colors.green),
            label: 'Version',
          ),
        ],
      ),
    );
  }
}

//
// PAGE ACCUEIL
//
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VxKit - Accueil")),
      body: const Center(
        child: Text(
          "Bienvenue dans VxKit\nVotre kit de commandes Pentest",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

//
// PAGE OUTILS
//
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commandes Pentest")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PentestCard(
            title: "Nmap",
            command: "nmap -sV -A <cible>",
            color: Colors.blue,
          ),
          PentestCard(
            title: "Hydra",
            command: "hydra -l admin -P wordlist.txt <cible> ssh",
            color: Colors.red,
          ),
          PentestCard(
            title: "Metasploit",
            command: "msfconsole",
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class PentestCard extends StatelessWidget {
  final String title;
  final String command;
  final Color color;

  const PentestCard({
    super.key,
    required this.title,
    required this.command,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A1A),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.code, color: color),
        title: Text(title, style: TextStyle(color: color)),
        subtitle: Text(command),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

//
// PAGE VERSION
//
class VersionPage extends StatelessWidget {
  const VersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Version")),
      body: const Center(
        child: Text(
          "VxKit - Version 1.0.0",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
