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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'dixithsnaik@gmail.com');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, AppConstants.routeHome);
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Authentication failed')));
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
                    const SizedBox(height: AppSizes.spacingXXLarge),
                    const LogoWidget(),
                    const SizedBox(height: AppSizes.spacingXXLarge),
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
                    const SizedBox(height: AppSizes.spacingSmall),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppConstants.routeVerifyEmail,
                          );
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Log In',
                          onPressed: _handleLogin,
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
                          Navigator.pushNamed(
                            context,
                            AppConstants.routeSignUp,
                          );
                        },
                        child: const Text('New here? Create an account'),
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
