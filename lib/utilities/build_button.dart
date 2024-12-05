import 'package:flutter/material.dart';

Widget buildButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  double width = 250, // Default button width
  double height = 60, // Default button height
}) {
  return ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, color: Colors.white, size: 24),
    label: Text(
      label,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      textAlign: TextAlign.start,
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF8BC34A), // Lemon green button shade
      padding: EdgeInsets.zero, // No padding since we're defining size
      minimumSize: Size(width, height), // Standard width and height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 4,
    ),
  );
}
