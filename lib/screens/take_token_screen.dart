// lib/screens/take_token_screen.dart
// Screen 2: Take a queue token — Form + GlobalKey + Validators (Lab 06)
// StatefulWidget because form has local state (Lab 02)

import 'package:flutter/material.dart';
import '../models/clinic_model.dart';
import '../models/ticket_model.dart';
import '../utils/app_theme.dart';
import '../utils/storage_helper.dart';
import 'live_status_screen.dart';

class TakeTokenScreen extends StatefulWidget {
  final Clinic clinic;

  const TakeTokenScreen({super.key, required this.clinic});

  @override
  State<TakeTokenScreen> createState() => _TakeTokenScreenState();
}

class _TakeTokenScreenState extends State<TakeTokenScreen> {
  // GlobalKey to control the Form (Lab 06)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingControllers to read field values (Lab 06)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // Always dispose controllers to avoid memory leaks (Lab 06)
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Generates the next token number (currentToken + totalInQueue + 1)
  int get _nextToken =>
      widget.clinic.currentToken + widget.clinic.totalInQueue + 1;

  Future<void> _submitForm() async {
    // Validate all fields using GlobalKey (Lab 06)
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Build the ticket object
    final ticket = Ticket(
      clinicId: widget.clinic.id,
      clinicName: widget.clinic.name,
      tokenNumber: _nextToken,
      patientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      issuedAt: DateTime.now(),
    );

    // Save ticket to SharedPreferences (Lab 07)
    await StorageHelper.saveTicket(ticket);

    setState(() => _isLoading = false);

    if (!mounted) return;

    // Navigate to Live Status, passing ticket + clinic (Lab 03)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LiveStatusScreen(
          ticket: ticket,
          clinic: widget.clinic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar showing clinic name (Lab 05)
      appBar: AppBar(
        title: Text(widget.clinic.name),
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.clinic.totalInQueue} waiting',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital,
                      color: AppTheme.primaryColor, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.clinic.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.clinic.specialty,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        Text(
                          widget.clinic.address,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '#$_nextToken',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const Text('Your token',
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Enter your details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Required to generate your token',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 20),

            // ── FORM (Lab 06) ──────────────────────────────────────────────
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Patient name field
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'e.g. Ali Hassan',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    // Validator (Lab 06)
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null; // null means valid
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone number field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'e.g. 0300-1234567',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    // Validator (Lab 06)
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      final digits = value.replaceAll(RegExp(r'\D'), '');
                      if (digits.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Submit button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.confirmation_number_outlined),
                          label: const Text('Generate Token'),
                        ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ETA preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.accentColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time,
                      color: AppTheme.accentColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Estimated wait: ~${widget.clinic.etaForToken(_nextToken)} minutes',
                      style: const TextStyle(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
