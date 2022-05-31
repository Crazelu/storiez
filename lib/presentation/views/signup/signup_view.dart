import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/handlers/navigation_handler.dart';
import 'package:storiez/presentation/resources/app_assets.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/signup/signup_view_model.dart';
import 'package:storiez/utils/locator.dart';
import 'package:storiez/utils/validators.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confrimPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      onWillPop: () {
        locator<NavigationHandler>().exitApp();
      },
      builder: (size) {
        return Form(
          key: _formKey,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Gap(80),
                Align(
                  child: Column(
                    children: [
                      Image.asset(
                        AppAssets.maleMemoji.assetName,
                        height: 80,
                        width: 80,
                      ),
                      const Gap(8),
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
                      CustomTextField(
                        hint: "Username",
                        controller: _usernameController,
                        keyboardType: TextInputType.name,
                        validator: Validators.validateUsername,
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
                          if (_passwordController.text != val) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.go,
                      ),
                      const Gap(56),
                      Consumer(
                        builder: (_, ref, __) {
                          return CustomButton(
                            loading: ref.watch(signupViewModelProvider).loading,
                            buttonText: "Signup",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref.read(signupViewModelProvider).signup(
                                      email: _emailController.text,
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                    );
                              }
                            },
                          );
                        },
                      ),
                      const Gap(24),
                      const TextDivider(text: "You a Storiez stan?"),
                      const Gap(24),
                      CustomButton(
                        buttonText: "Login",
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                            Routes.loginViewRoute,
                          );
                        },
                      ),
                      const Gap(48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
