import 'package:flutter/material.dart';

class BannerAddCampaign extends StatelessWidget {
  const BannerAddCampaign({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/banner.jpg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned.fill(child: Container(color: Colors.black38)),
            Center(
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/add_donasi'),
                child: const Text('Bantoo!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
