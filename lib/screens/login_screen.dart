import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isRegisterMode = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegisterMode ? AppStrings.register : AppStrings.login),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 40),
              // Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppStrings.customerName,
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone Field (Register only)
              if (isRegisterMode)
                Column(
                  children: [
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: AppStrings.phoneNumber,
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Login/Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.secondary,
                            ),
                          ),
                        )
                      : Text(
                          isRegisterMode ? AppStrings.register : AppStrings.login,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Toggle Mode Button
              TextButton(
                onPressed: () {
                  setState(() {
                    isRegisterMode = !isRegisterMode;
                    nameController.clear();
                    passwordController.clear();
                    phoneController.clear();
                  });
                },
                child: Text(
                  isRegisterMode
                      ? AppStrings.haveAccount
                      : AppStrings.noAccount,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.fillAllFields,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      AuthStatus status;
      if (isRegisterMode) {
        status = await authController.register(
          nameController.text,
          phoneController.text,
          passwordController.text,
        );
      } else {
        status = await authController.login(
          nameController.text,
          passwordController.text,
        );
      }

      if (status == AuthStatus.success) {
        Get.snackbar(
          AppStrings.success,
          isRegisterMode ? AppStrings.registerSuccess : AppStrings.loginSuccess,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => const HomeScreen());
      } else {
        String errorMessage;
        if (status == AuthStatus.wrongPassword) {
          errorMessage = AppStrings.wrongPassword;
        } else if (status == AuthStatus.userNotFound) {
          errorMessage = AppStrings.userNotFound;
        } else if (status == AuthStatus.userExists) {
          errorMessage = AppStrings.userExists;
        } else {
          errorMessage = isRegisterMode
              ? AppStrings.registerFailed
              : AppStrings.loginFailed;
        }

        Get.snackbar(
          AppStrings.error,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        '${AppStrings.error}: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
