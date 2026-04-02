import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../../../../app/flavor/app_flavor.dart';
import '../../../../app/router.dart';
import '../../../../core/network/app_error_message_resolver.dart';
import '../../../../shared/widgets/flavor_chip.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../data/repositories/story_repository.dart';
import '../viewmodels/add_story_view_model.dart';
import '../viewmodels/story_list_view_model.dart';
import 'location_picker_page.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  late final AddStoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddStoryViewModel(
      storyRepository: context.read<StoryRepository>(),
      locationEnabled: AppFlavorConfig.isPaid,
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  String _resolveErrorMessage(AppLocalizations l10n, String? errorCode) {
    switch (errorCode) {
      case AddStoryViewModel.errorPhotoTooLarge:
        return l10n.photoTooLargeError;
      case AddStoryViewModel.errorPhotoPickFailed:
        return l10n.photoPickFailedError;
      case AddStoryViewModel.errorPhotoRequired:
        return l10n.photoRequiredError;
      case AddStoryViewModel.errorDescriptionRequired:
        return l10n.descriptionRequiredError;
      default:
        return AppErrorMessageResolver.fromCode(l10n, errorCode);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool picked = await _viewModel.pickImage(source);
    if (!mounted) {
      return;
    }

    if (!picked && _viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_resolveErrorMessage(l10n, _viewModel.errorMessage)),
        ),
      );
    }
  }

  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await _viewModel.submit(
      description: _descriptionController.text,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_resolveErrorMessage(l10n, _viewModel.errorMessage)),
        ),
      );
      return;
    }

    await context.read<StoryListViewModel>().refresh();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.uploadSuccessMessage)));
    context.go(AppRouter.homePath);
  }

  Future<void> _openLocationPicker() async {
    if (!_viewModel.isLocationEnabled) {
      return;
    }

    final LocationSelectionResult? selection = await context
        .push<LocationSelectionResult>(
          AppRouter.addStoryLocationPickerPath,
          extra: LocationPickerInitialData(
            initialLatitude: _viewModel.selectedLatitude,
            initialLongitude: _viewModel.selectedLongitude,
          ),
        );

    if (!mounted || selection == null) {
      return;
    }

    _viewModel.setLocation(
      latitude: selection.latitude,
      longitude: selection.longitude,
      address: selection.address,
    );
  }

  Future<void> _showModeInfoSheet(AppLocalizations l10n) async {
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
                    l10n.modeDifferenceSheetTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiaryContainer.withValues(alpha: 0.45),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.modeDifferenceFreeTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.modeDifferenceFreeDescription),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.45),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.modeDifferencePaidTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.modeDifferencePaidDescription),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationModePanel(AppLocalizations l10n) {
    final bool isPaid = _viewModel.isLocationEnabled;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isPaid
            ? colorScheme.primaryContainer.withValues(alpha: 0.30)
            : colorScheme.tertiaryContainer.withValues(alpha: 0.30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              FlavorChip(onTap: () => _showModeInfoSheet(l10n)),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showModeInfoSheet(l10n),
                icon: const Icon(Icons.info_outline),
                label: Text(l10n.seeModeDifferenceButton),
              ),
            ],
          ),
          Text(
            isPaid
                ? l10n.locationEnabledForPaidDescription
                : l10n.locationLockedForFreeDescription,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedLocationPreviewMap() {
    final LatLng point = LatLng(
      _viewModel.selectedLatitude!,
      _viewModel.selectedLongitude!,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 14,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.story_app',
            ),
            MarkerLayer(
              markers: <Marker>[
                Marker(
                  point: point,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                    size: 44,
                  ),
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
      appBar: AppBar(title: Text(l10n.addStoryTitle)),
      body: GradientBackground(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (BuildContext context, Widget? child) {
            return ListView(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.photoLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Semantics(
                            image: true,
                            label: _viewModel.selectedImage == null
                                ? l10n.photoPlaceholder
                                : l10n.photoLabel,
                            child: Container(
                              width: double.infinity,
                              height: 210,
                              color: const Color(0xFFEFF6FD),
                              child: _viewModel.selectedImage == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const ExcludeSemantics(
                                          child: Icon(
                                            Icons.image_outlined,
                                            size: 48,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(l10n.photoPlaceholder),
                                      ],
                                    )
                                  : Image.file(
                                      File(_viewModel.selectedImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder:
                              (
                                BuildContext context,
                                BoxConstraints constraints,
                              ) {
                                final bool compact = constraints.maxWidth < 360;

                                if (compact) {
                                  return Column(
                                    children: <Widget>[
                                      FilledButton.tonalIcon(
                                        onPressed: _viewModel.isSubmitting
                                            ? null
                                            : () => _pickImage(
                                                ImageSource.camera,
                                              ),
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                        ),
                                        label: Text(l10n.pickFromCamera),
                                      ),
                                      const SizedBox(height: 10),
                                      FilledButton.tonalIcon(
                                        onPressed: _viewModel.isSubmitting
                                            ? null
                                            : () => _pickImage(
                                                ImageSource.gallery,
                                              ),
                                        icon: const Icon(
                                          Icons.photo_library_outlined,
                                        ),
                                        label: Text(l10n.pickFromGallery),
                                      ),
                                    ],
                                  );
                                }

                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: FilledButton.tonalIcon(
                                        onPressed: _viewModel.isSubmitting
                                            ? null
                                            : () => _pickImage(
                                                ImageSource.camera,
                                              ),
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                        ),
                                        label: Text(l10n.pickFromCamera),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: FilledButton.tonalIcon(
                                        onPressed: _viewModel.isSubmitting
                                            ? null
                                            : () => _pickImage(
                                                ImageSource.gallery,
                                              ),
                                        icon: const Icon(
                                          Icons.photo_library_outlined,
                                        ),
                                        label: Text(l10n.pickFromGallery),
                                      ),
                                    ),
                                  ],
                                );
                              },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.descriptionLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _descriptionController,
                            minLines: 4,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: l10n.descriptionHint,
                            ),
                            validator: (String? value) {
                              if ((value ?? '').trim().isEmpty) {
                                return l10n.descriptionRequiredError;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.locationLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          _buildLocationModePanel(l10n),
                          const SizedBox(height: 12),
                          if (!_viewModel.isLocationEnabled)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHigh,
                              ),
                              child: Text(
                                l10n.locationDisabledInFreeMessage,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          else ...<Widget>[
                            if (_viewModel.hasLocationSelection) ...<Widget>[
                              Text(
                                l10n.selectedLocationPreviewTitle,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              _buildSelectedLocationPreviewMap(),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHigh,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      l10n.selectedCoordinatesLabel(
                                        _viewModel.selectedLatitude!
                                            .toStringAsFixed(5),
                                        _viewModel.selectedLongitude!
                                            .toStringAsFixed(5),
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _viewModel.selectedAddress ??
                                          l10n.unknownAddressLabel,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.tonalIcon(
                                  onPressed: _viewModel.isSubmitting
                                      ? null
                                      : _openLocationPicker,
                                  icon: const Icon(Icons.map_outlined),
                                  label: Text(l10n.changeLocationButton),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _viewModel.isSubmitting
                                      ? null
                                      : _viewModel.clearLocation,
                                  icon: const Icon(Icons.close_rounded),
                                  label: Text(l10n.clearLocationButton),
                                ),
                              ),
                            ] else
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.tonalIcon(
                                  onPressed: _viewModel.isSubmitting
                                      ? null
                                      : _openLocationPicker,
                                  icon: const Icon(Icons.map_outlined),
                                  label: Text(l10n.pickLocationFromMapButton),
                                ),
                              ),
                          ],
                          const SizedBox(height: 18),
                          FilledButton.icon(
                            onPressed: _viewModel.isSubmitting ? null : _submit,
                            icon: _viewModel.isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.cloud_upload_outlined),
                            label: Text(l10n.uploadStoryButton),
                          ),
                        ],
                      ),
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
}
