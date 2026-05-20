import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/cubit/auth_cubit.dart';
import 'package:hungry/features/auth/cubit/auth_state.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/screens/signup_screen.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_text_form_field.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import '../widgets/custom_auth_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'kiroayman3003@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456789');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create a fresh AuthCubit for this screen
      create: (_) => AuthCubit(AuthRepo()),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // React to state changes that require navigation or showing a message
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Root()),
            );
          } else if (state is AuthGuest) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Root()),
            );
          } else if (state is AuthError) {
            scaffoldMessengerError(context, state.message!);
            print(state.message);
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
                      text: 'Welcome back , Discover the Fast Food',
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
                              // Login button
                              isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : CustomAuthBtn(
                                      formKey: _formKey,
                                      text: 'Login',
                                      onTap: () {
                                        context.read<AuthCubit>().login(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );
                                      },
                                    ),
                              const Gap(20),
                              // Create account button
                              CustomAuthBtn(
                                formKey: _formKey,
                                text: 'Create Account ?',
                                bgColor: Colors.transparent,
                                borderColor: AppColors.secondary,
                                textColor: AppColors.secondary,
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SignupScreen()),
                                  );
                                },
                              ),
                              const Gap(20),
                              // Guest mode
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthCubit>().continueAsGuest();
                                },
                                child: CustomText(
                                  text: 'Continue as a guest ? ',
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
