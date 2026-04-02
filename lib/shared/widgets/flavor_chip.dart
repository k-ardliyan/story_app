import 'package:flutter/material.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../../app/flavor/app_flavor.dart';

class FlavorChip extends StatelessWidget {
  const FlavorChip({super.key, this.onTap, this.iconOnly = false});

  final VoidCallback? onTap;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool isPaid = AppFlavorConfig.isPaid;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color background = isPaid
        ? colorScheme.primaryContainer
        : colorScheme.tertiaryContainer;
    final Color foreground = isPaid
        ? colorScheme.onPrimaryContainer
        : colorScheme.onTertiaryContainer;

    final Widget chip;
    if (iconOnly) {
      chip = Tooltip(
        message: isPaid ? l10n.paidFlavorBadge : l10n.freeFlavorBadge,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: foreground.withValues(alpha: 0.18)),
          ),
          alignment: Alignment.center,
          child: Icon(
            isPaid
                ? Icons.workspace_premium_rounded
                : Icons.lock_outline_rounded,
            size: 16,
            color: foreground,
          ),
        ),
      );
    } else {
      chip = Chip(
        avatar: Icon(
          isPaid ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded,
          size: 16,
          color: foreground,
        ),
        label: Text(isPaid ? l10n.paidFlavorBadge : l10n.freeFlavorBadge),
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
        side: BorderSide(color: foreground.withValues(alpha: 0.18)),
        backgroundColor: background,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 6),
      );
    }

    if (onTap == null) {
      return chip;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: chip,
      ),
    );
  }
}
