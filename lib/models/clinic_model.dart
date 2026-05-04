// lib/models/clinic_model.dart
// Data model for a clinic (Lab 02 concept: plain Dart class used across StatelessWidgets)

class Clinic {
  final String id;
  final String name;
  final String address;
  final String specialty;
  final int currentToken; // token currently being served
  final int totalInQueue; // total people waiting
  final int avgMinutesPerToken; // average service time per token

  const Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.specialty,
    required this.currentToken,
    required this.totalInQueue,
    required this.avgMinutesPerToken,
  });

  // ETA in minutes for a given token number
  int etaForToken(int tokenNumber) {
    final ahead = tokenNumber - currentToken - 1;
    if (ahead <= 0) return 0;
    return ahead * avgMinutesPerToken;
  }

  // Returns a copy with updated currentToken (used in Live Status simulation)
  Clinic copyWith({int? currentToken, int? totalInQueue}) {
    return Clinic(
      id: id,
      name: name,
      address: address,
      specialty: specialty,
      currentToken: currentToken ?? this.currentToken,
      totalInQueue: totalInQueue ?? this.totalInQueue,
      avgMinutesPerToken: avgMinutesPerToken,
    );
  }
}
