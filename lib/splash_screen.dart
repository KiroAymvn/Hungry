import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/cubit/auth_cubit.dart';
import 'package:hungry/features/auth/cubit/auth_state.dart';
import 'package:hungry/features/auth/screens/login_screen.dart';
import 'package:hungry/root.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();

    // Start the logo animation shortly after the screen opens
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _animate = true);
    });

    // Trigger auto-login after the splash animation plays
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<AuthCubit>().autoLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      // Navigate when autoLogin() finishes (emits Success, Guest, or Initial)
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthGuest) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Root()),
          );
        } else if (state is AuthInitial) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.basic,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(250),
              // ── LOGO (animates in) ─────────────────────────────
              AnimatedOpacity(
                opacity: _animate ? 1 : 0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                child: AnimatedScale(
                  scale: _animate ? 0.7 : 0.4,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutBack,
                  child: SvgPicture.asset(
                    'assets/logo/logo.svg',
                    height: 120,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              // ── BOUNCING BURGER LOTTIE ─────────────────────────
              Lottie.asset(
                'assets/lottie/Bouncing Burger.json',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
