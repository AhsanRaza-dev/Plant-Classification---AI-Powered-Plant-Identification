import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:plant_app/view/signin/sign_in_screen.dart';

import '../../domain/constants/appimages.dart';
import '../../controllers/color_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final bool _rememberMe = false;

  bool _isPasswordVisible = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ColorSchemeController colorController =
      Get.find<ColorSchemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: colorController.isDarkMode.value ? Colors.black : null,
            gradient:
                colorController.isDarkMode.value
                    ? null
                    : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorController.buttonPrimaryColor.withOpacity(0.1),
                        Colors.white,
                        colorController.buttonPrimaryColor.withOpacity(0.05),
                      ],
                    ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Custom App Bar
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Iconsax.arrow_left_1,
                              color: colorController.buttonPrimaryColor,
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Header Section
                    Column(
                      children: [
                        // Logo with glow effect
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                colorController.buttonPrimaryColor.withOpacity(
                                  0.2,
                                ),
                                colorController.buttonPrimaryColor.withOpacity(
                                  0.1,
                                ),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorController.buttonPrimaryColor
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            AppImages.logo,
                            height: 120,
                            width: 120,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Title with gradient text
                        ShaderMask(
                          shaderCallback:
                              (bounds) => LinearGradient(
                                colors: [
                                  colorController.buttonPrimaryColor,
                                  colorController.buttonPrimaryColor
                                      .withOpacity(0.8),
                                ],
                              ).createShader(bounds),
                          child: Text(
                            'Plant Vision AI',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color:
                                  colorController.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black87,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Access your plant health diagnostic tools",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                colorController.isDarkMode.value
                                    ? Colors.grey[600]
                                    : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Beautiful Card
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorController.isDarkMode.value
                                ? Colors.grey[900]!
                                : Colors.white.withOpacity(0.9),
                            colorController.isDarkMode.value
                                ? Colors.grey[900]!
                                : Colors.white.withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: colorController.buttonPrimaryColor
                                .withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color:
                                colorController.isDarkMode.value
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Welcome text
                              Text(
                                'Good To See You',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      colorController.isDarkMode.value
                                          ? Colors.white
                                          : Colors.grey[800]!,
                                  letterSpacing: 0.5,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Sign Up to continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      colorController.isDarkMode.value
                                          ? Colors.grey[600]
                                          : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 20),
                              _buildStyledTextField(
                                controller: _nameController,
                                labelText: 'Full Name',
                                hintText: 'Enter Full Name',
                                prefixIcon: Iconsax.personalcard,
                                colorController: colorController,
                              ),
                              const SizedBox(height: 20),
                              // Email TextField with enhanced styling
                              _buildStyledTextField(
                                controller: _emailController,
                                labelText: 'Email Address',
                                hintText: 'Enter your email',
                                prefixIcon: Iconsax.message,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                colorController: colorController,
                              ),
                              const SizedBox(height: 20),
                              _buildStyledTextField(
                                controller: _numberController,
                                labelText: 'Phone No',
                                hintText: "Enter Phone No:",
                                prefixIcon: Iconsax.call,
                                keyboardType: TextInputType.phone,
                                colorController: colorController,
                              ),

                              const SizedBox(height: 20),

                              // Password TextField with enhanced styling
                              _buildStyledTextField(
                                controller: _passwordController,
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Iconsax.lock,
                                obscureText: !_isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                    color: colorController.buttonPrimaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                colorController: colorController,
                              ),

                              // Remember Me and Forgot Password Row
                              const SizedBox(height: 30),

                              // Enhanced Sign In Button
                              Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      colorController.buttonPrimaryColor,
                                      colorController.buttonPrimaryColor
                                          .withOpacity(0.8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorController.buttonPrimaryColor
                                          .withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Handle sign in
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color:
                                          colorController.isDarkMode.value
                                              ? Colors.grey[600]
                                              : Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Get.to(() => SignInScreen()),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color:
                                            colorController.buttonPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Sign Up Link
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStyledTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData prefixIcon,
  Widget? suffixIcon,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  required ColorSchemeController colorController,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    validator: validator,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: colorController.buttonPrimaryColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor:
          colorController.isDarkMode.value ? Colors.grey[800] : Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color:
              colorController.isDarkMode.value
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey[300]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color:
              colorController.isDarkMode.value
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: colorController.buttonPrimaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: TextStyle(
        color:
            colorController.isDarkMode.value ? Colors.white : Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color:
            colorController.isDarkMode.value
                ? Colors.grey[500]
                : Colors.grey[500],
      ),
    ),
  );
}

Widget _buildSocialButton({
  required Image image,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 13,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ClipRRect(borderRadius: BorderRadius.circular(20), child: image),
  );
}
