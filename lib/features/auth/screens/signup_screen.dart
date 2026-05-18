import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/cubit/auth_cubit.dart';
import 'package:hungry/features/auth/cubit/auth_state.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/screens/login_screen.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_text_form_field.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import '../widgets/custom_auth_btn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepo()),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Root()),
            );
          } else if (state is AuthError) {
            scaffoldMessengerError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(100),
                    SvgPicture.asset('assets/logo/logo.svg',
                        color: AppColors.primary),
                    const Gap(25),
                    CustomText(
                      text: 'Create your account',
                      color: Colors.grey,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(40),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // First name & Last name side by side
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      hint: 'First Name',
                                      isPassword: false,
                                      controller: _firstNameController,
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: CustomTextFormField(
                                      hint: 'Last Name',
                                      isPassword: false,
                                      controller: _lastNameController,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(20),
                              CustomTextFormField(
                                hint: 'Email address',
                                isPassword: false,
                                controller: _emailController,
                              ),
                              const Gap(20),
                              CustomTextFormField(
                                hint: 'Password',
                                isPassword: true,
                                controller: _passwordController,
                              ),
                              const Gap(20),
                              // Sign up button
                              isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : CustomAuthBtn(
                                      formKey: _formKey,
                                      text: 'Sign up',
                                      onTap: () {
                                        context.read<AuthCubit>().register(
                                              _firstNameController.text.trim(),
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );
                                      },
                                    ),
                              const Gap(20),
                              // Navigate to login
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                        text: "Already have an account? "),
                                    CustomText(text: 'Login'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
