import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/background_widget.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'PROFILE', showBackButton: false),
      body: BackgroundWidget(
        child: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoaded || state is ProfileUpdated) {
                final profile = state is ProfileLoaded
                    ? state.profile
                    : (state as ProfileUpdated).profile;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.spacingLarge),

                      /// ================= PROFILE HEADER =================
                      Row(
                        children: [
                          const SizedBox(width: AppSizes.spacingMedium),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                profile.fullName.substring(0, 2).toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.fullName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.spacingXSmall),
                                Text(
                                  '@${profile.username}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.spacingLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCountItem(
                            count: profile.followersCount,
                            label: 'Followers',
                            onTap: () {},
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: AppColors.textLight,
                          ),
                          _buildCountItem(
                            count: profile.followedTripsCount,
                            label: 'Followed Trips',
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.spacingXXLarge),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLarge,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildProfileItem(
                              icon: Icons.directions_car,
                              title: 'My Trips',
                              onTap: () {},
                            ),
                            _divider(),
                            _buildProfileItem(
                              icon: Icons.favorite,
                              title: 'Favorite Trips',
                              onTap: () {},
                            ),
                            _divider(),
                            _buildProfileItem(
                              icon: Icons.history,
                              title: 'Trip History',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSizes.spacingMedium),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLarge,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildProfileItem(
                              icon: Icons.edit,
                              title: 'Edit Profile',
                              onTap: () {},
                            ),
                            _divider(),
                            _buildProfileItem(
                              icon: Icons.settings,
                              title: 'Settings',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProfileError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  /// ================= PROFILE LIST ITEM =================
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.screenPaddingLarge,
        vertical: AppSizes.spacingSmall,
      ),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  /// ================= COUNT ITEM =================
  Widget _buildCountItem({
    required int count,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.spacingXSmall),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= DIVIDER =================
  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: const Divider(height: 1),
    );
  }
}
