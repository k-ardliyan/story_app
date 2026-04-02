enum AppFlavor { free, paid }

class AppFlavorConfig {
  AppFlavorConfig._();

  static AppFlavor _current = AppFlavor.paid;

  static AppFlavor get current => _current;

  static bool get isFree => _current == AppFlavor.free;
  static bool get isPaid => _current == AppFlavor.paid;

  static AppFlavor fromName(String? raw) {
    final String normalized = (raw ?? '').trim().toLowerCase();
    if (normalized == 'free') {
      return AppFlavor.free;
    }
    if (normalized == 'paid') {
      return AppFlavor.paid;
    }
    return AppFlavor.paid;
  }

  static AppFlavor resolve({
    AppFlavor? preferred,
    String? flutterAppFlavor,
    String? legacyFlavor,
  }) {
    if (preferred != null) {
      return preferred;
    }

    final String primary = (flutterAppFlavor ?? '').trim();
    if (primary.isNotEmpty) {
      return fromName(primary);
    }

    final String fallback = (legacyFlavor ?? '').trim();
    if (fallback.isNotEmpty) {
      return fromName(fallback);
    }

    return AppFlavor.paid;
  }

  static void setFlavor(AppFlavor flavor) {
    _current = flavor;
  }
}
