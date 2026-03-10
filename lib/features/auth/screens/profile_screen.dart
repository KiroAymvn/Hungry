import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _adressController = TextEditingController();
  TextEditingController? _visaController = TextEditingController();

  late TextEditingController _nameControllerU = TextEditingController(text: _nameController.text);
  late TextEditingController _emailControllerU = TextEditingController(text: _emailController.text);
  late TextEditingController _addressControllerU = TextEditingController(text: _adressController.text);
  late TextEditingController? _visaControllerU = TextEditingController(text: _visaController?.text);
  late TextEditingController? _visaError = TextEditingController(text: "No Visa");

  AuthRepo _authRepo = AuthRepo();
  static UserModel? userModel;
  bool isLoading = true;
  bool updateLoading = false;
  String? selectedImage;

  //PICK IMAGE
  Future<void> pickImage() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        selectedImage = pickImage.path;
      });
    }
  }

  //GET PROFILE
  Future<void> getProfileData() async {
    try {
      final user = await _authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
      print(PrefHelper.getToken());
    } catch (e) {
      String errorMessage = "Unhandled exception";
      if (e is ApiError) {
        print(e);
        errorMessage = e.toString();
      }
      else if(e is DioException){
        errorMessage=e.type.toString();
      }
      print(errorMessage);
      scaffoldMessengerError(context, errorMessage);
    }
  }

  //Update Profile
  Future<void> updateProfileData() async {
    setState(() {
      updateLoading = true;
    });
    try {
      final user = await _authRepo.updateProfileData(
        name: _nameControllerU.text.trim(),
        email: _emailControllerU.text.trim(),
        address: _addressControllerU.text.trim(),
        image: selectedImage,
        visa: _visaControllerU?.text,
      );

      setState(() {
        userModel = user;
        updateLoading = false;
      });
      scaffoldMessengerError(context, "Update Successfully", color: Colors.green);
      getProfileData();
    } catch (e) {
      setState(() {
        updateLoading = false;
      });
      String mess = "Failed to update";
      if (e is ApiError) {
        mess = e.toString();
      }
      scaffoldMessengerError(context, mess);
    }
  }

  bool logoutLoading = false;

  //LOGOUT
  Future<void> logout() async {
    try {
      setState(() {
        logoutLoading = true;
      });
      final response = await _authRepo.logout();
      setState(() {
        logoutLoading = false;
      });
      scaffoldMessengerError(context, response["message"], color: Colors.green);
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      setState(() {
        logoutLoading = false;
      });
      if (!mounted) return;
      if (e is ApiError) {
        scaffoldMessengerError(context, "logout failed", color: Colors.red);
      }
    }
  }

   bool isGuest=false;
//Auto Login

  Future<void> autoLogin() async {
    final user = await _authRepo.autoLogin();
    if (!mounted) return;   // ← الحل السحري

    setState(() => isGuest = _authRepo.isGuest);
    if (user != null) setState(() => userModel = user);
  }
  // Future<void> getIsGuest() async {
  //   bool? isGuest=await PrefHelper.isGuest();
  //   setState(()  {
  //     isGuest = isGuest;
  //   });
  // }

  @override
  void initState() {
    //function().then((v){}) --> to do what is inside the {} exactly
    // after finishing the function imidiatly
    autoLogin();

    getProfileData().then((v) {
      if (!mounted) return; // <<< يمنع أي crash
      updateDataToUser();

    });
    // getIsGuest();
    super.initState();
  }

  void updateDataToUser() {
    if (!mounted) return;   // ← الحل السحري

    setState(() {
      _nameController.text = userModel?.name.toString()??"no name";
      _adressController.text = userModel?.address ?? "Unknown address";
      _emailController.text = userModel?.email.toString()??"";
      _visaController?.text = (userModel?.visa?.toString()) ??"555";
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isGuest==false && userModel!=null ){
      return buildScaffoldProfileScreenInCaseOfUserAndLoading(context,false);
    }
    else if(isGuest==true){
      return Scaffold(
        backgroundColor: AppColors.primary,
        body: GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
            child: Center(child: CustomText(text: "Guest Mode",color: Colors.white,),)),
      );
    }else{
      return buildScaffoldProfileScreenInCaseOfUserAndLoading(context,true);

    }
  }

  Scaffold buildScaffoldProfileScreenInCaseOfUserAndLoading(BuildContext context,bool isLoading) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.basic,
        actions: [Padding(padding: const EdgeInsets.all(8.0), child: SvgPicture.asset("assets/icon/settings.svg"))],
      ),
      body:
      RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primary,
        onRefresh: () async {
          updateDataToUser();
          await getProfileData();
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Skeletonizer(
            enabled: isLoading,
            enableSwitchAnimation: true,
            effect: ShimmerEffect(
              duration: Duration(seconds: 2),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: selectedImage != null
                              ? Image.file(
                            File(selectedImage!),
                            fit: BoxFit.cover,
                          )
                              : (userModel?.image != null && userModel!.image!.isNotEmpty)
                              ? Image.network(
                            userModel!.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              CupertinoIcons.profile_circled,
                              size: 60,
                            ),
                          )
                              : const Icon(
                            CupertinoIcons.person,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: pickImage,
                          text: "Upload Image",
                          color: AppColors.primary,
                          textColor: Colors.white,
                          height: 45,
                          width: 150,
                          fontSize: 18,
                        ),
                        Gap(10),
                        CustomButton(
                          onTap: () async {
                            setState(() {
                              selectedImage = null;
                            });
                            await updateProfileData();
                          },
                          text: "Delete image",
                          color: AppColors.darkCoffee,
                          textColor: AppColors.basic,
                          height: 45,
                          width: 150,
                          fontSize: 18,
                        ),
                      ],
                    ),
                    Gap(10),
                    CustomProfileTextField(controller: _nameController, labelText: "Name",textColor: AppColors.primary,),
                    Gap(20),
                    CustomProfileTextField(controller: _emailController, labelText: "Email"),
                    Gap(20),
                    CustomProfileTextField(controller: _adressController, labelText: "Address"),
                    Gap(20),
                    Divider(),
                    Gap(20),
                    userModel?.visa == null
                        ? CustomText(text: "null visa")
                        : ListTile(
                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 8),
                      tileColor: Color(0xff0d3e96),
                      leading: Image.asset("assets/icon/visa.webp", width: 75),
                      title: CustomText(text: "Debit Card"),
                    ),
                    Gap(180),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: isLoading?SizedBox(): Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => customShowModalBottomSheet(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    CustomText(text: "Edit Profile", color: Colors.white, fontSize: 18),
                    Icon(Icons.edit, color: Colors.white),
                  ],
                ),
              ),
            ),
            logoutLoading
                ? CircularProgressIndicator()
                : GestureDetector(
              onTap: () {
                print("bottom");
                logout();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CustomText(text: "Logout", color: AppColors.primary, fontSize: 18),
                    Icon(Icons.login, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> customShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Recommended: allows the modal to resize with keyboard
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              // Add padding for keyboard visibility
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Colors.grey.shade600,
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  // Wrap in scroll view for safety
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Use min size
                    children: [
                      CustomText(text: "Edit your Profile", color: Colors.white, fontWeight: FontWeight.bold),
                      Gap(20),
                      CustomProfileTextField(
                        controller: _nameControllerU,
                        labelText: "name",
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      Gap(20),
                      CustomProfileTextField(
                        controller: _emailControllerU,
                        labelText: "email",
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      Gap(20),
                      CustomProfileTextField(
                        controller: _addressControllerU,
                        labelText: "Address",
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      Gap(20),
                      CustomProfileTextField(
                        iconData: CupertinoIcons.delete,
                        onDelete: () {
                          setState(() {
                            _visaControllerU = null;
                            print(_visaControllerU);
                          });
                        },
                        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                        controller: _visaControllerU ?? _visaError!,
                        labelText: "Visa",
                        read: false,
                        textFieldColor: AppColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // --- THE FIX IS HERE ---
                          updateLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : GestureDetector(
                                  onTap: () async {
                                    // 1. Force the Modal to rebuild immediately to show the spinner
                                    setModalState(() {
                                      updateLoading = true;
                                    });

                                    // 2. Perform the update (this rebuilds the background screen)
                                    await updateProfileData();

                                    // 3. Close the modal if the context is still valid
                                    // (Note: updateProfileData sets updateLoading to false at the end,
                                    // but we pop the modal anyway so we don't need to repaint it)
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomText(text: "Save", color: Colors.white, fontSize: 18),
                                        Icon(Icons.edit, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),

                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: AppColors.primary, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  CustomText(text: "Cancel", color: AppColors.primary, fontSize: 18),
                                  Icon(Icons.login, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(20), // Bottom spacing
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

class CustomProfileTextField extends StatelessWidget {
  CustomProfileTextField({
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

  TextEditingController controller = TextEditingController();
  final String labelText;
  bool read;
  Color? textFieldColor;
  Color textColor;
  TextAlign textAlign;
  TextInputType keyboardType;
  IconData? iconData;
  void Function()? onDelete;

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
        icon: iconData != null ? GestureDetector(onTap: onDelete, child: Icon(iconData)) : null,
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
