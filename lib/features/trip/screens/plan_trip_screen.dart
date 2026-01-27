import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/utils/navigation_helper.dart';
import '../../../core/models/trip_model.dart';
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
  final _dateController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _tripNameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _handleCreateTrip(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final state = context.read<TripBloc>().state;
      if (state.newTripCheckpoints.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one location')),
        );
        return;
      }

      context.read<TripBloc>().add(
        CreateTripEvent(
          name: _tripNameController.text.trim(),
          date: _dateController.text.isNotEmpty ? _dateController.text : DateTime.now().toString(),
          description: _instructionsController.text.trim(),
          type: AppStrings.groupTrips, // Default or selected
        ),
      );
    }
  }

  void _selectLocation(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeChooseLocation).then((
      result,
    ) {
      if (result != null && result is String) {
        final checkpoint = Checkpoint(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result,
          location: result,
          time: '10:00 AM', // distinct default
        );
        context.read<TripBloc>().add(AddCheckpointEvent(checkpoint));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state.status == TripStatus.loaded && state.newTripCheckpoints.isEmpty) { 
           // Assuming empty checkpoints implies successful creation and reset, logic might need refinement 
           // but keeping it simple based on previous bloc logic which clears checkpoints on creation.
           // Ideally we should have a TripCreated event or status.
           if (ModalRoute.of(context)?.isCurrent == true) { // Check if still on screen
              NavigationHelper.safePop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trip created successfully')),
              );
           }
        } else if (state.status == TripStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Error')));
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: AppStrings.planTrip,
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
                    BlocBuilder<TripBloc, TripState>(
                      builder: (context, state) {
                        final checkpoints = state.newTripCheckpoints;
                        // Always show at least one "Choose Location" placeholder or button
                        // Logic: Show existing checkpoints + one "Add" button
                        
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column( // Timeline line
                              children: List.generate((checkpoints.length + 1) * 2, (index) {
                                if (index % 2 == 0) {
                                  return Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: index == 0 ? AppColors.primary : Colors.transparent,
                                      border: Border.all(color: AppColors.primary, width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                } else {
                                  return Container(
                                    width: 2,
                                    height: 35,
                                    color: AppColors.primary,
                                  );
                                }
                              }),
                            ),
                            const SizedBox(width: AppSizes.spacingMedium),
                            Expanded(
                              child: Column(
                                children: [
                                  ...checkpoints.asMap().entries.map((entry) {
                                    final checkpoint = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 25), // align with timeline
                                      child: Container(
                                        height: AppSizes.inputHeight,
                                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundLight,
                                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(child: Text(checkpoint.name, style: const TextStyle(color: AppColors.textPrimary))),
                                            IconButton(
                                              icon: const Icon(Icons.close, size: 20),
                                              onPressed: () {
                                                context.read<TripBloc>().add(RemoveCheckpointEvent(checkpoint));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  // Add Button
                                    GestureDetector(
                                      onTap: () => _selectLocation(context),
                                      child: Container(
                                        height: AppSizes.inputHeight,
                                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundLight.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(AppStrings.chooseLocation, style: TextStyle(color: AppColors.textLight)),
                                            const Spacer(),
                                            const Icon(Icons.add, color: AppColors.primary),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
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
                      // Date Picker
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                             _dateController.text = "${date.day}/${date.month}/${date.year}";
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomTextField(
                             controller: _dateController,
                             hintText: AppStrings.selectDate,
                             prefixIcon: const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                             validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                             },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Handle invite friends
                        },
                        icon: const Icon(Icons.link),
                        label: const Text(AppStrings.inviteFriends),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            AppSizes.buttonHeightMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),
                      // Friends List
                      BlocBuilder<TripBloc, TripState>(
                        builder: (context, state) {
                          return Wrap(
                            spacing: AppSizes.spacingSmall,
                            runSpacing: AppSizes.spacingSmall,
                            children: List.generate(5, (index) {
                              final friendName = 'Friend $index';
                              final isSelected = state.selectedFriends.contains(friendName);
                              return GestureDetector(
                                onTap: () {
                                  context.read<TripBloc>().add(ToggleTripFriendEvent(friendName));
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
                                    const Text(
                                      '@friend',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
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
                            text: AppStrings.createTrip,
                            onPressed: () => _handleCreateTrip(context),
                            isLoading: state.status == TripStatus.loading,
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
