import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../../../../app/router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../data/repositories/story_repository.dart';
import '../viewmodels/add_story_view_model.dart';
import '../viewmodels/story_list_view_model.dart';

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
        return errorCode ?? l10n.genericError;
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
