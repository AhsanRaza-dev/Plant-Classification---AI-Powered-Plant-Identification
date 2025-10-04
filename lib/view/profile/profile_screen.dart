import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/view/profile/edit_profile.dart';
import '../../controllers/color_controller.dart';
import '../settings/settings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorController = Get.find<ColorSchemeController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          colorController.isDarkMode.value ? Colors.black : Colors.grey[50],
      body: Obx(
        () => CustomScrollView(
          slivers: [
            // Modern App Bar with plant theme
            SliverAppBar(
              expandedHeight: size.height * 0.3,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: colorController.buttonPrimaryColor,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AppSettings()),
                      ),
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
                IconButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
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
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Profile Picture with plant border
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.eco, size: 50, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ahsan Raza',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Plant Expert • Level 3',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Plant Activity Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Plants Scanned',
                            '156',
                            Icons.camera_alt,
                            colorController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Diseases Found',
                            '23',
                            Icons.bug_report,
                            colorController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Plants Saved',
                            '89',
                            Icons.favorite,
                            colorController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Achievements Card
                    _buildInfoCard('Achievements', Icons.emoji_events, [
                      _buildAchievementRow(
                        Icons.camera,
                        'First Scan',
                        'Completed your first plant scan',
                        true,
                      ),
                      _buildAchievementRow(
                        Icons.local_florist,
                        'Plant Lover',
                        'Scanned 50+ plants',
                        true,
                      ),
                      _buildAchievementRow(
                        Icons.healing,
                        'Disease Detective',
                        'Found 10+ diseases',
                        true,
                      ),
                      _buildAchievementRow(
                        Icons.star,
                        'Expert Scanner',
                        'Scan 100+ plants',
                        false,
                      ),
                    ], colorController),

                    const SizedBox(height: 20),

                    // Personal Information Card
                    _buildInfoCard(
                      'Personal Information',
                      Icons.person_outline,
                      [
                        _buildInfoRow(
                          Icons.email,
                          'Email',
                          'ahsan.raza@email.com',
                        ),
                        _buildInfoRow(Icons.phone, 'Phone', '+92 300 1234567'),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Joined',
                          'January 2024',
                        ),
                        _buildInfoRow(
                          Icons.location_on,
                          'Location',
                          'Gujranwala, Punjab',
                        ),
                        _buildInfoRow(
                          Icons.eco,
                          'Expertise',
                          'Fruit Trees & Vegetables',
                        ),
                      ],
                      colorController,
                    ),

                    const SizedBox(height: 20),

                    // Plant Care Settings
                    _buildInfoCard(
                      'Plant Care Settings',
                      Icons.settings_outlined,
                      [
                        _buildActionRow(
                          Icons.notifications_active,
                          'Care Reminders',
                          () {},
                        ),
                        _buildActionRow(
                          Icons.wb_sunny,
                          'Weather Alerts',
                          () {},
                        ),
                        _buildActionRow(
                          Icons.language,
                          'Plant Names Language',
                          () {},
                        ),
                        _buildActionRow(
                          Icons.help_outline,
                          'Plant Care Guide',
                          () {},
                        ),
                      ],
                      colorController,
                    ),

                    const SizedBox(height: 20),

                    // Recent Scans Activity
                    _buildInfoCard('Recent Scans', Icons.history, [
                      _buildScanActivityRow(
                        'Rose - Black Spot Disease',
                        '2 hours ago',
                        true,
                      ),
                      _buildScanActivityRow(
                        'Tomato - Healthy',
                        '1 day ago',
                        false,
                      ),
                      _buildScanActivityRow(
                        'Wheat - Rust Disease',
                        '3 days ago',
                        true,
                      ),
                      _buildScanActivityRow(
                        'Mango - Leaf Spot',
                        '1 week ago',
                        true,
                      ),
                    ], colorController),

                    const SizedBox(height: 20),

                    // My Garden Card
                    _buildInfoCard('My Garden', Icons.grass, [
                      _buildGardenRow('Roses', '5 plants', Colors.pink),
                      _buildGardenRow('Tomatoes', '8 plants', Colors.red),
                      _buildGardenRow('Herbs', '12 plants', Colors.green),
                      _buildGardenRow('Fruit Trees', '3 plants', Colors.orange),
                    ], colorController),

                    const SizedBox(height: 24),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    ColorSchemeController colorController,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            colorController.isDarkMode.value ? Colors.grey[900] : Colors.white,
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
          Icon(icon, color: colorController.buttonPrimaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  colorController.isDarkMode.value
                      ? Colors.white
                      : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color:
                  colorController.isDarkMode.value
                      ? Colors.white70
                      : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    IconData icon,
    List<Widget> children,
    ColorSchemeController colorController,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: colorController.buttonPrimaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
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
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementRow(
    IconData icon,
    String title,
    String description,
    bool isCompleted,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (isCompleted)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _buildScanActivityRow(String plantInfo, String time, bool hasDisease) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: hasDisease ? Colors.red : Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plantInfo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(
            hasDisease ? Icons.warning : Icons.check_circle,
            color: hasDisease ? Colors.red : Colors.green,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildGardenRow(String plantType, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              plantType,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Logout'),
            content: const Text(
              'Are you sure you want to logout from Plant Care?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.offAllNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
