import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:image/image.dart' as img;

class ModelService {
  static Interpreter? _tfliteInterpreter;
  static ClassificationModel? _pytorchModel;
  static List<String>? _speciesLabels;
  static List<String>? _diseaseLabels;

  // Initialize both models
  static Future<bool> initializeModels() async {
    try {
      // Load TFLite model for species classification
      await _loadTFLiteModel();

      // Load PyTorch model for disease classification
      await _loadPyTorchModel();

      // Load labels
      await _loadAllLabels();

      return true;
    } catch (e) {
      print('Error initializing models: $e');
      return false;
    }
  }

  // Load TFLite model (.tflite converted from .keras)
  static Future<void> _loadTFLiteModel() async {
    try {
      _tfliteInterpreter = await Interpreter.fromAsset(
        'assets/models/species_model.tflite',
      );
      print('TFLite model loaded successfully');
    } catch (e) {
      print('Error loading TFLite model: $e');
      rethrow;
    }
  }

  // Load PyTorch model for classification (not object detection)
  static Future<void> _loadPyTorchModel() async {
    try {
      _pytorchModel = await PytorchLite.loadClassificationModel(
        "assets/models/plant_disease_model.ptl",
        38,
        224, // input width
        224,
        // input height
        labelPath: "assets/models/disease_labels.txt",
      );
      print('PyTorch model loaded successfully');
    } catch (e) {
      print('Error loading PyTorch model: $e');
      rethrow;
    }
  }

  // Load all label files
  static Future<void> _loadAllLabels() async {
    try {
      _speciesLabels = await _loadLabels('assets/models/species_labels.txt');
      _diseaseLabels = await _loadLabels('assets/models/disease_labels.txt');
      print('Labels loaded successfully');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  // Preprocess image for TFLite model
  static Float32List preprocessImageForTFLite(
    File imageFile,
    int targetWidth,
    int targetHeight,
  ) {
    // Read image
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize image
    img.Image resizedImage = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
    );

    // Convert to Float32List normalized between 0 and 1
    var convertedBytes = Float32List(1 * targetHeight * targetWidth * 3);
    int pixelIndex = 0;

    for (int y = 0; y < targetHeight; y++) {
      for (int x = 0; x < targetWidth; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        convertedBytes[pixelIndex++] = (pixel.r / 255.0);
        convertedBytes[pixelIndex++] = (pixel.g / 255.0);
        convertedBytes[pixelIndex++] = (pixel.b / 255.0);
      }
    }

    return convertedBytes;
  }

  // Species classification using TFLite model
  static Future<Map<String, dynamic>> classifySpecies(File imageFile) async {
    if (_tfliteInterpreter == null) {
      throw Exception('TFLite model not initialized');
    }

    try {
      // Get model input shape
      var inputTensors = _tfliteInterpreter!.getInputTensors();
      var inputShape = inputTensors.first.shape;
      int inputHeight = inputShape[1];
      int inputWidth = inputShape[2];

      // Preprocess image
      var inputData = preprocessImageForTFLite(
        imageFile,
        inputWidth,
        inputHeight,
      );

      // Reshape input data
      var input = inputData.reshape([1, inputHeight, inputWidth, 3]);

      // Get output shape
      var outputTensors = _tfliteInterpreter!.getOutputTensors();
      var outputShape = outputTensors.first.shape;
      int numClasses = outputShape[1];

      // Prepare output tensor
      var output = List.filled(1 * numClasses, 0.0).reshape([1, numClasses]);

      // Run inference
      _tfliteInterpreter!.run(input, output);

      // Process results
      List<double> confidences = List<double>.from(output[0]);

      // Apply softmax if needed
      confidences = _applySoftmax(confidences);

      // Find top prediction
      double maxConfidence = confidences.reduce((a, b) => a > b ? a : b);
      int maxIndex = confidences.indexOf(maxConfidence);

      // Get labels
      List<String> labels =
          _speciesLabels ??
          List.generate(numClasses, (index) => 'Species_$index');

      return {
        'prediction':
            maxIndex < labels.length ? labels[maxIndex] : 'Unknown_$maxIndex',
        'confidence': maxConfidence,
        'all_predictions': _getTopPredictions(confidences, labels, 3),
      };
    } catch (e) {
      print('Error in species classification: $e');
      rethrow;
    }
  }

  // Disease classification using PyTorch model
  static Future<Map<String, dynamic>> classifyDisease(File imageFile) async {
    if (_pytorchModel == null) {
      throw Exception('PyTorch model not initialized');
    }

    try {
      // Run inference using PyTorch Lite
      String result = await _pytorchModel!.getImagePrediction(
        await File(imageFile.path).readAsBytes(),
      );

      // Parse the result (PyTorch Lite returns prediction as string)
      // The result format might be "class_name:confidence" or just "class_name"
      String prediction = result;
      double confidence = 1.0;

      // Try to extract confidence if available
      if (result.contains(':')) {
        List<String> parts = result.split(':');
        prediction = parts[0];
        confidence = double.tryParse(parts[1]) ?? 1.0;
      }

      return {
        'prediction': prediction,
        'confidence': confidence,
        'all_predictions': [
          {'class': prediction, 'confidence': confidence},
        ],
      };
    } catch (e) {
      print('Error in disease classification: $e');

      // Fallback: try using PyTorch as classification model with manual processing
      try {
        return await _classifyDiseaseManual(imageFile);
      } catch (fallbackError) {
        print('Fallback classification also failed: $fallbackError');
        throw e;
      }
    }
  }

  // Manual disease classification if direct method fails
  static Future<Map<String, dynamic>> _classifyDiseaseManual(
    File imageFile,
  ) async {
    try {
      // Read image bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Get prediction (this depends on your specific PyTorch model implementation)
      String result = await _pytorchModel!.getImagePrediction(imageBytes);

      // Process result
      List<String> labels =
          _diseaseLabels ?? ['Healthy', 'Disease_1', 'Disease_2'];

      // If result is numeric, treat as class index
      int? classIndex = int.tryParse(result);
      if (classIndex != null && classIndex < labels.length) {
        return {
          'prediction': labels[classIndex],
          'confidence': 0.8, // Default confidence
          'all_predictions': [
            {'class': labels[classIndex], 'confidence': 0.8},
          ],
        };
      }

      // Otherwise, treat as class name
      return {
        'prediction': result,
        'confidence': 0.8,
        'all_predictions': [
          {'class': result, 'confidence': 0.8},
        ],
      };
    } catch (e) {
      throw Exception('Manual disease classification failed: $e');
    }
  }

  // Apply softmax to convert logits to probabilities
  static List<double> _applySoftmax(List<double> logits) {
    // Find max value for numerical stability
    double maxLogit = logits.reduce((a, b) => a > b ? a : b);

    // Compute exp(logit - max) for each logit
    List<double> expLogits =
        logits.map((logit) => math.exp(logit - maxLogit)).toList();

    // Compute sum of exp values
    double sumExp = expLogits.reduce((a, b) => a + b);

    // Normalize to get probabilities
    return expLogits.map((exp) => exp / sumExp).toList();
  }

  // Helper method to load labels from file
  static Future<List<String>> _loadLabels(String path) async {
    try {
      final labelsData = await rootBundle.loadString(path);
      return labelsData
          .split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error loading labels from $path: $e');
      return []; // Return empty list if file not found
    }
  }

  // Helper method to get top predictions
  static List<Map<String, dynamic>> _getTopPredictions(
    List<double> confidences,
    List<String> labels,
    int topK,
  ) {
    List<Map<String, dynamic>> predictions = [];

    for (int i = 0; i < confidences.length; i++) {
      predictions.add({
        'class': i < labels.length ? labels[i] : 'Class_$i',
        'confidence': confidences[i],
      });
    }

    predictions.sort((a, b) => b['confidence'].compareTo(a['confidence']));
    return predictions.take(topK).toList();
  }

  // Get model information
  static Map<String, dynamic> getModelInfo() {
    Map<String, dynamic> info = {
      'tflite_loaded': _tfliteInterpreter != null,
      'pytorch_loaded': _pytorchModel != null,
      'species_labels_count': _speciesLabels?.length ?? 0,
      'disease_labels_count': _diseaseLabels?.length ?? 0,
    };

    if (_tfliteInterpreter != null) {
      var inputTensors = _tfliteInterpreter!.getInputTensors();
      var outputTensors = _tfliteInterpreter!.getOutputTensors();

      info['tflite_input_shape'] = inputTensors.first.shape;
      info['tflite_output_shape'] = outputTensors.first.shape;
      info['tflite_input_type'] = inputTensors.first.type.toString();
      info['tflite_output_type'] = outputTensors.first.type.toString();
    }

    return info;
  }

  // Dispose models and free resources
  static void dispose() {
    try {
      _tfliteInterpreter?.close();
      _tfliteInterpreter = null;

      // PyTorch model disposal (if available in the library)
      _pytorchModel = null;

      _speciesLabels = null;
      _diseaseLabels = null;

      print('Models disposed successfully');
    } catch (e) {
      print('Error disposing models: $e');
    }
  }
}
