import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../controllers/color_controller.dart';

class AppResult extends StatefulWidget {
  const AppResult({super.key});

  @override
  State<AppResult> createState() => _AppResultState();
}

class _AppResultState extends State<AppResult> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Sample data - replace with your actual data
  final String plantName = "Tomato Plant";
  final String diseaseStatus = "Healthy";
  final double confidenceScore = 0.92;
  final String recommendation =
      "Your plant appears to be healthy! Continue regular watering and ensure adequate sunlight.";
  final String imagePath =
      "assets/images/plant_sample.jpg"; // Replace with actual image

  final ColorSchemeController colorController =
      Get.find<ColorSchemeController>();

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isHealthy = diseaseStatus.toLowerCase() == "healthy";

    return Obx(
      () => Scaffold(
        backgroundColor:
            colorController.isDarkMode.value ? Colors.black : Colors.grey[50],
        body: Column(
          children: [
            // Enhanced Header with gradient and animations
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorController.buttonPrimaryColor,
                      colorController.buttonPrimaryColor.withOpacity(0.8),
                      colorController.buttonPrimaryColor.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorController.buttonPrimaryColor.withOpacity(
                        0.3,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(painter: LeafPatternPainter()),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 60.0,
                        bottom: 10,
                        left: 80,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.eco, color: Colors.white, size: 40),
                          const SizedBox(height: 10),
                          const Text(
                            'Analysis Complete',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Plant Health Report',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main content with slide animation
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Plant Image and Basic Info Card
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color:
                                colorController.isDarkMode.value
                                    ? Colors.grey[900]
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                // Plant Image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        colorController.isDarkMode.value
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color:
                                          isHealthy ? Colors.green : Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.local_florist,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // Plant Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plantName,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              colorController.isDarkMode.value
                                                  ? Colors.white
                                                  : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isHealthy
                                                  ? Colors.green.withOpacity(
                                                    0.1,
                                                  )
                                                  : Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          diseaseStatus,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                isHealthy
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Confidence Score Card
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color:
                              colorController.isDarkMode.value
                                  ? Colors.grey[900]
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confidence Score',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      colorController.isDarkMode.value
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 15),
                              LinearProgressIndicator(
                                value: confidenceScore,
                                backgroundColor:
                                    colorController.isDarkMode.value
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  confidenceScore > 0.8
                                      ? Colors.green
                                      : confidenceScore > 0.6
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                                minHeight: 8,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${(confidenceScore * 100).toInt()}% Confident',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      confidenceScore > 0.8
                                          ? Colors.green
                                          : confidenceScore > 0.6
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Recommendation Card
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                colorController.isDarkMode.value
                                    ? Colors.grey[900]
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isHealthy
                                          ? Icons.check_circle
                                          : Icons.warning,
                                      color:
                                          isHealthy
                                              ? Colors.green
                                              : Colors.orange,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Recommendations',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            colorController.isDarkMode.value
                                                ? Colors.white
                                                : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Expanded(
                                  flex: 2,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      recommendation,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            colorController.isDarkMode.value
                                                ? Colors.white70
                                                : Colors.grey[700],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              label: const Text('Scan Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    colorController.buttonPrimaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Add share functionality
                              },
                              icon: Icon(
                                Icons.share,
                                color: colorController.buttonPrimaryColor,
                              ),
                              label: const Text('Share'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    colorController.buttonPrimaryColor,
                                side: BorderSide(
                                  color: colorController.buttonPrimaryColor,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
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
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// Custom painter for leaf pattern in header
class LeafPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    // Draw simple leaf shapes
    final path = Path();

    // Leaf 1
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.2,
      size.width * 0.25,
      size.height * 0.15,
    );
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.2,
      size.width * 0.3,
      size.height * 0.3,
    );
    path.close();

    // Leaf 2
    path.moveTo(size.width * 0.8, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width * 0.85,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.6,
      size.width * 0.9,
      size.height * 0.7,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
