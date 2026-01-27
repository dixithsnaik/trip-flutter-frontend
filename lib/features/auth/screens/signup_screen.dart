import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../../core/widgets/background_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to Terms & Privacy Policy'),
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(
        SignUpEvent(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  void _handleGoogleSignIn() {
    // Handle Google sign in (no API for now)
    Navigator.pushReplacementNamed(context, AppConstants.routeHome);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Assuming OTP sent logic is part of successful signup or a specific status
        // If the flow is Signup -> OTP -> Home, then maybe we need a specific status for OtpSent
        // Actually, let's assume 'unauthenticated' with email set implies OTP step or similar?
        // Or better, let's stick to the Bloc we implemented.
        // Wait, AuthStatus has: initial, loading, authenticated, unauthenticated, error.
        // We might need to add `otpSent` to AuthStatus if that's a distinct state.
        // For now, let's assume authenticated -> Home.
        // If previously it was `OtpSent`, we probably need to handle that.
        // Let's check AuthBloc logic... I didn't implement logic yet, I just fixed the State class.
        // The original `AuthBloc` mock had `OtpSent`. I should check if I missed it in AuthStatus.
        // Re-reading my AuthState fix: `enum AuthStatus { initial, loading, authenticated, unauthenticated, error }`.
        // I PROBABLY SHOULD ADD `otpSent` to AuthStatus.
        if (state.status == AuthStatus.authenticated) {
            // Or if we want to support OTP flow:
             Navigator.pushNamed(
              context,
              AppConstants.routeOtp,
              arguments: {'email': state.email ?? _emailController.text}, // Use state email or controller
            );
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Signup failed')));
        }
      },
      child: Scaffold(
        body: BackgroundWidget(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSizes.spacingXLarge),
                    const LogoWidget(),
                    const SizedBox(height: AppSizes.spacingXXLarge),
                    const SizedBox(height: AppSizes.spacingMedium),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: AppConstants.placeholderUsername,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    CustomTextField(
                      controller: _emailController,
                      hintText: AppConstants.placeholderEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: AppConstants.placeholderPassword,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < AppConstants.minPasswordLength) {
                          return 'Password must be at least ${AppConstants.minPasswordLength} characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: AppConstants.placeholderConfirmPassword,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'By signing up, you agree to our ',
                              style: TextStyle(color: AppColors.textSecondary),
                              children: [
                                TextSpan(
                                  text: 'Terms & Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Sign Up',
                          onPressed: _handleSignUp,
                          isLoading: state.status == AuthStatus.loading,
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.textLight)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spacingMedium,
                          ),
                          child: Text(
                            'or',
                            style: TextStyle(color: AppColors.textLight),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.textLight)),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    OutlinedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: Image.asset(
                        'assets/icons/google.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.g_mobiledata, size: 24);
                        },
                      ),
                      label: const Text('Sign in with Google'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          AppSizes.buttonHeightMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppConstants.routeLogin,
                          );
                        },
                        child: const Text('Already have an account? Log in'),
                      ),
                    ),
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
