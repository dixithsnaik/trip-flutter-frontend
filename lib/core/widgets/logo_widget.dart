import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class LogoWidget extends StatelessWidget {
  final double? iconSize;
  final double? fontSize;
  final bool showTagline;

  const LogoWidget({
    super.key,
    this.iconSize,
    this.fontSize,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.two_wheeler, size: iconSize ?? 64, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          AppConstants.appName,
          style: AppTextStyles.appTitle.copyWith(
            color: AppColors.primary,
            fontSize: fontSize ?? 24,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 8),
          Text(AppConstants.appTagline, style: AppTextStyles.appTagline),
        ],
      ],
    );
  }
}
