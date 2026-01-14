import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/utils/navigation_helper.dart';

class ChooseLocationScreen extends StatelessWidget {
  const ChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = [
      'Bangalore',
      'Mysore',
      'Channarayapatna',
      'Kunigal Lake',
      'Charmadi Ghat',
      'Hyderabad',
      'Mumbai',
      'Delhi',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => NavigationHelper.safePop(context),
        ),
        title: const Text(
          'Choose the location',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppSizes.spacingSmall),
                padding: const EdgeInsets.all(AppSizes.spacingMedium),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: ListTile(
                  title: Text(locations[index]),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () {
                    NavigationHelper.safePop(context, locations[index]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
