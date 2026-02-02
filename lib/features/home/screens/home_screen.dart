import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../trip/bloc/trip_bloc.dart';
import '../../trip/bloc/trip_event.dart';
import '../../trip/bloc/trip_state.dart';
import '../../trip/widgets/trip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch LoadTripsEvent when screen initializes
    context.read<TripBloc>().add(const LoadTripsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

    return Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: AppColors.textWhite,
                          ),
                          onPressed: () {},
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppConstants.routeProfile,
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.textWhite,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'DN',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Trip Type Selector
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: BlocBuilder<TripBloc, TripState>(
                  buildWhen: (previous, current) =>
                      previous.selectedTripType != current.selectedTripType,
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.read<TripBloc>().add(
                                const SelectTripTypeEvent(
                                  AppStrings.groupTrips,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.spacingSmall,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    state.selectedTripType ==
                                        AppStrings.groupTrips
                                    ? AppColors.textWhite
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMedium,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  AppStrings.groupTrips,
                                  style: TextStyle(
                                    color:
                                        state.selectedTripType ==
                                            AppStrings.groupTrips
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
                              context.read<TripBloc>().add(
                                const SelectTripTypeEvent(AppStrings.soloTrips),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.spacingSmall,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    state.selectedTripType ==
                                        AppStrings.soloTrips
                                    ? AppColors.textWhite
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMedium,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  AppStrings.soloTrips,
                                  style: TextStyle(
                                    color:
                                        state.selectedTripType ==
                                            AppStrings.soloTrips
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
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              // Trip List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusXLarge),
                      topRight: Radius.circular(AppSizes.radiusXLarge),
                    ),
                  ),
                  child: BlocBuilder<TripBloc, TripState>(
                    builder: (context, state) {
                      if (state.status == TripStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == TripStatus.loaded) {
                        if (state.trips.isEmpty) {
                          return const Center(
                            child: Text(AppStrings.noTripsFound),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.screenPadding,
                            AppSizes.screenPadding,
                            AppSizes.screenPadding,
                            AppSizes.screenPadding +
                                AppSizes.screenPaddingLarge,
                          ),
                          itemCount: state.trips.length,
                          itemBuilder: (context, index) {
                            final trip = state.trips[index];
                            return TripCard(
                              tripName: trip.name,
                              date: trip.date,
                              checkpoints: trip.checkpoints
                                  .map((c) => c.name)
                                  .toList(),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.routeTripDetail,
                                  arguments: {'tripId': trip.id},
                                );
                              },
                            );
                          },
                        );
                      } else if (state.status == TripStatus.error) {
                        return Center(
                          child: Text(
                            state.errorMessage ?? AppStrings.errorLoadingTrips,
                            style: TextStyle(color: AppColors.error),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (fabContext) {
          return FloatingActionButton(
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: AppColors.textWhite),
            onPressed: () async {
              final RenderBox button =
                  fabContext.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(fabContext).context.findRenderObject()
                      as RenderBox;

              final Offset fabPosition = button.localToGlobal(
                Offset.zero,
                ancestor: overlay,
              );
              final Offset fabBottomRight = Offset(
                fabPosition.dx + button.size.width,
                fabPosition.dy + button.size.height,
              );

              final Rect fabRect = Rect.fromLTWH(
                fabBottomRight.dx - 60,
                fabBottomRight.dy - 180,
                button.size.width,
                button.size.height,
              );

              final result = await showMenu<String>(
                context: fabContext,
                position: RelativeRect.fromRect(
                  fabRect,
                  Offset.zero & overlay.size,
                ),
                items: const [
                  PopupMenuItem(
                    value: 'create',
                    child: Row(
                      children: [
                        Icon(Icons.trip_origin_sharp, size: 18),
                        SizedBox(width: 8),
                        Text('Create Trip'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'join',
                    child: Row(
                      children: [
                        Icon(Icons.group_add, size: 18),
                        SizedBox(width: 8),
                        Text('Join Trip'),
                      ],
                    ),
                  ),
                ],
              );

              if (result == 'create') {
                Navigator.pushNamed(fabContext, AppConstants.routePlanTrip);
              } else if (result == 'join') {
                Navigator.pushNamed(fabContext, AppConstants.routeJoinTrip);
              }
            },
          );
        },
      ),
    );
  }
}
