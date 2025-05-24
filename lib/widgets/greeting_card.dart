import 'package:flutter/material.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFE3E6FF), Color(0xFFF5F0FF)],
          ),
        ),
        child: Column(
          children: const [
            Icon(Icons.volunteer_activism,
                size: 48, color: Color(0xFF0D4C92)),
            SizedBox(height: 12),
            Text('Welcome To Bantoo!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 4),
            Text('Username',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D4C92))),
            SizedBox(height: 4),
            SizedBox(
              width: 220,
              child: Text(
                'Sharing together for Bantoo! those in need',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
