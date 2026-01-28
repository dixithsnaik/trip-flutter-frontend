import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:tpconnect/features/trip/widgets/map_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/navigation_helper.dart';
import '../bloc/trip_bloc.dart';
import '../bloc/trip_event.dart';
import '../bloc/trip_state.dart';

class TripDetailScreen extends StatefulWidget {
  final String tripName;

  const TripDetailScreen({super.key, required this.tripName});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool _showCheckpoints = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tripId = 'trip_1'; // In real app, get from route args

    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state.status == TripStatus.started) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Trip started')));
          NavigationHelper.safePop(context);
        } else if (state.status == TripStatus.cancelled) {
          NavigationHelper.safePop(context);
        } else if (state.status == TripStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error')),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                    vertical: AppSizes.spacingMedium,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textWhite,
                        ),
                        onPressed: () => NavigationHelper.safePop(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tripName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                            const SizedBox(height: AppSizes.spacingXSmall),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryLight,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 20,
                                          color: AppColors.textWhite,
                                        ),
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
                                              BorderSide(
                                                color: AppColors.primaryDark,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            size: 20,
                                            color: AppColors.textWhite,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text(
                                  '+3 more',
                                  style: TextStyle(
                                    color: AppColors.textWhite,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.link,
                                    color: AppColors.textWhite,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Invite Friends',
                                    style: TextStyle(
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.textWhite,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.spacingSmall),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    color: AppColors.textWhite,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppConstants.routeChatDetail,
                                      arguments: {
                                        'tripName': widget.tripName,
                                        'date': '21/10/25',
                                      },
                                    );
                                  },
                                ),
                                const Text(
                                  'Chats',
                                  style: TextStyle(color: AppColors.textWhite),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Tabs
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showCheckpoints = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: _showCheckpoints
                                  ? AppColors.textWhite
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMedium,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Checkpoints',
                                style: TextStyle(
                                  color: _showCheckpoints
                                      ? AppColors.primary
                                      : AppColors.textWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showCheckpoints = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: !_showCheckpoints
                                  ? AppColors.textWhite
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMedium,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Route Map',
                                style: TextStyle(
                                  color: !_showCheckpoints
                                      ? AppColors.primary
                                      : AppColors.textWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spacingMedium),
                // Map/Content Area
                Expanded(
                  child: _showCheckpoints
                      ? _buildCheckpointsView(context)
                      : _buildMapView(),
                ),
                // Bottom Actions
                Container(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  decoration: const BoxDecoration(
                    gradient: AppColors.headerGradient,
                  ),
                  child: BlocBuilder<TripBloc, TripState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel Trip',
                              backgroundColor: AppColors.error,
                              isOutlined: true,
                              textColor: AppColors.textWhite,
                              onPressed: state.status == TripStatus.loading
                                  ? null
                                  : () {
                                      context.read<TripBloc>().add(
                                        CancelTripEvent(tripId: tripId),
                                      );
                                    },
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingMedium),
                          Expanded(
                            child: CustomButton(
                              text: 'Start Trip',
                              backgroundColor: AppColors.success,
                              onPressed: state.status == TripStatus.loading
                                  ? null
                                  : () {
                                      context.read<TripBloc>().add(
                                        StartTripEvent(tripId: tripId),
                                      );
                                    },
                              isLoading: state.status == TripStatus.loading,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return MapView(
      locations: [
        LatLng(12.2958, 76.6394),
        LatLng(12.9784, 77.5713),
        LatLng(13.0827, 80.2707),
      ],
    );
  }

  Widget _buildCheckpointsView(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(
      builder: (context, state) {
        if (state.status == TripStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.trips.isEmpty) {
          return const Center(child: Text('No trip data available'));
        }

        final trip = state.trips.first; // Get first trip for now
        final checkpoints = trip.checkpoints;

        if (checkpoints.isEmpty) {
          return const Center(child: Text('No checkpoints available'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
              vertical: AppSizes.spacingMedium,
            ),
            child: Column(
              children: List.generate(checkpoints.length, (index) {
                final checkpoint = checkpoints[index];
                final isFirst = index == 0;
                final isLast = index == checkpoints.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Column
                    Column(
                      children: [
                        // Top Connector Line
                        if (!isFirst)
                          Container(
                            width: 2,
                            height: 20,
                            color: AppColors.textWhite,
                          ),
                        // Circle Dot
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                        // Bottom Connector Line
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 60,
                            color: AppColors.textWhite,
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSizes.spacingMedium),
                    // Content Column
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: isFirst ? 0 : AppSizes.spacingSmall,
                          bottom: isLast ? 0 : AppSizes.spacingMedium,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSmall,
                            ),
                          ),
                          padding: const EdgeInsets.all(AppSizes.spacingMedium),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                checkpoint.location,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              if (checkpoint.time != null)
                                Text(
                                  checkpoint.time!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
