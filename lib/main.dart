
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        scaffoldBackgroundColor: const Color(0xFF050505),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
          surface: Color(0xFF0F0F0F),
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
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5)),
        ),
        child: NavigationBar(
          backgroundColor: const Color(0xFF050505),
          indicatorColor: Colors.white.withOpacity(0.08),
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

// --- DESIGN DE BASE: LE LIQUID GLASS CARD ---
class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.01),
              ],
            ),
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
            const Icon(Icons.security, size: 90, color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              "VXKIT",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Text(
                "DEVELOPED BY HX",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PAGE: TOOLS (REFACTORISÉE AVEC COPIER ET SCROLL) ---
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PENTEST SUITE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        backgroundColor: const Color(0xFF050505),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ToolActionCard(
            title: "Nmap",
            desc: "Scanner de ports et de services réseau",
            cmd: "pkg install nmap && nmap -sV -p 1-65535 <cible>",
          ),
          ToolActionCard(
            title: "Hydra",
            desc: "Brute force multi-protocoles ultra rapide",
            cmd: "hydra -l admin -P passwords.txt ssh://<cible>",
          ),
          ToolActionCard(
            title: "SQLMap",
            desc: "Détection automatique d'injections SQL",
            cmd: "git clone https://github.com/sqlmapproject/sqlmap.git",
          ),
          ToolActionCard(
            title: "Metasploit",
            desc: "Outil complet de pénétration et d'exploitation",
            cmd: "curl -LO https://raw.githubusercontent.com/Termux-pod/termux-pod/main/msf.sh && bash msf.sh",
          ),
        ],
      ),
    );
  }
}

class ToolActionCard extends StatelessWidget {
  final String title, desc, cmd;
  const ToolActionCard({super.key, required this.title, required this.desc, required this.cmd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Text(
                        cmd,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.white.withOpacity(0.08)),
                    ),
                  ),
                  icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: cmd));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        content: const Text(
                          "Commande copiée !",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
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

// --- PAGE: MOVIES (NATIVE SANS WEBVIEW) ---
class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MOVIES & LINKS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        backgroundColor: const Color(0xFF050505),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // En-tête de la page
          GlassCard(
            child: Column(
              children: [
                const Icon(Icons.movie_filter_outlined, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  "Serveur de Streaming",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  "Accédez à vos flux multimédias.",
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: const Text(
                          "https://hvxsrc.online/v/m",
                          style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: "https://hvxsrc.online/v/m"));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Lien copié !")),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "SOURCES DISPONIBLES",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          const MovieSourceCard(title: "Main Server (hvxsrc)", url: "https://hvxsrc.online/v/m", ping: "FAST"),
          const MovieSourceCard(title: "Backup Server", url: "https://hvxsrc.online/v/m?backup=true", ping: "NORMAL"),
        ],
      ),
    );
  }
}

class MovieSourceCard extends StatelessWidget {
  final String title, url, ping;
  const MovieSourceCard({super.key, required this.title, required this.url, required this.ping});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.dns_outlined, color: Colors.white),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(url, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ping == "FAST" ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              ping,
              style: TextStyle(
                color: ping == "FAST" ? Colors.greenAccent : Colors.amberAccent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Clipboard.setData(ClipboardData(text: url));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lien du serveur '$title' copié !")),
            );
          },
        ),
      ),
    );
  }
}

// --- PAGE: SETTINGS ---
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SETTINGS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        backgroundColor: const Color(0xFF050505),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const GlassCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person_outline, color: Colors.white),
                title: Text("Développeur", style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text("Hx", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 12),
            const GlassCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline, color: Colors.white),
                title: Text("Version", style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text("1.0.0 Stable", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
            ),
            const Spacer(),
            Text(
              "VXKIT SYSTEM © 2026",
              style: TextStyle(color: Colors.white.withOpacity(0.15), fontSize: 10, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}