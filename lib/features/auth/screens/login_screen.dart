import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/screens/login_screen.dart';
import 'package:hungry/features/auth/screens/signup_screen.dart';
import 'package:hungry/features/home/screens/home_screen.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_text_form_field.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/scaffold_message_error.dart';
import '../widgets/custom_auth_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: "kiroayman3003@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "123456789");
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  AuthRepo _authRepo = AuthRepo();

  Future<void> login() async {
    setState(() => isLoading = true);
    try {
      final user = await _authRepo.login(emailController.text.trim(), passwordController.text.trim());
      if (user != null) {
        print("${user.email} ******************");
        setState(() => isLoading = false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Root()));
      }
      print("*************************$user");
    } catch (e) {
      setState(() => isLoading = false);

      String errorMessage = "Unhandeled excption*******************";
      if (e is ApiError) {
        errorMessage = e.message.toString();
      }
      scaffoldMessengerError(context, errorMessage);
    }
  }
  Future<void>continueAsAGuest()async{
    try{
      print("Guest is true");
      await _authRepo.continueAsAGuest();

    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ يخلي الصفحة تطلع فوق لما الكيبورد يظهر
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(100),
              SvgPicture.asset("assets/logo/logo.svg", color: AppColors.primary),
              const Gap(25),
              CustomText(
                text: "Welcome back , Discover the Fast Food",
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextFormField(hint: "Email address", isPassword: false, controller: emailController),
                        const Gap(20),
                        CustomTextFormField(hint: "Password", isPassword: true, controller: passwordController),
                        const Gap(20),
                        const Gap(20),
                             CustomAuthBtn(formKey: formKey, text: "Login", onTap: login),
                        Gap(20),
                        CustomAuthBtn(
                          formKey: formKey,
                          text: "Create Account ?",
                          bgColor: Colors.transparent,
                          borderColor: AppColors.secondary,
                          textColor: AppColors.secondary,
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                          },
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: () async{
                            await continueAsAGuest();
                            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Root()));
                          },
                          child: CustomText(
                            text: "Continue as a guest ? ",
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
  }
}
