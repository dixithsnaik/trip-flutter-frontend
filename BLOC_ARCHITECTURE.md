# BLoC Architecture Documentation

## Overview

This project uses the **BLoC (Business Logic Component)** pattern for state management, implemented using the `flutter_bloc` package. This provides a clean separation between UI and business logic, making the code more testable and maintainable.

## Architecture

### BLoC Pattern Components

Each feature follows the BLoC pattern with three main components:

1. **Events** - User actions or triggers that cause state changes
2. **States** - The different states the app can be in
3. **BLoC** - The business logic component that handles events and emits states

## Implemented BLoCs

### 1. AuthBloc (`lib/features/auth/bloc/`)

**Purpose**: Manages authentication flow (login, signup, OTP verification, password reset)

**Events**:
- `LoginEvent` - User login attempt
- `SignUpEvent` - User registration
- `VerifyEmailEvent` - Request OTP for email verification
- `VerifyOtpEvent` - Verify OTP code
- `ResetPasswordEvent` - Reset user password
- `ResendOtpEvent` - Resend OTP code
- `LogoutEvent` - User logout

**States**:
- `AuthInitial` - Initial state
- `AuthLoading` - Loading state during API calls
- `AuthAuthenticated` - User successfully authenticated
- `AuthUnauthenticated` - User not authenticated
- `OtpSent` - OTP sent successfully
- `OtpVerified` - OTP verified successfully
- `PasswordResetSuccess` - Password reset successful
- `AuthError` - Error state with message

**Usage Example**:
```dart
// Dispatch event
context.read<AuthBloc>().add(LoginEvent(
  email: email,
  password: password,
));

// Listen to state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  },
  child: BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      if (state is AuthLoading) {
        return CircularProgressIndicator();
      }
      return LoginForm();
    },
  ),
)
```

### 2. TripBloc (`lib/features/trip/bloc/`)

**Purpose**: Manages trip-related operations (loading trips, creating trips, starting/canceling trips)

**Events**:
- `LoadTripsEvent` - Load list of trips
- `CreateTripEvent` - Create a new trip
- `StartTripEvent` - Start an active trip
- `CancelTripEvent` - Cancel a trip

**States**:
- `TripInitial` - Initial state
- `TripLoading` - Loading state
- `TripsLoaded` - Trips loaded successfully
- `TripCreated` - Trip created successfully
- `TripStarted` - Trip started successfully
- `TripCancelled` - Trip cancelled successfully
- `TripError` - Error state

**Models**:
- `Trip` - Trip data model with id, name, date, checkpoints, participants

### 3. ChatBloc (`lib/features/chat/bloc/`)

**Purpose**: Manages chat functionality (loading chats, sending messages, loading messages)

**Events**:
- `LoadChatsEvent` - Load list of chats
- `LoadChatMessagesEvent` - Load messages for a specific chat
- `SendMessageEvent` - Send a new message

**States**:
- `ChatInitial` - Initial state
- `ChatLoading` - Loading state
- `ChatsLoaded` - Chats loaded successfully
- `ChatMessagesLoaded` - Messages loaded for a chat
- `MessageSent` - Message sent successfully
- `ChatError` - Error state

**Models**:
- `Chat` - Chat data model with id, name, lastMessage, time, unreadCount
- `ChatMessage` - Message data model with id, text, isSent, time, isDate

### 4. ProfileBloc (`lib/features/profile/bloc/`)

**Purpose**: Manages user profile operations

**Events**:
- `LoadProfileEvent` - Load user profile
- `UpdateProfileEvent` - Update user profile

**States**:
- `ProfileInitial` - Initial state
- `ProfileLoading` - Loading state
- `ProfileLoaded` - Profile loaded successfully
- `ProfileUpdated` - Profile updated successfully
- `ProfileError` - Error state

**Models**:
- `UserProfile` - User profile data model

## Setup

### Provider Configuration

All BLoCs are provided at the app level in `main.dart`:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc()),
    BlocProvider(create: (_) => TripBloc()),
    BlocProvider(create: (_) => ChatBloc()),
    BlocProvider(create: (_) => ProfileBloc()),
  ],
  child: MaterialApp(...),
)
```

## Usage Patterns

### 1. Dispatching Events

```dart
context.read<AuthBloc>().add(LoginEvent(
  email: email,
  password: password,
));
```

### 2. Listening to State Changes

Use `BlocListener` for side effects (navigation, showing snackbars):

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  },
  child: YourWidget(),
)
```

### 3. Building UI Based on State

Use `BlocBuilder` to rebuild UI based on state:

```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return LoginForm();
  },
)
```

### 4. Combining Listener and Builder

```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    // Handle side effects
  },
  builder: (context, state) {
    // Build UI
  },
)
```

## Best Practices

1. **Separation of Concerns**: Business logic stays in BLoC, UI stays in widgets
2. **Immutable States**: All states extend `Equatable` for proper comparison
3. **Error Handling**: Always have error states to handle failures gracefully
4. **Loading States**: Show loading indicators during async operations
5. **Event Validation**: Validate input in BLoC before processing
6. **State Management**: Use `BlocBuilder` for UI updates, `BlocListener` for side effects

## Testing

BLoCs can be easily tested by:
1. Creating mock events
2. Dispatching events to BLoC
3. Asserting expected states

Example:
```dart
test('emits [AuthLoading, AuthAuthenticated] when login succeeds', () {
  final bloc = AuthBloc();
  bloc.add(LoginEvent(email: 'test@test.com', password: 'password'));
  expectLater(
    bloc.stream,
    emitsInOrder([AuthLoading(), AuthAuthenticated(email: 'test@test.com')]),
  );
});
```

## Future Enhancements

- Add repository pattern for data layer abstraction
- Implement dependency injection
- Add unit tests for all BLoCs
- Implement offline support with local storage
- Add real-time updates using streams

