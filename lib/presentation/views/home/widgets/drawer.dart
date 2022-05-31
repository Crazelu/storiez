import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/home/home_view_model.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final user = ref.watch(homeViewModelProvider).user;
        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(80),
              if (user != null) ...{
                CircleAvatar(
                  radius: 40,
                  child: CustomText.heading3(
                    text: user.initials,
                    color: Palette.primaryColorLight,
                  ),
                  backgroundColor: Palette.primaryColor,
                ),
                const Gap(16),
                CustomText.heading3(text: user.username),
                const Gap(8),
                CustomText.regular(text: user.email),
                const Gap(24),
                TextButton.icon(
                  onPressed: () {
                    ref.read(homeViewModelProvider).logout();
                  },
                  icon: const Icon(
                    PhosphorIcons.sign_out_bold,
                    color: Palette.faintRed,
                  ),
                  label: CustomText.regular(
                    text: "Logout",
                    color: Palette.faintRed,
                  ),
                ),
              },
              const Spacer(flex: 2),
              StoriezLogo(
                size: 50,
                textSize: 14,
                spacing: 0,
                color: Palette.primaryColor.withOpacity(.1),
                textColor: Palette.primaryColor.withOpacity(.2),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
