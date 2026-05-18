import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/cubit/auth_cubit.dart';
import 'package:hungry/features/auth/cubit/auth_state.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/screens/login_screen.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for the read-only display fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Controllers for the edit-mode modal fields
  final TextEditingController _nameEditController = TextEditingController();
  final TextEditingController _emailEditController = TextEditingController();
  final TextEditingController _addressEditController = TextEditingController();
  final TextEditingController _visaEditController = TextEditingController();

  String? _selectedImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _nameEditController.dispose();
    _emailEditController.dispose();
    _addressEditController.dispose();
    _visaEditController.dispose();
    super.dispose();
  }

  // Fill the display controllers with the latest user data
  void _populateControllers(UserModel user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _addressController.text = user.address ?? '';
    _visaEditController.text = user.visa ?? '';
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImagePath = picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          // Navigate to login screen after logout
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (state is AuthError) {
          scaffoldMessengerError(context, state.message);
        } else if (state is AuthUpdateSuccess) {
          // Show success message and update the display fields
          _populateControllers(state.user);
          scaffoldMessengerError(context, 'Updated successfully',
              color: Colors.green);
        }
      },
      builder: (context, state) {
        // ── GUEST MODE ──────────────────────────────────────────
        if (state is AuthGuest) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.person_circle,
                        color: Colors.white, size: 80),
                    const Gap(20),
                    CustomText(
                      text: 'Guest Mode',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    const Gap(10),
                    CustomText(
                      text: 'Tap to sign in',
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // ── DETERMINE CURRENT USER AND LOADING FLAG ─────────────
        UserModel? user;
        bool isLoading = false;
        bool isUpdateLoading = false;
        bool isLogoutLoading = false;

        if (state is AuthLoading) {
          isLoading = true;
        } else if (state is AuthSuccess) {
          user = state.user;
          // Populate controllers once when data arrives (won't override edits)
          if (_nameController.text.isEmpty) _populateControllers(user);
        } else if (state is AuthUpdateLoading) {
          user = state.currentUser;
          isUpdateLoading = true;
        } else if (state is AuthUpdateSuccess) {
          user = state.user;
        } else if (state is AuthLogoutLoading) {
          user = null;
          isLogoutLoading = true;
        }

        // ── MAIN PROFILE SCAFFOLD ────────────────────────────────
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.basic,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/icon/settings.svg'),
              ),
            ],
          ),
          body: RefreshIndicator(
            backgroundColor: Colors.white,
            color: AppColors.primary,
            onRefresh: () async {
              context.read<AuthCubit>().getProfile();
            },
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Skeletonizer(
                enabled: isLoading,
                enableSwitchAnimation: true,
                effect: const ShimmerEffect(
                  duration: Duration(seconds: 2),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // ── PROFILE IMAGE ──────────────────────
                        Center(
                          child: ClipOval(
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: _buildProfileImage(user),
                            ),
                          ),
                        ),
                        const Gap(10),
                        // ── IMAGE BUTTONS ──────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              onTap: _pickImage,
                              text: 'Upload Image',
                              color: AppColors.primary,
                              textColor: Colors.white,
                              height: 45,
                              width: 150,
                              fontSize: 18,
                            ),
                            const Gap(10),
                            CustomButton(
                              onTap: () async {
                                setState(() => _selectedImagePath = null);
                                if (user != null) {
                                  context.read<AuthCubit>().updateProfile(
                                        currentUser: user,
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        address: _addressController.text,
                                      );
                                }
                              },
                              text: 'Delete image',
                              color: AppColors.darkCoffee,
                              textColor: AppColors.basic,
                              height: 45,
                              width: 150,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        const Gap(10),
                        // ── READ-ONLY FIELDS ───────────────────
                        CustomProfileTextField(
                          controller: _nameController,
                          labelText: 'Name',
                          textColor: AppColors.primary,
                        ),
                        const Gap(20),
                        CustomProfileTextField(
                          controller: _emailController,
                          labelText: 'Email',
                        ),
                        const Gap(20),
                        CustomProfileTextField(
                          controller: _addressController,
                          labelText: 'Address',
                        ),
                        const Gap(20),
                        const Divider(),
                        const Gap(20),
                        // ── VISA CARD ──────────────────────────
                        if (user?.visa != null)
                          ListTile(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding:
                                const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                            tileColor: const Color(0xff0d3e96),
                            leading:
                                Image.asset('assets/icon/visa.webp', width: 75),
                            title: CustomText(text: 'Debit Card'),
                          ),
                        const Gap(180),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ── BOTTOM ACTION BAR ──────────────────────────────────
          bottomSheet: isLoading
              ? const SizedBox()
              : Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Edit profile button
                      GestureDetector(
                        onTap: () {
                          if (user != null) {
                            _nameEditController.text = user.name;
                            _emailEditController.text = user.email;
                            _addressEditController.text = user.address ?? '';
                            _visaEditController.text = user.visa ?? '';
                            _showEditModal(context, user);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              CustomText(
                                  text: 'Edit Profile',
                                  color: Colors.white,
                                  fontSize: 18),
                              const Icon(Icons.edit, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      // Logout button
                      isLogoutLoading
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () =>
                                  context.read<AuthCubit>().logout(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: AppColors.primary, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    CustomText(
                                        text: 'Logout',
                                        color: AppColors.primary,
                                        fontSize: 18),
                                    Icon(Icons.logout,
                                        color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ── HELPER: PROFILE IMAGE ────────────────────────────────────────
  Widget _buildProfileImage(UserModel? user) {
    if (_selectedImagePath != null) {
      return Image.file(File(_selectedImagePath!), fit: BoxFit.cover);
    }
    if (user?.image != null && user!.image!.isNotEmpty) {
      return Image.network(
        user.image!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(CupertinoIcons.profile_circled, size: 60),
      );
    }
    return const Icon(CupertinoIcons.person, size: 60);
  }

  // ── EDIT PROFILE MODAL SHEET ─────────────────────────────────────
  Future<void> _showEditModal(BuildContext context, UserModel user) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (_, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(modalContext).viewInsets.bottom),
              child: Container(
                color: Colors.grey.shade600,
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                          text: 'Edit your Profile',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      const Gap(20),
                      CustomProfileTextField(
                        controller: _nameEditController,
                        labelText: 'Name',
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(20),
                      CustomProfileTextField(
                        controller: _emailEditController,
                        labelText: 'Email',
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(20),
                      CustomProfileTextField(
                        controller: _addressEditController,
                        labelText: 'Address',
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(20),
                      CustomProfileTextField(
                        controller: _visaEditController,
                        labelText: 'Visa',
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(),
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Save button
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (ctx, state) {
                              final isSaving = state is AuthUpdateLoading;
                              return isSaving
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : GestureDetector(
                                      onTap: () async {
                                        context.read<AuthCubit>().updateProfile(
                                              currentUser: user,
                                              name: _nameEditController.text
                                                  .trim(),
                                              email: _emailEditController.text
                                                  .trim(),
                                              address: _addressEditController
                                                  .text
                                                  .trim(),
                                              image: _selectedImagePath,
                                              visa: _visaEditController.text
                                                  .trim(),
                                            );
                                        if (ctx.mounted) {
                                          Navigator.pop(ctx);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomText(
                                                text: 'Save',
                                                color: Colors.white,
                                                fontSize: 18),
                                            const Icon(Icons.edit,
                                                color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                          // Cancel button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: AppColors.primary, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  CustomText(
                                      text: 'Cancel',
                                      color: AppColors.primary,
                                      fontSize: 18),
                                  Icon(Icons.close, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// REUSABLE TEXT FIELD WIDGET (kept in same file for easy junior reading)
// ──────────────────────────────────────────────────────────────────────
class CustomProfileTextField extends StatelessWidget {
  const CustomProfileTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.read = true,
    this.textFieldColor = Colors.transparent,
    this.textColor = Colors.white,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.none,
    this.iconData,
    this.onDelete,
  });

  final TextEditingController controller;
  final String labelText;
  final bool read;
  final Color? textFieldColor;
  final Color textColor;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final IconData? iconData;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: read,
      textAlign: textAlign,
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: Colors.white,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        fillColor: textFieldColor,
        filled: true,
        labelText: labelText,
        icon: iconData != null
            ? GestureDetector(
                onTap: onDelete, child: Icon(iconData))
            : null,
        labelStyle: TextStyle(color: textColor, fontSize: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
      ),
    );
  }
}
