
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
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
    const ExternalMoviesPage(),
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
            NavigationDestination(icon: Icon(Icons.home_filled), label: 'Accueil'),
            NavigationDestination(icon: Icon(Icons.terminal), label: 'Outils'),
            NavigationDestination(icon: Icon(Icons.movie_filter), label: 'Films'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Réglages'),
          ],
        ),
      ),
    );
  }
}

// --- COMPOSANT DESIGN: GLASS CARD ---
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

// --- PAGE: ACCUEIL ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text("VXKIT", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 5)),
            Text("DÉVELOPPÉ PAR HX", style: TextStyle(color: Colors.white54, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }
}

// --- PAGE: OUTILS ---
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PENTEST KIT"), backgroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ToolActionCard(title: "Nmap", cmd: "nmap -sV -A <ip>", desc: "Scanner réseau complet"),
          ToolActionCard(title: "Metasploit", cmd: "msfconsole", desc: "Framework d'exploitation"),
          ToolActionCard(title: "SQLMap", cmd: "sqlmap -u <url> --batch", desc: "Injection SQL automatique"),
          ToolActionCard(title: "John", cmd: "john --wordlist=rockyou.txt hash", desc: "Craqueur de mots de passe"),
        ],
      ),
    );
  }
}

class ToolActionCard extends StatelessWidget {
  final String title, cmd, desc;
  const ToolActionCard({super.key, required this.title, required this.cmd, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                      child: Text(cmd, style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent, fontSize: 13)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20, color: Colors.white70),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: cmd));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copié !"), duration: Duration(seconds: 1)),
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

// --- PAGE: MOVIES (BOUTON LIEN EXTERNE) ---
class ExternalMoviesPage extends StatelessWidget {
  const ExternalMoviesPage({super.key});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://hvxsrc.online/v/m');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible d\'ouvrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.movie_outlined, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  "ACCÉDER AU STREAMING",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Le contenu sera ouvert dans votre navigateur pour une meilleure expérience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _launchURL,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("OUVRIR LE SITE"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

// --- PAGE: RÉGLAGES ---
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SYSTÈME"), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const GlassCard(
              child: ListTile(
                leading: Icon(Icons.person_pin),
                title: Text("Développeur"),
                subtitle: Text("Hx"),
              ),
            ),
            const SizedBox(height: 12),
            const GlassCard(
              child: ListTile(
                leading: Icon(Icons.verified_user_outlined),
                title: Text("Version de l'application"),
                subtitle: Text("1.0.0-PRO"),
              ),
            ),
            const Spacer(),
            Text("VXKIT © 2024", style: TextStyle(color: Colors.white.withOpacity(0.2), letterSpacing: 3)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
