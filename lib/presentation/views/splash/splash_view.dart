import 'package:flutter/material.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/shared/shared.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.signupViewRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      builder: (_) {
        return const SizedBox.expand(
          child: StoriezLogo(),
        );
      },
    );
  }
}
