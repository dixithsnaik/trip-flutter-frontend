import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
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
  int _currentIndex = 0;
  String _selectedTripType = 'Group Trips';

  @override
  void initState() {
    super.initState();
    context.read<TripBloc>().add(LoadTripsEvent(tripType: _selectedTripType));
  }

  @override
  Widget build(BuildContext context) {
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
                      AppConstants.appName,
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
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTripType = 'Group Trips';
                          });
                          context.read<TripBloc>().add(
                            LoadTripsEvent(tripType: 'Group Trips'),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spacingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedTripType == 'Group Trips'
                                ? AppColors.textWhite
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMedium,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Group Trips',
                              style: TextStyle(
                                color: _selectedTripType == 'Group Trips'
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
                            _selectedTripType = 'Solo Trips';
                          });
                          context.read<TripBloc>().add(
                            LoadTripsEvent(tripType: 'Solo Trips'),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spacingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedTripType == 'Solo Trips'
                                ? AppColors.textWhite
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMedium,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Solo Trips',
                              style: TextStyle(
                                color: _selectedTripType == 'Solo Trips'
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
                      if (state is TripLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TripsLoaded) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(AppSizes.screenPadding),
                          itemCount: state.trips.length,
                          itemBuilder: (context, index) {
                            final trip = state.trips[index];
                            return TripCard(
                              tripName: trip.name,
                              date: trip.date,
                              checkpoints: trip.checkpoints,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.routeTripDetail,
                                  arguments: {'tripName': trip.name},
                                );
                              },
                            );
                          },
                        );
                      } else if (state is TripError) {
                        return Center(
                          child: Text(
                            state.message,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstants.routePlanTrip);
        },
        backgroundColor: AppColors.textPrimary,
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXLarge),
          topRight: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
            if (index == 2) {
              if (currentRoute != AppConstants.routeChats) {
                Navigator.pushNamed(context, AppConstants.routeChats);
              }
            } else if (index == 3) {
              if (currentRoute != AppConstants.routeProfile) {
                Navigator.pushNamed(context, AppConstants.routeProfile);
              }
            }
          });
        },

        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.textWhite,
        unselectedItemColor: AppColors.textWhite.withOpacity(0.6),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
