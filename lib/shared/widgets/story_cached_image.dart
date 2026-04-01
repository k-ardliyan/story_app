import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoryCachedImage extends StatelessWidget {
  const StoryCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.semanticLabel,
    this.unavailableSemanticLabel,
  });

  final String imageUrl;
  final BoxFit fit;
  final String? semanticLabel;
  final String? unavailableSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final String normalizedUrl = imageUrl.trim();
    if (normalizedUrl.isEmpty) {
      return _UnavailableImage(label: unavailableSemanticLabel);
    }

    return CachedNetworkImage(
      imageUrl: normalizedUrl,
      fadeInDuration: const Duration(milliseconds: 220),
      placeholder: (BuildContext context, String url) {
        return const _ImagePlaceholder();
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return Semantics(
          image: true,
          label: semanticLabel,
          child: Image(image: imageProvider, fit: fit),
        );
      },
      errorWidget: (BuildContext context, String url, Object error) {
        return _UnavailableImage(label: unavailableSemanticLabel);
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE9F2FB),
        highlightColor: const Color(0xFFF7FBFF),
        child: const ColoredBox(color: Colors.white),
      ),
    );
  }
}

class _UnavailableImage extends StatelessWidget {
  const _UnavailableImage({required this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: label,
      child: const ColoredBox(
        color: Color(0xFFEFF6FD),
        child: Center(
          child: ExcludeSemantics(
            child: Icon(Icons.broken_image_outlined, size: 42),
          ),
        ),
      ),
    );
  }
}
