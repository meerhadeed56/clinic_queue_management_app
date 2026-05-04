// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_queue_management_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ClinicQueueApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
