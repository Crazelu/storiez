import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/handlers/handlers.dart';
import 'package:storiez/presentation/resources/app_assets.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/login/login_view_model.dart';
import 'package:storiez/utils/locator.dart';
import 'package:storiez/utils/validators.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
                const Gap(96),
                Align(
                  child: Column(
                    children: [
                      Image.asset(
                        AppAssets.femaleMemoji.assetName,
                        height: 80,
                        width: 80,
                      ),
                      const Gap(8),
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
                      Consumer(
                        builder: (_, ref, __) {
                          return CustomButton(
                            loading: ref.watch(loginViewModelProvider).loading,
                            buttonText: "Login",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                ref.read(loginViewModelProvider).login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                              }
                            },
                          );
                        },
                      ),
                      const Gap(24),
                      const TextDivider(text: "New to Storiez?"),
                      const Gap(24),
                      CustomButton(
                        buttonText: "Signup",
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                            Routes.signupViewRoute,
                          );
                        },
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
          ),
        );
      },
    );
  }
}
