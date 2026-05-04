// lib/utils/sample_data.dart
// Hardcoded clinic data (no backend needed for semester project)

import '../models/clinic_model.dart';

final List<Clinic> sampleClinics = [
  const Clinic(
    id: 'c001',
    name: 'General OPD',
    address: 'Block A, Ground Floor',
    specialty: 'General Medicine',
    currentToken: 12,
    totalInQueue: 8,
    avgMinutesPerToken: 5,
  ),
  const Clinic(
    id: 'c002',
    name: 'Cardiology Clinic',
    address: 'Block B, 2nd Floor',
    specialty: 'Heart & Cardiovascular',
    currentToken: 5,
    totalInQueue: 4,
    avgMinutesPerToken: 10,
  ),
  const Clinic(
    id: 'c003',
    name: 'Pediatrics OPD',
    address: 'Block C, 1st Floor',
    specialty: 'Children (0–12 yrs)',
    currentToken: 20,
    totalInQueue: 11,
    avgMinutesPerToken: 7,
  ),
  const Clinic(
    id: 'c004',
    name: 'Dental Clinic',
    address: 'Block A, 1st Floor',
    specialty: 'Oral & Dental Care',
    currentToken: 3,
    totalInQueue: 2,
    avgMinutesPerToken: 15,
  ),
  const Clinic(
    id: 'c005',
    name: 'Eye & ENT Clinic',
    address: 'Block D, Ground Floor',
    specialty: 'Eyes, Ear, Nose & Throat',
    currentToken: 8,
    totalInQueue: 6,
    avgMinutesPerToken: 8,
  ),
];
