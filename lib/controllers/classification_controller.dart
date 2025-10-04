import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plant_app/Services/model_services.dart';

class ClassificationController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  var isLoading = false.obs;
  var modelsInitialized = false.obs;
  var selectedImage = Rx<File?>(null);
  var speciesResult = Rx<Map<String, dynamic>?>(null);
  var diseaseResult = Rx<Map<String, dynamic>?>(null);
  var isProcessingSpecies = false.obs;
  var isProcessingDisease = false.obs;
  var modelInfo = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    initializeModels();
  }

  // Initialize ML models
  Future<void> initializeModels() async {
    try {
      isLoading.value = true;
      bool success = await ModelService.initializeModels();
      modelsInitialized.value = success;

      if (success) {
        // Get model information
        modelInfo.value = ModelService.getModelInfo();

        Get.snackbar(
          'Success',
          'Models loaded successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load models',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to initialize models: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Retry model initialization
  Future<void> retryInitialization() async {
    await initializeModels();
  }

  // Check and request camera permission
  Future<bool> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Required',
        'Camera permission is permanently denied. Please enable it in settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return false;
    }

    return status.isGranted;
  }

  // Check and request storage permission
  Future<bool> _checkStoragePermission() async {
    var status = await Permission.storage.status;

    // For Android 13+ (API 33+), we need different permissions
    if (Platform.isAndroid) {
      if (await Permission.photos.status.isDenied) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.photos.status;
      }
    } else {
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    }

    if (status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Required',
        'Storage permission is permanently denied. Please enable it in settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return false;
    }

    return status.isGranted;
  }

  // Capture image from camera
  Future<void> captureFromCamera() async {
    try {
      bool hasPermission = await _checkCameraPermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Denied',
          'Camera permission is required to capture images',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        // Clear previous results
        _clearResults();

        Get.snackbar(
          'Image Captured',
          'Image captured successfully. You can now classify it.',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      bool hasPermission = await _checkStoragePermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to access gallery',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        // Clear previous results
        _clearResults();

        Get.snackbar(
          'Image Selected',
          'Image selected successfully. You can now classify it.',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Show image source selection dialog
  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              subtitle: const Text('Take a new photo'),
              onTap: () {
                Get.back();
                captureFromCamera();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              subtitle: const Text('Choose from gallery'),
              onTap: () {
                Get.back();
                pickFromGallery();
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  // Classify plant species
  Future<void> classifySpecies() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'No Image',
        'Please select an image first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!modelsInitialized.value) {
      Get.snackbar(
        'Models Not Ready',
        'Please wait for models to initialize',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isProcessingSpecies.value = true;

      final result = await ModelService.classifySpecies(selectedImage.value!);
      speciesResult.value = result;

      Get.snackbar(
        'Classification Complete',
        'Species: ${result['prediction']} (${(result['confidence'] * 100).toStringAsFixed(1)}%)',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to classify species: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isProcessingSpecies.value = false;
    }
  }

  // Classify plant disease
  Future<void> classifyDisease() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'No Image',
        'Please select an image first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!modelsInitialized.value) {
      Get.snackbar(
        'Models Not Ready',
        'Please wait for models to initialize',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isProcessingDisease.value = true;

      final result = await ModelService.classifyDisease(selectedImage.value!);
      diseaseResult.value = result;

      Get.snackbar(
        'Classification Complete',
        'Disease: ${result['prediction']} (${(result['confidence'] * 100).toStringAsFixed(1)}%)',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to classify disease: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isProcessingDisease.value = false;
    }
  }

  // Classify both species and disease
  Future<void> classifyBoth() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'No Image',
        'Please select an image first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!modelsInitialized.value) {
      Get.snackbar(
        'Models Not Ready',
        'Please wait for models to initialize',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Run both classifications
    await Future.wait([classifySpecies(), classifyDisease()]);
  }

  // Clear current image and results
  void clearImage() {
    selectedImage.value = null;
    _clearResults();

    Get.snackbar(
      'Cleared',
      'Image and results cleared',
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  // Helper method to clear results
  void _clearResults() {
    speciesResult.value = null;
    diseaseResult.value = null;
  }

  // Get formatted species result
  String getSpeciesResultText() {
    if (speciesResult.value == null) return 'No classification yet';

    final result = speciesResult.value!;
    final confidence = (result['confidence'] * 100).toStringAsFixed(1);
    return '${result['prediction']} ($confidence%)';
  }

  // Get formatted disease result
  String getDiseaseResultText() {
    if (diseaseResult.value == null) return 'No classification yet';

    final result = diseaseResult.value!;
    final confidence = (result['confidence'] * 100).toStringAsFixed(1);
    return '${result['prediction']} ($confidence%)';
  }

  // Get model status text
  String getModelStatusText() {
    if (isLoading.value) return 'Loading models...';
    if (!modelsInitialized.value) return 'Models failed to load';

    final info = modelInfo.value;
    if (info == null) return 'Models ready';

    return 'TFLite: ${info['tflite_loaded'] ? 'Ready' : 'Failed'}, '
        'PyTorch: ${info['pytorch_loaded'] ? 'Ready' : 'Failed'}';
  }

  // Check if image is selected
  bool get hasImage => selectedImage.value != null;

  // Check if any classification is in progress
  bool get isProcessing =>
      isProcessingSpecies.value || isProcessingDisease.value;

  // Check if ready to classify
  bool get canClassify => hasImage && modelsInitialized.value && !isProcessing;

  @override
  void onClose() {
    ModelService.dispose();
    super.onClose();
  }
}
