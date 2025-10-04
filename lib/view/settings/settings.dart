import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../domain/constants/appcolors.dart' as app_colors;
import 'package:get/get.dart';
import '../../controllers/color_controller.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Settings state variables
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoSaveResults = true;
  bool _highQualityImages = true;
  bool _soundEnabled = true;
  String _selectedLanguage = 'English';
  // Remove _selectedTheme and _themes, use ColorSchemeController instead
  final ColorSchemeController colorController = Get.find();
  final List<Map<String, dynamic>> _themes = [
    {'name': 'Green', 'scheme': app_colors.ColorScheme.green},
    {'name': 'Blue', 'scheme': app_colors.ColorScheme.blue},
    {'name': 'Purple', 'scheme': app_colors.ColorScheme.purple},
    {'name': 'Orange', 'scheme': app_colors.ColorScheme.orange},
  ];
  double _cameraQuality = 0.8;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];
  // final List<String> _themes = ['Green', 'Blue', 'Purple', 'Orange']; // This line is removed

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          colorController.isDarkMode.value ? Colors.black : Colors.grey[50],
      body: Obx(
        () => Column(
          children: [
            // Enhanced Header
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
                      child: CustomPaint(painter: SettingsPatternPainter()),
                    ),
                    // Back button
                    Positioned(
                      top: 50,
                      left: 20,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
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
                          const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Settings',
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
                            'Customize your plant care experience',
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

            // Settings Content
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // App Preferences Section
                    _buildSectionHeader('App Preferences', Icons.tune),
                    _buildSettingsCard([
                      _buildSwitchTile(
                        'Notifications',
                        'Get notified about plant care reminders',
                        Icons.notifications,
                        _notificationsEnabled,
                        (value) =>
                            setState(() => _notificationsEnabled = value),
                      ),
                      _buildSwitchTile(
                        'Dark Mode',
                        'Switch to dark theme',
                        Icons.dark_mode,
                        colorController.isDarkMode.value,
                        (value) => colorController.setDarkMode(value),
                      ),
                      _buildSwitchTile(
                        'Sound Effects',
                        'Enable app sounds and alerts',
                        Icons.volume_up,
                        _soundEnabled,
                        (value) => setState(() => _soundEnabled = value),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Camera & Scanning Section
                    _buildSectionHeader('Camera & Scanning', Icons.camera_alt),
                    _buildSettingsCard([
                      _buildSwitchTile(
                        'Auto-save Results',
                        'Automatically save scan results',
                        Icons.save,
                        _autoSaveResults,
                        (value) => setState(() => _autoSaveResults = value),
                      ),
                      _buildSwitchTile(
                        'High Quality Images',
                        'Use maximum camera resolution',
                        Icons.high_quality,
                        _highQualityImages,
                        (value) => setState(() => _highQualityImages = value),
                      ),
                      _buildSliderTile(
                        'Camera Quality',
                        'Adjust image compression level',
                        Icons.tune,
                        _cameraQuality,
                        (value) => setState(() => _cameraQuality = value),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Language & Region Section
                    _buildSectionHeader('Language & Region', Icons.language),
                    _buildSettingsCard([
                      _buildDropdownTile(
                        'Language',
                        'Select your preferred language',
                        Icons.translate,
                        _selectedLanguage,
                        _languages,
                        (value) => setState(() => _selectedLanguage = value!),
                      ),
                      _buildDropdownTile(
                        'Theme Color',
                        'Choose your favorite color scheme',
                        Icons.palette,
                        _themes.firstWhere(
                          (t) =>
                              t['scheme'] ==
                              colorController.currentColorScheme.value,
                        )['name'],
                        _themes.map((t) => t['name'] as String).toList(),
                        (value) {
                          final selected =
                              _themes.firstWhere(
                                    (t) => t['name'] == value,
                                  )['scheme']
                                  as app_colors.ColorScheme;
                          colorController.changeColorScheme(selected);
                        },
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Account & Data Section
                    _buildSectionHeader('Account & Data', Icons.person),
                    _buildSettingsCard([
                      _buildActionTile(
                        'Export Data',
                        'Export your scan history',
                        Icons.file_download,
                        () => _showExportDialog(),
                      ),
                      _buildActionTile(
                        'Clear Cache',
                        'Free up storage space',
                        Icons.cleaning_services,
                        () => _showClearCacheDialog(),
                      ),
                      _buildActionTile(
                        'Backup & Sync',
                        'Sync your data across devices',
                        Icons.cloud_sync,
                        () => _showBackupDialog(),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Support & About Section
                    _buildSectionHeader('Support & About', Icons.help),
                    _buildSettingsCard([
                      _buildActionTile(
                        'Help & FAQ',
                        'Get help and find answers',
                        Icons.help_outline,
                        () => _showHelpDialog(),
                      ),
                      _buildActionTile(
                        'Contact Support',
                        'Get in touch with our team',
                        Icons.support_agent,
                        () => _showContactDialog(),
                      ),
                      _buildActionTile(
                        'About',
                        'App version and information',
                        Icons.info_outline,
                        () => _showAboutDialog(),
                      ),
                    ]),

                    const SizedBox(height: 30),

                    // Reset Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _showResetDialog(),
                        icon: const Icon(Icons.restore, color: Colors.white),
                        label: const Text('Reset All Settings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Update all AppColors.greenButtonPrimary and similar usages in _buildSectionHeader, _buildSettingsCard, etc. to use colorController.buttonPrimaryColor
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 24, color: colorController.buttonPrimaryColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorController.buttonPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color:
            colorController.isDarkMode.value ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorController.buttonPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorController.buttonPrimaryColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color:
              colorController.isDarkMode.value ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color:
              colorController.isDarkMode.value
                  ? Colors.white70
                  : Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: colorController.buttonPrimaryColor,
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    IconData icon,
    double value,
    Function(double) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorController.buttonPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorController.buttonPrimaryColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color:
              colorController.isDarkMode.value ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color:
                  colorController.isDarkMode.value
                      ? Colors.white70
                      : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: colorController.buttonPrimaryColor,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            label: '${(value * 100).toInt()}%',
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorController.buttonPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorController.buttonPrimaryColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color:
              colorController.isDarkMode.value ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color:
              colorController.isDarkMode.value
                  ? Colors.white70
                  : Colors.grey[600],
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorController.buttonPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorController.buttonPrimaryColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color:
              colorController.isDarkMode.value ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color:
              colorController.isDarkMode.value
                  ? Colors.white70
                  : Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Export Data'),
            content: const Text('Export your scan history and settings?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add export functionality
                },
                child: const Text('Export'),
              ),
            ],
          ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cache'),
            content: const Text(
              'This will free up storage space but may slow down the app temporarily.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add clear cache functionality
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Backup & Sync'),
            content: const Text(
              'Sync your data with cloud storage to access it across devices.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add backup functionality
                },
                child: const Text('Sync'),
              ),
            ],
          ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Help & FAQ'),
            content: const Text(
              'Visit our help center for detailed guides and frequently asked questions.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Open help center
                },
                child: const Text('Visit'),
              ),
            ],
          ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Contact Support'),
            content: const Text(
              'Get in touch with our support team for assistance.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Open contact form
                },
                child: const Text('Contact'),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Plant Care AI'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Version: 1.0.0'),
                SizedBox(height: 8),
                Text(
                  'Your AI-powered plant disease detection and species classification companion.',
                ),
                SizedBox(height: 8),
                Text('© 2024 Plant Care AI Team'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset All Settings'),
            content: const Text(
              'This will reset all settings to their default values. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Reset all settings
                  setState(() {
                    _notificationsEnabled = true;
                    _darkModeEnabled = false;
                    _autoSaveResults = true;
                    _highQualityImages = true;
                    _soundEnabled = true;
                    _selectedLanguage = 'English';
                    _cameraQuality = 0.8;
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }
}

// Custom painter for settings pattern in header
class SettingsPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Draw gear patterns
    final center1 = Offset(size.width * 0.2, size.height * 0.3);
    final center2 = Offset(size.width * 0.8, size.height * 0.7);

    // Gear 1
    canvas.drawCircle(center1, 20, paint);
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final start = Offset(
        center1.dx + 15 * cos(angle),
        center1.dy + 15 * sin(angle),
      );
      final end = Offset(
        center1.dx + 25 * cos(angle),
        center1.dy + 25 * sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }

    // Gear 2
    canvas.drawCircle(center2, 15, paint);
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (3.14159 / 180);
      final start = Offset(
        center2.dx + 10 * cos(angle),
        center2.dy + 10 * sin(angle),
      );
      final end = Offset(
        center2.dx + 20 * cos(angle),
        center2.dy + 20 * sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper function for cos/sin
double cos(double angle) => angle.cos();
double sin(double angle) => angle.sin();

extension on double {
  double cos() => math.cos(this);
  double sin() => math.sin(this);
}
