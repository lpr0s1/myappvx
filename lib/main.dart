
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:ui';

void main() {
  runApp(const VxKitApp());
}

class VxKitApp extends StatelessWidget {
  const VxKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VxKit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
          surface: Color(0xFF121212),
        ),
        useMaterial3: true,
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

  final pages = [
    const HomePage(),
    const ToolsPage(),
    const MoviesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.black,
          indicatorColor: Colors.white.withOpacity(0.1),
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.terminal), label: 'Tools'),
            NavigationDestination(icon: Icon(Icons.movie_creation_outlined), label: 'Movies'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

// --- DESIGN COMPONENT: GLASS CARD ---
class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// --- PAGE: HOME ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text("VXKIT", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 5)),
            Text("BY HX", style: TextStyle(color: Colors.white.withOpacity(0.5), letterSpacing: 2)),
          ],
        ),
      ),
    );
  }
}

// --- PAGE: TOOLS ---
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PENTEST TOOLS"), backgroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ToolActionCard(title: "Nmap", cmd: "pkg install nmap && nmap -Pn <ip>"),
          ToolActionCard(title: "Metasploit", cmd: "pkg install metasploit"),
          ToolActionCard(title: "SQLMap", cmd: "git clone https://github.com/sqlmapproject/sqlmap.git"),
          ToolActionCard(title: "Sherlock", cmd: "python3 sherlock <username>"),
        ],
      ),
    );
  }
}

class ToolActionCard extends StatelessWidget {
  final String title, cmd;
  const ToolActionCard({super.key, required this.title, required this.cmd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                      child: Text(cmd, style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: cmd));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Commande copiée !"), duration: Duration(seconds: 1)),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- PAGE: MOVIES (WEBVIEW) ---
class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});
  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse('https://hvxsrc.online/v/m'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MOVIES"), backgroundColor: Colors.black),
      body: WebViewWidget(controller: controller),
    );
  }
}

// --- PAGE: SETTINGS ---
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PARAMÈTRES"), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const GlassCard(
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("Développeur"),
                subtitle: Text("Hx"),
              ),
            ),
            const SizedBox(height: 12),
            const GlassCard(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Version"),
                subtitle: Text("1.0.0 Stable"),
              ),
            ),
            const Spacer(),
            Text("VXKIT © 2024", style: TextStyle(color: Colors.white.withOpacity(0.2))),
          ],
        ),
      ),
    );
  }
}

