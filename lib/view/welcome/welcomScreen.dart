import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:plant_app/controllers/color_controller.dart';
import 'package:plant_app/domain/constants/appimages.dart';
import 'package:plant_app/view/sign_up/sign_up.dart';
import 'package:plant_app/view/signin/sign_in_screen.dart';

class Welcomscreen extends StatelessWidget {
  const Welcomscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorController = Get.find<ColorSchemeController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Iconsax.arrow_left_1,
            color: colorController.buttonPrimaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Image.asset(AppImages.logo1, width: 250, height: 250),
          Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: colorController.buttonPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Text(
              'Sign-in or Sign-up to identify plant diseases and species instantly',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ClipPath(
              clipper: RoundedDiagonalPathClipper(),
              child: Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: colorController.buttonPrimaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          right: 20,
                          left: 20,
                        ),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.to(() => SignInScreen()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  colorController.buttonPrimaryColor,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation:
                                  8, // Add elevation for better visibility
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Iconsax.login, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          right: 20,
                          left: 20,
                        ),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.to(() => SignUpScreen()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation:
                                  8, // Add elevation for better visibility
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colorController.buttonPrimaryColor,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Iconsax.user_add,
                                  color: colorController.buttonPrimaryColor,
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
            ),
          ),
        ],
      ),
    );
  }
}
