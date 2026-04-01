import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../../../../app/viewmodels/locale_view_model.dart';
import '../../../../app/router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../../shared/widgets/story_cached_image.dart';
import '../../../../shared/widgets/status_view.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../viewmodels/story_list_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryListViewModel>().fetchStories();
    });
  }

  Future<void> _logout() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthViewModel authViewModel = context.read<AuthViewModel>();
    final StoryListViewModel storyListViewModel = context
        .read<StoryListViewModel>();

    final bool shouldLogout =
        await showModalBottomSheet<bool>(
          context: context,
          showDragHandle: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          builder: (BuildContext context) {
            final ColorScheme colorScheme = Theme.of(context).colorScheme;
            final RoundedRectangleBorder actionButtonShape =
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.error.withValues(
                        alpha: 0.12,
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: colorScheme.error,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.logoutSheetTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.logoutSheetMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      textDirection:
                          Theme.of(context).platform == TargetPlatform.windows
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: actionButtonShape,
                            ),
                            onPressed: () => context.pop(false),
                            child: Text(l10n.stayLoggedInButton),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: actionButtonShape,
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                            ),
                            onPressed: () => context.pop(true),
                            child: Text(l10n.logoutButton),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;

    if (!shouldLogout) {
      return;
    }

    await authViewModel.logout();
    if (!mounted) {
      return;
    }
    storyListViewModel.clear();
    context.go(AppRouter.loginPath);
  }

  Future<void> _showLanguageSheet() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final LocaleViewModel localeViewModel = context.read<LocaleViewModel>();
    final String selectedLanguage =
        localeViewModel.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    final String selectedCode =
        await showModalBottomSheet<String>(
          context: context,
          showDragHandle: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          builder: (BuildContext context) {
            final TextTheme textTheme = Theme.of(context).textTheme;

            Widget buildLanguageTile({
              required String code,
              required String label,
              required IconData icon,
            }) {
              final bool isSelected = selectedLanguage == code;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onTap: () => context.pop(code),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(label),
                  trailing: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            key: const ValueKey('selected'),
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : const Icon(
                            Icons.circle_outlined,
                            key: ValueKey('unselected'),
                          ),
                  ),
                ),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l10n.languageSheetTitle, style: textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      l10n.languageSheetMessage,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    buildLanguageTile(
                      code: 'id',
                      label: l10n.languageIndonesian,
                      icon: Icons.language,
                    ),
                    buildLanguageTile(
                      code: 'en',
                      label: l10n.languageEnglish,
                      icon: Icons.translate_rounded,
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        '';

    if (selectedCode.isEmpty) {
      return;
    }

    await localeViewModel.setLocale(Locale(selectedCode));
  }

  Widget _buildToolbarIconButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    context.watch<LocaleViewModel>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: _buildToolbarIconButton(
            tooltip: l10n.languageButton,
            onPressed: _showLanguageSheet,
            icon: Icons.translate_rounded,
          ),
        ),
        title: Text(l10n.homeTitle),
        actions: <Widget>[
          _buildToolbarIconButton(
            tooltip: l10n.refreshTooltip,
            onPressed: () => context.read<StoryListViewModel>().refresh(),
            icon: Icons.refresh_rounded,
          ),
          _buildToolbarIconButton(
            tooltip: l10n.logoutButton,
            onPressed: _logout,
            icon: Icons.logout_rounded,
          ),
        ],
      ),
      body: GradientBackground(
        padding: EdgeInsets.zero,
        child: Consumer<StoryListViewModel>(
          builder:
              (
                BuildContext context,
                StoryListViewModel storyViewModel,
                Widget? child,
              ) {
                if (storyViewModel.isLoading &&
                    storyViewModel.stories.isEmpty) {
                  return const StoryListShimmer();
                }

                if (storyViewModel.errorMessage != null &&
                    storyViewModel.stories.isEmpty) {
                  return StatusView(
                    icon: Icons.cloud_off_rounded,
                    type: StatusViewType.error,
                    title: l10n.errorTitle,
                    message: storyViewModel.errorMessage,
                    actionLabel: l10n.retryButton,
                    onAction: () => storyViewModel.refresh(),
                  );
                }

                if (storyViewModel.stories.isEmpty) {
                  return StatusView(
                    icon: Icons.photo_library_outlined,
                    type: StatusViewType.empty,
                    title: l10n.emptyStoriesTitle,
                    message: l10n.emptyStoriesMessage,
                    actionLabel: l10n.addStoryTitle,
                    onAction: () => context.push(AppRouter.addStoryPath),
                  );
                }

                return Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      onRefresh: storyViewModel.refresh,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemBuilder: (BuildContext context, int index) {
                          final story = storyViewModel.stories[index];
                          return _StoryCard(
                            heroTag: 'story-image-${story.id}',
                            name: story.name,
                            description: story.description,
                            photoUrl: story.photoUrl,
                            createdAt: story.createdAt,
                            onTap: () => context.push(
                              '${AppRouter.storyPath}/${story.id}',
                              extra: story,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 12);
                        },
                        itemCount: storyViewModel.stories.length,
                      ),
                    ),
                    if (storyViewModel.isLoading)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                  ],
                );
              },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.addStoryPath),
        tooltip: l10n.addStoryTitle,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: Text(l10n.addStoryTitle),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String locale = Localizations.localeOf(context).toLanguageTag();
    final String createdAtLabel = DateFormat.yMMMd(
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
