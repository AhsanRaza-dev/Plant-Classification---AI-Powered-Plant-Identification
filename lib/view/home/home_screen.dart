import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:plant_app/controllers/classification_controller.dart';
import 'package:plant_app/view/notification/notification.dart';
import '../../controllers/color_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;

    // List of 24 unique greetings for each hour of the day
    final List<String> hourlyGreetings = [
      "Peaceful Midnight 🌙", // 0:00 (12 AM)
      "Early Hours 🌠", // 1:00 (1 AM)
      "Deep Night 💫", // 2:00 (2 AM)
      "Before Dawn 🌃", // 3:00 (3 AM)
      "Early Twilight 🌌", // 4:00 (4 AM)
      "Dawn Breaks 🌅", // 5:00 (5 AM)
      "Early Morning 🌄", // 6:00 (6 AM)
      "Fresh Morning 🍃", // 7:00 (7 AM)
      "Good Morning ☀️", // 8:00 (8 AM)
      "Bright Morning 🌞", // 9:00 (9 AM)
      "Mid-Morning ⏱️", // 10:00 (10 AM)
      "Late Morning 🕙", // 11:00 (11 AM)
      "Noon Time 🌤️", // 12:00 (12 PM)
      "Early Afternoon 🌞", // 13:00 (1 PM)
      "Afternoon 🌇", // 14:00 (2 PM)
      "Mid-Afternoon 📝", // 15:00 (3 PM)
      "Late Afternoon 🍵", // 16:00 (4 PM)
      "Early Evening 🏮", // 17:00 (5 PM)
      "Good Evening 🌆", // 18:00 (6 PM)
      "Twilight Evening 🌉", // 19:00 (7 PM)
      "Dusk Settles 🌟", // 20:00 (8 PM)
      "Evening Winds 🍃", // 21:00 (9 PM)
      "Late Evening 🌛", // 22:00 (10 PM)
      "Night Falls 🌜", // 23:00 (11 PM)
    ];

    return hourlyGreetings[hour];
  }

  @override
  Widget build(BuildContext context) {
    final colorController = Get.find<ColorSchemeController>();
    final classificationController = Get.put(ClassificationController());
    return Obx(
      () => Scaffold(
        backgroundColor:
            colorController.isDarkMode.value ? Colors.black : Colors.white54,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Rounded Bottom Edges - Dynamic Height
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorController.buttonPrimaryColor,
                      colorController.buttonPrimaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorController.buttonPrimaryColor.withOpacity(
                        0.3,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 20,
                      left: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top Row with Profile and Notifications
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getGreeting(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            colorController.isDarkMode.value
                                                ? Colors.white
                                                : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Ahsan Raza',
                                      style: TextStyle(
                                        color:
                                            colorController.isDarkMode.value
                                                ? Colors.white
                                                : Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconButton(
                                color: Colors.white,
                                onPressed:
                                    () => Get.to(() => NotificationScreen()),
                                icon: Icon(
                                  Iconsax.notification,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Welcome Message for Plant Disease App
                        Text(
                          'Plant Health Monitor',
                          style: TextStyle(
                            color:
                                colorController.isDarkMode.value
                                    ? Colors.white
                                    : Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Obx(
                          () => Text(
                            classificationController.isLoading.value
                                ? 'Loading AI models...'
                                : classificationController
                                    .modelsInitialized
                                    .value
                                ? 'AI models ready - Identify plant species or detect diseases'
                                : 'AI models initialization failed - Please retry',
                            style: TextStyle(
                              color:
                                  colorController.isDarkMode.value
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Model Status Indicator
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  classificationController
                                          .modelsInitialized
                                          .value
                                      ? Colors.green.withOpacity(0.2)
                                      : classificationController.isLoading.value
                                      ? Colors.orange.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  classificationController
                                          .modelsInitialized
                                          .value
                                      ? Icons.check_circle
                                      : classificationController.isLoading.value
                                      ? Icons.hourglass_empty
                                      : Icons.error,
                                  color:
                                      classificationController
                                              .modelsInitialized
                                              .value
                                          ? Colors.green
                                          : classificationController
                                              .isLoading
                                              .value
                                          ? Colors.orange
                                          : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  classificationController.getModelStatusText(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Dual Classification Options
                        Row(
                          children: [
                            // Disease Classification Button
                            Expanded(
                              child: Obx(
                                () => GestureDetector(
                                  onTap:
                                      classificationController.canClassify
                                          ? () => _showClassificationDialog(
                                            context,
                                            'Disease Classification',
                                            'Detect plant diseases and health issues',
                                            Icons.coronavirus_outlined,
                                            Colors.red[600]!,
                                            () => _startDiseaseClassification(
                                              context,
                                            ),
                                          )
                                          : () =>
                                              _showModelNotReadyDialog(context),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          colorController.isDarkMode.value
                                              ? Colors.grey[900]!
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      border:
                                          classificationController
                                                  .isProcessingDisease
                                                  .value
                                              ? Border.all(
                                                color: Colors.red[600]!,
                                                width: 2,
                                              )
                                              : null,
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Icon(
                                              Icons.coronavirus_outlined,
                                              color: Colors.red[600],
                                              size: 24,
                                            ),
                                            if (classificationController
                                                .isProcessingDisease
                                                .value)
                                              Positioned(
                                                right: -2,
                                                top: -2,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[600],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          classificationController
                                                  .isProcessingDisease
                                                  .value
                                              ? 'Processing...'
                                              : 'Disease\nClassification',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red[600],
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Species Classification Button
                            Expanded(
                              child: Obx(
                                () => GestureDetector(
                                  onTap:
                                      classificationController.canClassify
                                          ? () => _showClassificationDialog(
                                            context,
                                            'Species Classification',
                                            'Identify plant species and varieties',
                                            Icons.nature_outlined,
                                            Colors.green[600]!,
                                            () => _startSpeciesClassification(
                                              context,
                                            ),
                                          )
                                          : () =>
                                              _showModelNotReadyDialog(context),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          colorController.isDarkMode.value
                                              ? Colors.grey[900]!
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      border:
                                          classificationController
                                                  .isProcessingSpecies
                                                  .value
                                              ? Border.all(
                                                color: Colors.green[600]!,
                                                width: 2,
                                              )
                                              : null,
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Icon(
                                              Icons.nature_outlined,
                                              color: Colors.green[600],
                                              size: 24,
                                            ),
                                            if (classificationController
                                                .isProcessingSpecies
                                                .value)
                                              Positioned(
                                                right: -2,
                                                top: -2,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[600],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          classificationController
                                                  .isProcessingSpecies
                                                  .value
                                              ? 'Processing...'
                                              : 'Species\nClassification',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.green[600],
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
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
                      ],
                    ),
                  ),
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Classification Tools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            colorController.isDarkMode.value
                                ? Colors.white
                                : Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Classification Tool Action Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.local_florist_outlined,
                            title: 'Plant Library',
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.biotech_outlined,
                            title: 'Disease Guide',
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.history_outlined,
                            title: 'Scan History',
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.analytics_outlined,
                            title: 'Analytics',
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Recent Activity Section
                    Text(
                      'Recent Classifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            colorController.isDarkMode.value
                                ? Colors.white
                                : Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Activity Cards - Mixed Disease and Species Classifications
                    _buildActivityCard(
                      icon: Icons.coronavirus_outlined,
                      title: 'Leaf Spot Disease',
                      subtitle: 'Detected in Rose Plant',
                      time: '2 hours ago',
                      statusColor: Colors.red,
                      classificationType: 'Disease',
                    ),

                    _buildActivityCard(
                      icon: Icons.nature_outlined,
                      title: 'Monstera Deliciosa',
                      subtitle: 'Species Identified',
                      time: '4 hours ago',
                      statusColor: Colors.green,
                      classificationType: 'Species',
                    ),

                    _buildActivityCard(
                      icon: Icons.coronavirus_outlined,
                      title: 'Powdery Mildew',
                      subtitle: 'Early stage detected',
                      time: '1 day ago',
                      statusColor: Colors.orange,
                      classificationType: 'Disease',
                    ),

                    _buildActivityCard(
                      icon: Icons.nature_outlined,
                      title: 'Ficus Benjamina',
                      subtitle: 'Weeping Fig identified',
                      time: '2 days ago',
                      statusColor: Colors.green,
                      classificationType: 'Species',
                    ),

                    const SizedBox(height: 24),

                    // Tips Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green.withOpacity(0.1),
                            Colors.blue.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Colors.green[600],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Quick Tip',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      colorController.isDarkMode.value
                                          ? Colors.white
                                          : Colors.black87,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose your classification method below',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    final colorController = Get.find<ColorSchemeController>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            colorController.isDarkMode.value ? Colors.grey[900]! : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color:
                  colorController.isDarkMode.value
                      ? Colors.white
                      : Colors.black87,
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color statusColor,
    required String classificationType,
  }) {
    final colorController = Get.find<ColorSchemeController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            colorController.isDarkMode.value ? Colors.grey[900]! : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color:
                        colorController.isDarkMode.value
                            ? Colors.white
                            : Colors.black87,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color:
                        colorController.isDarkMode.value
                            ? Colors.grey[600]
                            : Colors.grey[600],
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  classificationType,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color:
                      colorController.isDarkMode.value
                          ? Colors.grey[500]
                          : Colors.grey[500],
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClassificationDialog(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onProceed,
  ) {
    final classificationController = Get.find<ClassificationController>();

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 16),
            if (!classificationController.hasImage)
              const Text(
                'You need to select an image first.',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed:
                classificationController.hasImage
                    ? () {
                      Get.back();
                      onProceed();
                    }
                    : () {
                      Get.back();
                      classificationController.showImageSourceDialog();
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(
              classificationController.hasImage ? 'Classify' : 'Select Image',
            ),
          ),
        ],
      ),
    );
  }

  void _showModelNotReadyDialog(BuildContext context) {
    final classificationController = Get.find<ClassificationController>();

    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Models Not Ready'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (classificationController.isLoading.value)
              const Text('AI models are still loading. Please wait a moment.')
            else
              const Text(
                'AI models failed to initialize. Please retry loading the models.',
              ),
            const SizedBox(height: 12),
            Text(
              'Status: ${classificationController.getModelStatusText()}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          if (!classificationController.isLoading.value &&
              !classificationController.modelsInitialized.value)
            ElevatedButton(
              onPressed: () {
                Get.back();
                classificationController.retryInitialization();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  void _startSpeciesClassification(BuildContext context) {
    final classificationController = Get.find<ClassificationController>();

    if (!classificationController.hasImage) {
      classificationController.showImageSourceDialog();
      return;
    }

    classificationController.classifySpecies();
  }

  void _startDiseaseClassification(BuildContext context) {
    final classificationController = Get.find<ClassificationController>();

    if (!classificationController.hasImage) {
      classificationController.showImageSourceDialog();
      return;
    }

    classificationController.classifyDisease();
  }
}
