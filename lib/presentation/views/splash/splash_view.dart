import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/splash/splash_vew_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      builder: (_) {
        return SizedBox.expand(
          child: Consumer(
            builder: (_, ref, __) {
              ref.read(splashViewModelProvider);
              return const StoriezLogo();
            },
          ),
        );
      },
    );
  }
}
