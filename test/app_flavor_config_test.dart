import 'package:flutter_test/flutter_test.dart';
import 'package:story_app/app/flavor/app_flavor.dart';

void main() {
  group('AppFlavorConfig.resolve', () {
    test('uses preferred flavor when provided', () {
      final AppFlavor flavor = AppFlavorConfig.resolve(
        preferred: AppFlavor.free,
        flutterAppFlavor: 'paid',
        legacyFlavor: 'paid',
      );

      expect(flavor, AppFlavor.free);
    });

    test('reads FLUTTER_APP_FLAVOR value', () {
      final AppFlavor flavor = AppFlavorConfig.resolve(
        flutterAppFlavor: 'free',
      );

      expect(flavor, AppFlavor.free);
    });

    test('falls back to paid for unknown values', () {
      final AppFlavor flavor = AppFlavorConfig.resolve(
        flutterAppFlavor: 'other',
        legacyFlavor: '',
      );

      expect(flavor, AppFlavor.paid);
    });
  });
}
