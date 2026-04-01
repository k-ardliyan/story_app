import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoryListShimmer extends StatelessWidget {
  const StoryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemBuilder: (BuildContext context, int index) {
        return const _StoryCardSkeleton();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 12);
      },
      itemCount: 6,
    );
  }
}

class StoryDetailShimmer extends StatelessWidget {
  const StoryDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        _ShimmerBox(height: 220, radius: 20),
        SizedBox(height: 16),
        _ShimmerBox(height: 220, radius: 20),
      ],
    );
  }
}

class _StoryCardSkeleton extends StatelessWidget {
  const _StoryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _ShimmerBox(height: 170),
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ShimmerBox(height: 18, width: 120),
                SizedBox(height: 10),
                _ShimmerBox(height: 14),
                SizedBox(height: 6),
                _ShimmerBox(height: 14, width: 210),
                SizedBox(height: 12),
                _ShimmerBox(height: 12, width: 140),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, this.width, this.radius = 10});

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE9F2FB),
      highlightColor: const Color(0xFFF7FBFF),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
