// lib/screens/live_status_screen.dart
// Screen 3: Live queue status — StatefulWidget + setState (Lab 02)
// Shows current token, user's token, ETA, and people ahead in queue

import 'package:flutter/material.dart';
import '../models/clinic_model.dart';
import '../models/ticket_model.dart';
import '../utils/app_theme.dart';
import '../utils/storage_helper.dart';
import 'clinics_screen.dart';

class LiveStatusScreen extends StatefulWidget {
  final Ticket ticket;
  final Clinic clinic;

  const LiveStatusScreen({
    super.key,
    required this.ticket,
    required this.clinic,
  });

  @override
  State<LiveStatusScreen> createState() => _LiveStatusScreenState();
}

class _LiveStatusScreenState extends State<LiveStatusScreen> {
  // Local state — changes trigger UI rebuild via setState() (Lab 02)
  late int _currentToken;
  late int _totalInQueue;

  @override
  void initState() {
    super.initState();
    _currentToken = widget.clinic.currentToken;
    _totalInQueue = widget.clinic.totalInQueue;
  }

  // People ahead of the user
  int get _ahead {
    final diff = widget.ticket.tokenNumber - _currentToken - 1;
    return diff < 0 ? 0 : diff;
  }

  // ETA for the user
  int get _eta {
    return _ahead * widget.clinic.avgMinutesPerToken;
  }

  // Is it the user's turn?
  bool get _isMyTurn => _currentToken >= widget.ticket.tokenNumber;

  // Simulate admin calling the next patient (demo button)
  void _advanceQueue() {
    if (_currentToken >= widget.ticket.tokenNumber + 3) return;
    setState(() {
      _currentToken++;
      if (_totalInQueue > 0) _totalInQueue--;
    });
  }

  // Cancel ticket and go back to clinics list
  Future<void> _cancelTicket() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Ticket?'),
        content: const Text(
            'Your token will be cancelled. You will lose your position in the queue.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep My Spot')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: const Text('Cancel Ticket'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageHelper.clearTicket();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ClinicsScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with clinic name and notification icon (Lab 05)
      appBar: AppBar(
        title: Text(widget.clinic.name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('You will be notified when your turn nears')),
              );
            },
          ),
        ],
      ),

      body: _isMyTurn ? _buildMyTurnView() : _buildWaitingView(),

      // Demo admin button at the bottom
      bottomNavigationBar: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '— Demo Controls —',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed: _advanceQueue,
              icon: const Icon(Icons.skip_next, size: 18),
              label: const Text('Next Patient (Admin Simulation)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Waiting view ──────────────────────────────────────────────────────────
  Widget _buildWaitingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // My token card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withBlue(220),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text('Your Token Number',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Text(
                  '#${widget.ticket.tokenNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.ticket.patientName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Status row
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  label: 'Now Serving',
                  value: '#$_currentToken',
                  icon: Icons.record_voice_over,
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  label: 'Ahead of You',
                  value: '$_ahead people',
                  icon: Icons.people,
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ETA card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.accentColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_filled,
                    color: AppTheme.accentColor, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estimated Wait',
                        style: TextStyle(
                            color: AppTheme.accentColor, fontSize: 12)),
                    Text(
                      _eta == 0 ? 'Almost your turn!' : '~$_eta minutes',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Queue ahead — ListView.builder (Lab 08)
          if (_ahead > 0) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Queue ahead of you',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ahead > 5 ? 5 : _ahead,
              itemBuilder: (context, index) {
                final token = _currentToken + index + 1;
                return _QueueItem(
                  token: token,
                  isNext: index == 0,
                );
              },
            ),
            if (_ahead > 5)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '... and ${_ahead - 5} more',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
          ],

          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _cancelTicket,
            icon:
                const Icon(Icons.cancel_outlined, color: AppTheme.dangerColor),
            label: const Text('Cancel My Ticket'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.dangerColor,
              side: const BorderSide(color: AppTheme.dangerColor),
              minimumSize: const Size(double.infinity, 46),
            ),
          ),
        ],
      ),
    );
  }

  // ── My turn view ──────────────────────────────────────────────────────────
  Widget _buildMyTurnView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                color: AppTheme.successColor, size: 80),
            const SizedBox(height: 20),
            const Text(
              "It's Your Turn!",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Token #${widget.ticket.tokenNumber} is now being called',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please proceed to ${widget.clinic.name}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await StorageHelper.clearTicket();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ClinicsScreen()),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.home),
              label: const Text('Back to Clinics'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable info card ────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ── Queue item row ────────────────────────────────────────────────────────────
class _QueueItem extends StatelessWidget {
  final int token;
  final bool isNext;

  const _QueueItem({required this.token, required this.isNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isNext
            ? AppTheme.warningColor.withValues(alpha: 0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNext
              ? AppTheme.warningColor.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isNext
                  ? AppTheme.warningColor.withValues(alpha: 0.15)
                  : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$token',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isNext ? AppTheme.warningColor : Colors.grey[700],
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isNext ? 'Next in line' : 'Waiting',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const Spacer(),
          if (isNext)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.warningColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('NEXT',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
