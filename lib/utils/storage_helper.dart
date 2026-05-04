// lib/utils/storage_helper.dart
// SharedPreferences wrapper for saving/loading the user's ticket (Lab 07)

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket_model.dart';

class StorageHelper {
  static const String _ticketKey = 'saved_ticket';

  // Save ticket to local storage
  static Future<void> saveTicket(Ticket ticket) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(ticket.toMap());
    await prefs.setString(_ticketKey, encoded);
  }

  // Load ticket from local storage (returns null if none saved)
  static Future<Ticket?> loadTicket() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_ticketKey);
    if (encoded == null) return null;
    try {
      final map = jsonDecode(encoded) as Map<String, dynamic>;
      return Ticket.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  // Clear ticket from local storage (when user cancels / ticket expires)
  static Future<void> clearTicket() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ticketKey);
  }

  // Check if a ticket exists
  static Future<bool> hasTicket() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_ticketKey);
  }
}
