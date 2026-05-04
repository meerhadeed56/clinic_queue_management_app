// lib/screens/my_ticket_screen.dart
// Screen 4: My Ticket tab — reads saved ticket from SharedPreferences (Lab 07)
// StatefulWidget because it loads async data on init (Lab 02)

import 'package:flutter/material.dart';
import '../models/clinic_model.dart';
import '../models/ticket_model.dart';
import '../utils/sample_data.dart';
import '../utils/app_theme.dart';
import '../utils/storage_helper.dart';
import 'live_status_screen.dart';

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  Ticket? _ticket;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTicket();
  }

  // Load saved ticket from SharedPreferences when screen opens (Lab 07)
  Future<void> _loadTicket() async {
    final ticket = await StorageHelper.loadTicket();
    setState(() {
      _ticket = ticket;
      _isLoading = false;
    });
  }

  // Find the matching clinic for the saved ticket
  Clinic? get _clinic {
    if (_ticket == null) return null;
    try {
      return sampleClinics.firstWhere((c) => c.id == _ticket!.clinicId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar (Lab 05)
      appBar: AppBar(
        title: const Text('My Ticket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTicket,
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ticket == null
              ? _buildNoTicketView()
              : _buildTicketView(),
    );
  }

  // ── No ticket ─────────────────────────────────────────────────────────────
  Widget _buildNoTicketView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined,
                size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'No Active Ticket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Go to the Clinics tab and take a token to see it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ── Ticket view ───────────────────────────────────────────────────────────
  Widget _buildTicketView() {
    final ticket = _ticket!;
    final clinic = _clinic;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Token card (styled like a physical ticket)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('QUEUE TOKEN',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              letterSpacing: 2)),
                      const SizedBox(height: 8),
                      Text(
                        '#${ticket.tokenNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ticket.clinicName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Dashed separator
                Row(
                  children: [
                    const SizedBox(width: 20, height: 20),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final dashCount = (constraints.maxWidth / 8).floor();
                          return Row(
                            children: List.generate(
                              dashCount,
                              (_) => Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20, height: 20),
                  ],
                ),

                // Bottom details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _TicketRow(
                          icon: Icons.person,
                          label: 'Patient',
                          value: ticket.patientName),
                      const Divider(height: 16),
                      _TicketRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: ticket.phone),
                      const Divider(height: 16),
                      _TicketRow(
                          icon: Icons.access_time,
                          label: 'Issued At',
                          value: _formatTime(ticket.issuedAt)),
                      const Divider(height: 16),
                      _TicketRow(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: clinic?.address ?? '—'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // View live status button
          if (clinic != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveStatusScreen(
                      ticket: ticket,
                      clinic: clinic,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.live_tv),
              label: const Text('View Live Queue Status'),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year}  $h:$m';
  }
}

class _TicketRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TicketRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryColor),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        const Spacer(),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}
