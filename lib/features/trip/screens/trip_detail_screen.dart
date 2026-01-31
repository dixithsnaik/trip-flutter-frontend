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
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool _showCheckpoints = true;

  @override
  void initState() {
    super.initState();
    context.read<TripBloc>().add(LoadTripDetailsEvent(tripId: widget.tripId));
  }

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(),
                _buildTabs(),
                const SizedBox(height: AppSizes.spacingMedium),
                Expanded(
                  child: _showCheckpoints
                      ? _buildCheckpointsView()
                      : _buildMapView(),
                ),
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPadding,
        vertical: AppSizes.spacingMedium,
      ),
      child: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          final trip = state.selectedTrip;

          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
                onPressed: () => NavigationHelper.safePop(context),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip?.name ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: AppColors.textWhite,
                          ),
                          onPressed: trip == null
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                    context,
                                    AppConstants.routeChatDetail,
                                    arguments: {
                                      'tripName': trip.name,
                                      'date': trip.date,
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
          );
        },
      ),
    );
  }

  // ---------------- TABS ----------------

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showCheckpoints = true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: _showCheckpoints
                      ? AppColors.textWhite
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
              onTap: () => setState(() => _showCheckpoints = false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: !_showCheckpoints
                      ? AppColors.textWhite
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
    );
  }

  // ---------------- CHECKPOINTS ----------------

  Widget _buildCheckpointsView() {
    return BlocBuilder<TripBloc, TripState>(
      builder: (context, state) {
        if (state.status == TripStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final trip = state.selectedTrip;
        if (trip == null) {
          return const Center(child: Text('Trip not found'));
        }

        if (trip.checkpoints.isEmpty) {
          return const Center(child: Text('No checkpoints available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
            vertical: AppSizes.spacingMedium,
          ),
          itemCount: trip.checkpoints.length,
          itemBuilder: (context, index) {
            final checkpoint = trip.checkpoints[index];

            return Container(
              margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 2,
                      checkpoint.location,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        overflow: TextOverflow.ellipsis,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  if (checkpoint.time != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      checkpoint.time!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- MAP ----------------

  Widget _buildMapView() {
    return BlocBuilder<TripBloc, TripState>(
      builder: (context, state) {
        final trip = state.selectedTrip;

        if (trip == null || trip.checkpoints.isEmpty) {
          return const Center(child: Text('No route data'));
        }

        final locations = trip.checkpoints
            .where((c) => c.lat != null && c.lng != null)
            .map((c) => LatLng(c.lat!, c.lng!))
            .toList();

        return MapView(locations: locations);
      },
    );
  }

  // ---------------- ACTION BUTTONS ----------------

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
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
                            CancelTripEvent(tripId: widget.tripId),
                          );
                        },
                ),
              ),
              const SizedBox(width: AppSizes.spacingMedium),
              Expanded(
                child: CustomButton(
                  text: 'Start Trip',
                  backgroundColor: AppColors.success,
                  isLoading: state.status == TripStatus.loading,
                  onPressed: state.status == TripStatus.loading
                      ? null
                      : () {
                          context.read<TripBloc>().add(
                            StartTripEvent(tripId: widget.tripId),
                          );
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
