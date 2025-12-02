import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:victoria_user/controller/api_controller.dart';
import 'package:victoria_user/utils/app_colors.dart';
import 'package:victoria_user/utils/svg_path.dart';
import 'package:victoria_user/utils/text_styles.dart';
import 'package:victoria_user/view/components/custom_svg.dart';
import 'package:victoria_user/widget/button/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RxString phoneCode = "91".obs;
  final _formKey = GlobalKey<FormState>();
  final ApiController _controller = Get.put(ApiController());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.appPrimaryDarkColor,
                      AppColors.appPrimaryDarkColor,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Logo Section
                    Container(
                      decoration: BoxDecoration(
                        // color: AppColors.appWhiteColor.withOpacity(0.95),
                        // shape: BoxShape.circle,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.15),
                        //     blurRadius: 15,
                        //     offset: const Offset(0, 8),
                        //   ),
                        // ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/app_images/app-logo.png',
                            height: 180,
                            width: 180,
                            fit: BoxFit.contain,
                          ),
        
                        ],
                      ),
                    ),
                    Text(
                      "welcome_back".tr,
                      style: AppTextStyle.large28.copyWith(
                        fontFamily: FontFamily.bold,
                        fontWeight: FontWeight.w700,
                        color: AppColors.appWhiteColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "sign_in_continue".tr,
                      style: AppTextStyle.small16.copyWith(
                        color: AppColors.appWhiteColor.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 20),
        
              // Login Form Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.appWhiteColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "login_account".tr,
                          style: AppTextStyle.medium24.copyWith(
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.w700,
                            color: AppColors.appPrimaryDarkColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "enter_credentials".tr,
                          style: AppTextStyle.small14.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
        
                      // Contact Field
                      _buildTextFieldWithIcon(
                        controller: phoneController,
                        hintText: "enter_contact".tr,
                        title: "contact".tr,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'contact_required'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
        
                      // Password Field
                      _buildPasswordField(),
                      const SizedBox(height: 30),
        
                      // Login Button
                      Obx(
                            () => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: PrimaryButton(
                            height: 56,
                            text: "sign_in".tr,
                            textSize: 18,
                            loading: _controller.isLoginLoading.value,
                            onPressed: _controller.isLoginLoading.value
                                ? null
                                : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final body = {
                                  "mobile": phoneController.text,
                                  "password": passwordController.text,
                                };
                                _controller.login(context,body);
                              }
                            },
                            color: AppColors.appPrimaryDarkColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String hintText,
    required String title,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.small16.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: AppTextStyle.small16.copyWith(
              color: AppColors.appBlackColor,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyle.small16.copyWith(
                color: Colors.grey.shade500,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: AppColors.appPrimaryDarkColor,
                  size: 20,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.appWhiteColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.appPrimaryDarkColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.appPrimaryDarkColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "password".tr,
          style: AppTextStyle.small16.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
              () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password_required'.tr;
                }
                if (value.length < 6) {
                  return 'password_length'.tr;
                }
                return null;
              },
              style: AppTextStyle.small16.copyWith(
                color: AppColors.appBlackColor,
              ),
              decoration: InputDecoration(
                hintText: "enter_password".tr,
                hintStyle: AppTextStyle.small16.copyWith(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.lock_rounded,
                    color: AppColors.appPrimaryDarkColor,
                    size: 20,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _obscurePassword.value = !_obscurePassword.value;
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Icon(
                      _obscurePassword.value
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.appWhiteColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.appPrimaryDarkColor.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.appPrimaryDarkColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
