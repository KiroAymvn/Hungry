import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
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

  AuthRepo authRepo = AuthRepo();

  Future<void> checkLogin() async {
    try {

      final user = await authRepo.autoLogin();
      if (authRepo.isGuest) {
        print("isGuest" + authRepo.isGuest.toString());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => Root()));
      } else if (authRepo.isLoggedIn) {
        print("isLogged in " + authRepo.isLoggedIn.toString());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => Root()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // نبدأ الأنيميشن بعد ما الشاشة تفتح مباشرة
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _animate = true;
      });
    });

    // ننتقل للصفحة التالية بعد 2.5 ثانية
    Future.delayed(const Duration(seconds: 3), checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basic,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(250),

            // ===== Logo Animation =====
            AnimatedOpacity(
              opacity: _animate ? 1 : 0,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: AnimatedScale(
                scale: _animate ? 0.7 : 0.4,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutBack,
                child: SvgPicture.asset("assets/logo/logo.svg", height: 120,color: AppColors.primary,),
              ),
            ),

            const Spacer(),
            Lottie.asset("assets/lottie/Bouncing Burger.json", width: double.infinity, fit: BoxFit.cover)
            // ===== Bottom Image Slide Up =====
            // AnimatedSlide(
            //   offset: _animate ? Offset.zero : const Offset(0, 1),
            //   duration: const Duration(milliseconds: 800),
            //   curve: Curves.easeOut,
            //   child: AnimatedOpacity(
            //     opacity: _animate ? 1 : 0,
            //     duration: const Duration(milliseconds: 800),
            //     child: Lottie.asset("assets/lottie/Bouncing Burger.json", width: double.infinity, fit: BoxFit.cover),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
