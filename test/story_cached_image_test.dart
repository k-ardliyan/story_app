import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:story_app/shared/widgets/story_cached_image.dart';

void main() {
  testWidgets(
    'StoryCachedImage exposes semantic label when image is unavailable',
    (WidgetTester tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 120,
              height: 80,
              child: StoryCachedImage(
                imageUrl: '',
                unavailableSemanticLabel: 'Image unavailable',
              ),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Image unavailable'), findsOneWidget);
      semantics.dispose();
    },
  );
}
