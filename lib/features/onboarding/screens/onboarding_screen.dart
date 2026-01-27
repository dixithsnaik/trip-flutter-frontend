import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _vehicleController = TextEditingController();

  final List<Map<String, dynamic>> _travelInterests = [
    {'name': 'Solo Rider', 'icon': Icons.two_wheeler},
    {'name': 'Touring Enthusiast', 'icon': Icons.language},
    {'name': 'Coast', 'icon': Icons.water},
    {'name': 'Responsible Cruiser', 'icon': Icons.traffic},
    {'name': 'Group Rider', 'icon': Icons.people},
    {'name': 'Off-road', 'icon': Icons.landscape},
    {'name': 'Scenic Road Explorer', 'icon': Icons.nature},
    {'name': 'Moto Camper', 'icon': Icons.terrain},
    {'name': 'Daytime Rider', 'icon': Icons.wb_sunny},
    {'name': 'Mountain Explorer', 'icon': Icons.terrain},
    {'name': 'City Rider', 'icon': Icons.location_city},
    {'name': 'Slow & Steady Traveler', 'icon': Icons.directions_bike},
    {'name': 'Nature & Wildlife Rider', 'icon': Icons.pets},
    {'name': 'Foodie Tourer', 'icon': Icons.restaurant},
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthRegister(
            fullName: _fullNameController.text,
            username: _usernameController.text,
            phoneNumber: _phoneController.text,
            dob: _dobController.text,
            gender: context.read<AuthBloc>().state.selectedGender,
            vehicle: _vehicleController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, AppConstants.routeHome);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: AppStrings.onboardingTitle),
        body: BackgroundWidget(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSizes.spacingLarge),
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusLarge,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 64,
                              color: AppColors.textWhite,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.textPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXXLarge),
                    CustomTextField(
                      controller: _fullNameController,
                      hintText: AppStrings.enterFullName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: AppStrings.enterUsername,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: AppSizes.inputHeight,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMedium,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+91',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacingSmall),
                        Expanded(
                          flex: 3,
                          child: CustomTextField(
                            controller: _phoneController,
                            hintText: AppStrings.enterPhone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: AppSizes.inputHeight,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMedium,
                              ),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacingSmall),
                        Expanded(
                          flex: 3,
                          child: CustomTextField(
                            controller: _dobController,
                            hintText: AppStrings.enterDOB,
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                _dobController.text =
                                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select date of birth';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    // Gender Selection
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Row(
                          children: ['Male', 'Female', 'Other'].map((gender) {
                            final isSelected = state.selectedGender == gender;
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.spacingXSmall,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<AuthBloc>().add(
                                      AuthSelectGender(gender),
                                    );
                                  },
                                  child: Container(
                                    height: AppSizes.inputHeight,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.backgroundLight,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusMedium,
                                      ),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        gender,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.textWhite
                                              : AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    CustomTextField(
                      controller: _vehicleController,
                      hintText: AppStrings.vehiclePlaceholder,
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    // Travel Interests
                    Text(
                      AppStrings.travelInterest,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Wrap(
                          spacing: AppSizes.spacingSmall,
                          runSpacing: AppSizes.spacingSmall,
                          children: _travelInterests.map((interest) {
                            final isSelected = state.selectedInterests.contains(
                              interest['name'],
                            );
                            return GestureDetector(
                              onTap: () => context.read<AuthBloc>().add(
                                    AuthToggleInterest(
                                      interest['name'] as String,
                                    ),
                                  ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.spacingMedium,
                                  vertical: AppSizes.spacingSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.backgroundLight,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusRound,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      interest['icon'] as IconData,
                                      size: 16,
                                      color: isSelected
                                          ? AppColors.textWhite
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(
                                      width: AppSizes.spacingXSmall,
                                    ),
                                    Text(
                                      interest['name'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? AppColors.textWhite
                                            : AppColors.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingXXLarge),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: AppStrings.register,
                          onPressed: _handleRegister,
                          isLoading: state.status == AuthStatus.loading,
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
