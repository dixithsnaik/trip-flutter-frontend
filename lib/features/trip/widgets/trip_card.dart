import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';

class TripCard extends StatelessWidget {
  final String tripName;
  final String date;
  final List<String> checkpoints;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.tripName,
    required this.date,
    required this.checkpoints,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatars
                  Stack(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 20, color: AppColors.textWhite),
                      ),
                      Positioned(
                        left: 20,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: AppColors.backgroundLight, width: 2),
                            ),
                          ),
                          child: const Icon(Icons.person, size: 20, color: AppColors.textWhite),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tripName,
                          style: AppTextStyles.tripTitle,
                        ),
                        const SizedBox(height: AppSizes.spacingXSmall),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: AppSizes.spacingXSmall),
                            Text(
                              date,
                              style: AppTextStyles.tripDate,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: AppColors.success, size: 24),
                ],
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              // Checkpoints
              ...checkpoints.asMap().entries.map((entry) {
                final index = entry.key;
                final checkpoint = entry.value;
                final isLast = index == checkpoints.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.textWhite,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 40,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSizes.spacingMedium),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.spacingSmall),
                        child: Text(
                          checkpoint,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

