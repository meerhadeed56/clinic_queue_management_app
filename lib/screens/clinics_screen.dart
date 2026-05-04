// lib/screens/clinics_screen.dart
// Screen 1: Browse all clinics — uses ListView.builder (Lab 08)
// StatelessWidget because it just displays fixed data (Lab 02)

import 'package:flutter/material.dart';
import '../models/clinic_model.dart';
import '../utils/sample_data.dart';
import '../utils/app_theme.dart';
import 'take_token_screen.dart';

class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom AppBar with actions (Lab 05)
      appBar: AppBar(
        title: const Text('Clinics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search clinics',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Clinic Queue',
                applicationVersion: '1.0.0',
                children: [
                  const Text(
                      'Semester Project — Mobile App Development\nBBSUL Spring 2026'),
                ],
              );
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner
          Container(
            width: double.infinity,
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a Clinic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap any clinic to take a queue token',
                  style: TextStyle(color: Color(0xFFBBDEFB), fontSize: 13),
                ),
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatChip(
                  icon: Icons.local_hospital,
                  label: '${sampleClinics.length} Clinics',
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 10),
                _StatChip(
                  icon: Icons.people,
                  label:
                      '${sampleClinics.fold(0, (s, c) => s + c.totalInQueue)} Waiting',
                  color: AppTheme.accentColor,
                ),
              ],
            ),
          ),

          // Clinic list — ListView.builder (Lab 08)
          Expanded(
            child: ListView.builder(
              itemCount: sampleClinics.length,
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final clinic = sampleClinics[index];
                return _ClinicCard(clinic: clinic);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Clinic Card Widget ────────────────────────────────────────────────────────
class _ClinicCard extends StatelessWidget {
  final Clinic clinic;
  const _ClinicCard({required this.clinic});

  @override
  Widget build(BuildContext context) {
    final queueColor = clinic.totalInQueue < 5
        ? AppTheme.successColor
        : clinic.totalInQueue < 10
            ? AppTheme.warningColor
            : AppTheme.dangerColor;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to Take Token screen, passing clinic data (Lab 03)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakeTokenScreen(clinic: clinic),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Clinic icon updated to use local image asset
              const CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('assets/images/clinic_icon.png'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 14),

              // Clinic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      clinic.specialty,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Text(
                          clinic.address,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Queue status badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: queueColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: queueColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${clinic.totalInQueue} waiting',
                      style: TextStyle(
                        color: queueColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Now: #${clinic.currentToken}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '~${clinic.avgMinutesPerToken} min/token',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small stat chip ───────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
