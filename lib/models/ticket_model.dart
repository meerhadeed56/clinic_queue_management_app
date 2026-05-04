// lib/models/ticket_model.dart
// Data model for a generated queue ticket

class Ticket {
  final String clinicId;
  final String clinicName;
  final int tokenNumber;
  final String patientName;
  final String phone;
  final DateTime issuedAt;

  const Ticket({
    required this.clinicId,
    required this.clinicName,
    required this.tokenNumber,
    required this.patientName,
    required this.phone,
    required this.issuedAt,
  });

  // Convert to Map for SharedPreferences storage (Lab 07)
  Map<String, dynamic> toMap() {
    return {
      'clinicId': clinicId,
      'clinicName': clinicName,
      'tokenNumber': tokenNumber,
      'patientName': patientName,
      'phone': phone,
      'issuedAt': issuedAt.toIso8601String(),
    };
  }

  // Create from Map when loading from SharedPreferences (Lab 07)
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      clinicId: map['clinicId'] as String,
      clinicName: map['clinicName'] as String,
      tokenNumber: map['tokenNumber'] as int,
      patientName: map['patientName'] as String,
      phone: map['phone'] as String,
      issuedAt: DateTime.parse(map['issuedAt'] as String),
    );
  }
}
