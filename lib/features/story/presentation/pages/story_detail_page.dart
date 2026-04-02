import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../../../../core/location/reverse_geocoding_service.dart';
import '../../../../core/network/app_error_message_resolver.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../../shared/widgets/story_cached_image.dart';
import '../../../../shared/widgets/status_view.dart';
import '../../data/models/story_item.dart';
import '../../data/repositories/story_repository.dart';

class StoryDetailPage extends StatefulWidget {
  const StoryDetailPage({super.key, required this.storyId, this.initialStory});

  final String storyId;
  final StoryItem? initialStory;

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late Future<StoryItem> _storyFuture;

  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  void _loadStory() {
    _storyFuture = context.read<StoryRepository>().getStoryDetail(
      widget.storyId,
    );
  }

  Future<void> _showLocationInfo(StoryItem story) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double? lat = story.lat;
    final double? lon = story.lon;
    if (lat == null || lon == null) {
      return;
    }

    final ReverseGeocodingService geocoding = context
        .read<ReverseGeocodingService>();
    final String address = await geocoding.getAddress(
      latitude: lat,
      longitude: lon,
    );

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.markerInfoTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(address.isEmpty ? l10n.unknownAddressLabel : address),
                  const SizedBox(height: 6),
                  Text(
                    l10n.selectedCoordinatesLabel(
                      lat.toStringAsFixed(5),
                      lon.toStringAsFixed(5),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoryLocationMap(StoryItem story) {
    final double lat = story.lat!;
    final double lon = story.lon!;
    final LatLng location = LatLng(lat, lon);

    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(initialCenter: location, initialZoom: 13),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.story_app',
            ),
            MarkerLayer(
              markers: <Marker>[
                Marker(
                  point: location,
                  width: 56,
                  height: 56,
                  child: GestureDetector(
                    onTap: () => _showLocationInfo(story),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                      size: 52,
                    ),
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: <SourceAttribution>[
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storyDetailTitle)),
      body: GradientBackground(
        child: FutureBuilder<StoryItem>(
          future: _storyFuture,
          builder: (BuildContext context, AsyncSnapshot<StoryItem> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              if (widget.initialStory != null) {
                return ListView(
                  children: <Widget>[
                    _buildHeroImage(
                      widget.initialStory!.photoUrl,
                      widget.initialStory!.name,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.detailLoadingMessage,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const StoryDetailShimmer();
            }

            if (snapshot.hasError) {
              return StatusView(
                icon: Icons.error_outline_rounded,
                type: StatusViewType.error,
                title: l10n.errorTitle,
                message: AppErrorMessageResolver.fromError(
                  l10n,
                  snapshot.error,
                ),
                actionLabel: l10n.retryButton,
                onAction: () {
                  setState(_loadStory);
                },
              );
            }

            final StoryItem? story = snapshot.data;
            if (story == null) {
              return StatusView(
                icon: Icons.info_outline,
                type: StatusViewType.empty,
                title: l10n.emptyStateTitle,
              );
            }

            return ListView(
              children: <Widget>[
                _buildHeroImage(story.photoUrl, story.name),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          story.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat.yMMMd(
                            Localizations.localeOf(context).toLanguageTag(),
                          ).add_Hm().format(story.createdAt.toLocal()),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.descriptionLabel,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SelectableText(story.description),
                        if (story.lat != null && story.lon != null) ...<Widget>[
                          const SizedBox(height: 16),
                          Text(
                            l10n.locationLabel,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          _buildStoryLocationMap(story),
                          const SizedBox(height: 8),
                          Text(
                            l10n.selectedCoordinatesLabel(
                              story.lat!.toStringAsFixed(5),
                              story.lon!.toStringAsFixed(5),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroImage(String photoUrl, String authorName) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Hero(
        tag: 'story-image-${widget.storyId}',
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: StoryCachedImage(
            imageUrl: photoUrl,
            semanticLabel: l10n.storyImageSemanticLabel(authorName),
            unavailableSemanticLabel: l10n.imageUnavailableLabel,
          ),
        ),
      ),
    );
  }
}
