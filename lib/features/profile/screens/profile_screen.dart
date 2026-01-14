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
      appBar: const CustomAppBar(
        title: 'PROFILE',
        showBackButton: false,
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded || state is ProfileUpdated) {
                final profile = state is ProfileLoaded
                    ? state.profile
                    : (state as ProfileUpdated).profile;
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.spacingLarge),
                      // Profile Header
                      Row(
                        children: [
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
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingXXLarge),
                      // Premium Section
                      Card(
                        child: Column(
                          children: [
                            _buildProfileItem(
                              icon: Icons.star,
                              title: 'Update to Premium',
                              onTap: () {},
                            ),
                            const Divider(height: 1),
                            _buildProfileItem(
                              icon: Icons.restore,
                              title: 'Restore Premium',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),
                      // General Section
                      Card(
                        child: Column(
                          children: [
                            _buildProfileItem(
                              icon: Icons.favorite,
                              title: 'My favorites',
                              onTap: () {},
                            ),
                            const Divider(height: 1),
                            _buildProfileItem(
                              icon: Icons.history,
                              title: 'My history',
                              onTap: () {},
                            ),
                            const Divider(height: 1),
                            _buildProfileItem(
                              icon: Icons.edit,
                              title: 'Edit profile',
                              onTap: () {},
                            ),
                            const Divider(height: 1),
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
              } else if (state is ProfileError) {
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
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
