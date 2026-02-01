import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class JoinTripScreen extends StatelessWidget {
  JoinTripScreen({super.key});

  final TextEditingController tripCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Trip')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter Trip Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            TextField(
              controller: tripCodeController,
              decoration: InputDecoration(
                hintText: 'e.g. TRIP123',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingMedium,
                ),
              ),
              onPressed: () {
                final code = tripCodeController.text.trim();

                if (code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a trip code')),
                  );
                  return;
                }

                Navigator.pop(context);
              },
              child: const Text(
                'Join',
                style: TextStyle(color: AppColors.textWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
