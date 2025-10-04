import 'package:flutter/material.dart';

class CurvedGreenDesign extends StatelessWidget {
  const CurvedGreenDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: CurvedGreenPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class CurvedGreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A7C59) // Dark green color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Start from bottom left
    path.moveTo(0, size.height);
    
    // Draw left side up to the curve
    path.lineTo(0, size.height * 0.3);
    
    // Create the curved section using quadratic bezier curves
    // First curve (left side going up)
    path.quadraticBezierTo(
      size.width * 0.3, // Control point x
      size.height * 0.25, // Control point y
      size.width * 0.5, // End point x
      size.height * 0.35, // End point y
    );
    
    // Second curve (right side going down)
    path.quadraticBezierTo(
      size.width * 0.7, // Control point x
      size.height * 0.45, // Control point y
      size.width, // End point x
      size.height * 0.25, // End point y
    );
    
    // Draw right side down to bottom
    path.lineTo(size.width, size.height);
    
    // Close the path
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Alternative implementation using ClipPath
class CurvedGreenDesignClipPath extends StatelessWidget {
  const CurvedGreenDesignClipPath({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ClipPath(
        clipper: CurvedGreenClipper(),
        child: Container(
          color: const Color(0xFF4A7C59),
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class CurvedGreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Start from bottom left
    path.moveTo(0, size.height);
    
    // Draw left side up to the curve
    path.lineTo(0, size.height * 0.3);
    
    // Create the curved section
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.35,
    );
    
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.45,
      size.width,
      size.height * 0.25,
    );
    
    // Draw right side down to bottom
    path.lineTo(size.width, size.height);
    
    // Close the path
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

