import 'package:flutter/material.dart';
import 'package:storiez/presentation/shared/shared.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text("Storiez"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      builder: (size) {
        return const SizedBox.expand();
      },
    );
  }
}
