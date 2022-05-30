import 'package:flutter/material.dart';
import 'package:storiez/presentation/resources/app_assets.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/utils/validators.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confrimPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      builder: (size) {
        return SizedBox(
          height: size.height,
          width: size.width,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const Gap(96),
              Align(
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.maleMemoji.assetName,
                      height: 80,
                      width: 80,
                    ),
                    const Gap(16),
                    CustomText.heading3(
                      text: "Hey there!\nLet's get you started",
                      textAlign: TextAlign.center,
                    ),
                    const Gap(56),
                    CustomTextField(
                      hint: "Email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const Gap(24),
                    PasswordTextField(
                      hint: "Password",
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validators.validatePassword,
                    ),
                    const Gap(24),
                    PasswordTextField(
                      hint: "Confirm password",
                      keyboardType: TextInputType.visiblePassword,
                      controller: _confrimPasswordController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Re-enter password for confirmation";
                        }
                        if (_confrimPasswordController.text != val) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.go,
                    ),
                    const Gap(56),
                    CustomButton(
                      buttonText: "Signup",
                      onPressed: () {},
                    ),
                    const Gap(32),
                    const TextDivider(text: "You a Storiez stan?"),
                    const Gap(32),
                    CustomButton(
                      buttonText: "Login",
                      onPressed: () {},
                    ),
                    const Gap(48),
                    StoriezLogo(
                      size: 50,
                      spacing: 2,
                      color: Colors.black.withOpacity(.2),
                      textColor: Colors.black.withOpacity(.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
