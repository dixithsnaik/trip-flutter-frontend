import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/utils/navigation_helper.dart';
import '../bloc/trip_bloc.dart';
import '../bloc/trip_event.dart';
import '../bloc/trip_state.dart';

class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tripNameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final List<String> _locations = ['', '', ''];
  final List<String> _selectedFriends = [];

  @override
  void dispose() {
    _tripNameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _handleCreateTrip() {
    if (_formKey.currentState!.validate()) {
      final validLocations = _locations.where((loc) => loc.isNotEmpty).toList();
      if (validLocations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one location')),
        );
        return;
      }

      context.read<TripBloc>().add(
        CreateTripEvent(
          tripName: _tripNameController.text.trim(),
          locations: validLocations,
          friends: _selectedFriends,
          instructions: _instructionsController.text.trim(),
        ),
      );
    }
  }

  void _removeLocation(int index) {
    setState(() {
      _locations.removeAt(index);
    });
  }

  void _selectLocation(int index) {
    Navigator.pushNamed(context, AppConstants.routeChooseLocation).then((
      result,
    ) {
      if (result != null) {
        setState(() {
          _locations[index] = result as String;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state is TripCreated) {
          NavigationHelper.safePop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip created successfully')),
          );
        } else if (state is TripError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'PLAN TRIP',
          gradient: AppColors.headerGradient,
        ),
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
                    // Location Input Fields
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              color: AppColors.primary,
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              color: AppColors.primary,
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              color: AppColors.primary,
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: AppSizes.spacingMedium),
                        Expanded(
                          child: Column(
                            children: _locations.asMap().entries.map((entry) {
                              final index = entry.key;
                              final location = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSizes.spacingSmall,
                                ),
                                child: GestureDetector(
                                  onTap: () => _selectLocation(index),
                                  child: Container(
                                    height: AppSizes.inputHeight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.spacingMedium,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundLight,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusMedium,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            location.isEmpty
                                                ? 'Choose location'
                                                : location,
                                            style: TextStyle(
                                              color: location.isEmpty
                                                  ? AppColors.textLight
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        if (location.isNotEmpty)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              size: 20,
                                            ),
                                            onPressed: () =>
                                                _removeLocation(index),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    CustomTextField(
                      controller: _tripNameController,
                      hintText: AppConstants.placeholderTripName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter trip name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Handle invite friends
                      },
                      icon: const Icon(Icons.link),
                      label: const Text('Invite Friends'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          AppSizes.buttonHeightMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    // Friends List
                    Wrap(
                      spacing: AppSizes.spacingSmall,
                      runSpacing: AppSizes.spacingSmall,
                      children: List.generate(10, (index) {
                        final isSelected = _selectedFriends.contains(
                          'Friend $index',
                        );
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFriends.remove('Friend $index');
                              } else {
                                _selectedFriends.add('Friend $index');
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.success
                                            : AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isSelected ? Icons.check : Icons.add,
                                        size: 12,
                                        color: AppColors.textWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.spacingXSmall),
                              Text(
                                '@dixithsnaik',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    CustomTextField(
                      controller: _instructionsController,
                      hintText: AppConstants.placeholderInstructions,
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppSizes.spacingXSmall),
                    Text(
                      AppConstants.messageTripInstructions,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXXLarge),
                    BlocBuilder<TripBloc, TripState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Create Trip',
                          onPressed: _handleCreateTrip,
                          isLoading: state is TripLoading,
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
