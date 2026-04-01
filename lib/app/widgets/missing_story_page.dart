import 'package:flutter/material.dart';

import '../../shared/widgets/status_view.dart';

class MissingStoryPage extends StatelessWidget {
  const MissingStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StatusView(
        icon: Icons.find_in_page_outlined,
        type: StatusViewType.empty,
        title: 'Story not found.',
      ),
    );
  }
}
