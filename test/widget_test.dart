import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:story_app/shared/widgets/status_view.dart';

void main() {
  testWidgets('StatusView shows title and message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusView(
            icon: Icons.info_outline,
            title: 'Title',
            message: 'Message',
          ),
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
  });
}
