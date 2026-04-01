import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../../../../shared/widgets/story_cached_image.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({
    super.key,
    required this.heroTag,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.onTap,
  });

  final String heroTag;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final createdAtLabel = DateFormat.yMMMd(
      locale,
    ).add_Hm().format(createdAt.toLocal());

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        onTap: onTap,
        label: l10n.storyCardSemanticLabel(name, createdAtLabel),
        hint: l10n.openStoryHint,
        child: ExcludeSemantics(
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Hero(
                    tag: heroTag,
                    child: StoryCachedImage(
                      imageUrl: photoUrl,
                      semanticLabel: l10n.storyImageSemanticLabel(name),
                      unavailableSemanticLabel: l10n.imageUnavailableLabel,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.schedule_rounded,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              createdAtLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
