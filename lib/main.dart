// lib/main.dart
// App entry point — CurvedNavigationBar shell (Lab 04)
// Uses IndexedStack to preserve screen state across tabs

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'utils/app_theme.dart';
import 'screens/clinics_screen.dart';
import 'screens/my_ticket_screen.dart';

void main() {
  runApp(const ClinicQueueApp());
}

class ClinicQueueApp extends StatelessWidget {
  const ClinicQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic Queue',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainShell(),
    );
  }
}

// ── Main shell with bottom navigation (Lab 04) ────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Track the active tab index (Lab 04)
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = const [
    ClinicsScreen(),
    MyTicketScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all screens in memory, preserving state (Lab 04)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // CurvedNavigationBar (Lab 04 — third-party package)
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        backgroundColor: AppTheme.surfaceColor,
        color: AppTheme.primaryColor,
        buttonBackgroundColor: AppTheme.primaryColor,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // setState updates the selected tab (Lab 02)
          });
        },
        items: const [
          Icon(Icons.local_hospital, size: 26, color: Colors.white),
          Icon(Icons.confirmation_number, size: 26, color: Colors.white),
        ],
      ),
    );
  }
}
