import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/screens/login_screen.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_text_form_field.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import '../data/user_model.dart';
import '../widgets/custom_auth_btn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  AuthRepo _authRepo = AuthRepo();

  Future<void> signup() async {
    setState(() => isLoading = true);

    try {
      final user = await _authRepo.register(
        name: firstNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (user != null) {
        print("USER ISSSSSS" + user.email);
        setState(() => isLoading = false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Root()));
      }
    } catch (e) {
      setState(() => isLoading = false);
      String errorMessage = "unhandeled exception";
      if (e is ApiError) {
        errorMessage = e.toString();
      }
      scaffoldMessengerError(context, errorMessage);
    }
  }

  @override
  // void dispose() {
  //   firstNameController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

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
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                hint: "First Name",
                                isPassword: false,
                                controller: firstNameController,
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: CustomTextFormField(
                                hint: "Second Name",
                                isPassword: false,
                                controller: secondNameController,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        CustomTextFormField(hint: "Email address", isPassword: false, controller: emailController),
                        const Gap(20),
                        CustomTextFormField(hint: "Password", isPassword: true, controller: passwordController),
                        const Gap(20),
                        // CustomTextFormField(
                        //   hint: "Confirm Password",
                        //   isPassword: true,
                        //   controller: confirmPasswordController,
                        // ),
                        const Gap(20),
                        isLoading
                            ? CircularProgressIndicator()
                            : CustomAuthBtn(formKey: formKey, text: "Sign up", onTap: signup),
                        Gap(20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(text: "don't have an account ? ", textAlign: TextAlign.center),
                              CustomText(text: "Login ", textAlign: TextAlign.center),
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
  }
}
