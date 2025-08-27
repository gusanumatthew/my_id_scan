import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/extensions/overlay_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/core/utils/vaidators.dart';
import 'package:myid_scan/view/authentication/notifiers/login_notifier.dart';
import 'package:myid_scan/view/general_widgets/app_button.dart';
import 'package:myid_scan/view/general_widgets/app_pass_field.dart';
import 'package:myid_scan/view/general_widgets/app_textfield.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEnabled = false;

  _register() {
    ref.read(loginNotifierProvider.notifier).register(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
        displayName: _nameController.text,
        onError: (p0) {
          context.showError(
            message: p0,
          );
        },
        onCompleted: () {
          context.replaceNamed(
            AppRouter.login,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: context.textTheme.s25w600.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              100.verticalSpace,
              Form(
                  key: _formKey,
                  onChanged: () {
                    setState(() {
                      isEnabled = _formKey.currentState!.validate();
                    });
                  },
                  child: Column(children: [
                    AppFormField(
                      label: 'Full Name',
                      hintText: 'Enter name',
                      controller: _nameController,
                      keyboardType: TextInputType.emailAddress,
                      validateFunction: Validators.name(),
                    ),
                    AppFormField(
                      label: 'Email Address',
                      hintText: 'Enter email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validateFunction: Validators.email(),
                    ),
                    AppPasswordField(
                      label: 'Password',
                      hintText: 'Enter password',
                      controller: _passwordController,
                      validateFunction: Validators.password(),
                    ),
                    AppPasswordField(
                      label: 'Confirm Password',
                      hintText: 'Enter password',
                      controller: _confirmPassController,
                      validateFunction: (v) => Validators.confirmPass(
                        _passwordController.text,
                        _confirmPassController.text,
                      ).call(v),
                    ),
                    40.verticalSpace,
                    Consumer(builder: (context, r, c) {
                      final loadState = r.watch(loginNotifierProvider
                          .select((v) => v.registerLoadState));
                      return AppButton(
                        text: 'Sign UP',
                        onTap: _register,
                        isEnabled: isEnabled && loadState != LoadState.loading,
                        isLoading: loadState == LoadState.loading,
                      );
                    }),
                    24.verticalSpace,
                    Text.rich(TextSpan(
                        text: 'Already have an account? ',
                        style: context.textTheme.s16w400,
                        children: [
                          TextSpan(
                              text: 'Sign In',
                              style: context.textTheme.s16w400.copyWith(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => context.pushNamed(AppRouter.login))
                        ])),
                  ])),
            ],
          ),
        ),
      ),
    ));
  }
}
