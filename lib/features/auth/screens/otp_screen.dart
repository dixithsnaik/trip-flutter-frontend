import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/background_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpScreen extends StatelessWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  String _maskEmail(String email) {
    if (email.length <= 3) return email;
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) return email;
    final masked = '${username.substring(0, 3)}${'*' * (username.length - 3)}';
    return '$masked@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _otpController = TextEditingController();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          // Navigate to reset password or onboarding based on context
          if (ModalRoute.of(context)?.settings.arguments != null) {
            Navigator.pushNamed(context, AppConstants.routeResetPassword);
          } else {
            Navigator.pushReplacementNamed(
              context,
              AppConstants.routeOnboarding,
            );
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is OtpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP resent to your email')),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'ENTER OTP'),
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
                    Text(
                      'Check your email ${_maskEmail(email)} for the OTP. It expires in ${AppConstants.otpExpiryMinutes} minutes.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXXLarge),
                    CustomTextField(
                      controller: _otpController,
                      hintText: 'Enter OTP',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OTP';
                        }
                        if (value.length != AppConstants.otpLength) {
                          return 'OTP must be ${AppConstants.otpLength} digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            ResendOtpEvent(email: email),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Didn't receive an email? ",
                            style: TextStyle(color: AppColors.textSecondary),
                            children: [
                              TextSpan(
                                text: 'Resend OTP',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXXLarge),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Verify OTP',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                VerifyOtpEvent(
                                  email: email,
                                  otp: _otpController.text,
                                ),
                              );
                            }
                          },
                          isLoading: state is AuthLoading,
                        );
                      },
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
