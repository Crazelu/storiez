import 'package:flutter/material.dart';
import 'package:storiez/presentation/resources/app_assets.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/utils/validators.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
                      AppAssets.femaleMemoji.assetName,
                      height: 80,
                      width: 80,
                    ),
                    const Gap(16),
                    CustomText.heading3(
                      text: "Welcome back!\nLogin to your account",
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
                      textInputAction: TextInputAction.go,
                      validator: Validators.validatePassword,
                    ),
                    const Gap(56),
                    CustomButton(
                      buttonText: "Login",
                      onPressed: () {},
                    ),
                    const Gap(32),
                    const TextDivider(text: "New to Storiez?"),
                    const Gap(32),
                    CustomButton(
                      buttonText: "Signup",
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
