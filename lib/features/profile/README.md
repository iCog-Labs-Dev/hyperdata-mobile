# Profile Module

This module provides a comprehensive profile management system for the Leyu Mobile app, following the same design patterns and form handling approaches used in the auth module.

## Components

### Pages

- **ProfilePage** (`lib/features/profile/presentation/pages/profile_page.dart`)

  - Main profile page with header and content
  - Includes bottom navigation

- **EditProfilePage** (`lib/features/profile/presentation/pages/edit_profile_page.dart`)

  - Edit profile form page
  - Follows the same form handling patterns as auth module

- **MainProfileScreen** (`lib/features/profile/presentation/pages/main_profile_screen.dart`)
  - Complete profile screen with bottom navigation
  - Can be used as the main profile interface

### Widgets

- **ProfileMainWidget** (`lib/features/profile/presentation/widgets/profile_main_widget.dart`)

  - Displays profile information, statistics, and navigation options
  - Matches the design shown in the profile UI images

- **EditProfileWidget** (`lib/features/profile/presentation/widgets/edit_profile_widget.dart`)

  - Form for editing profile information
  - Uses the same input components and dropdown patterns as auth module

### Controllers

- **ProfileController** (`lib/features/profile/presentation/controllers/profile_controller.dart`)
  - Manages profile data and form state
  - Handles language and dialect selection
  - Follows the same reactive programming patterns as AuthController

### Bindings

- **ProfileBinding** (`lib/features/profile/presentation/bindings/profile_binding.dart`)
  - Dependency injection for profile module
  - Provides ProfileController instance

## Features

### Profile Display

- Profile picture with camera overlay
- User name and status badge
- Navigation options (Edit Profile, Language, Help, Privacy, Logout)

### Profile Editing

- Form fields for first name, middle name, last name, email, date of birth
- Gender dropdown selection (Male/Female)
- Language and dialect selection dropdowns
- Profile picture upload functionality
- Save and cancel functionality with API integration
- Form validation and error handling

### Design System

- Consistent with app's color scheme and typography
- Responsive layout using proper spacing
- Material Design principles
- Clean, modern UI matching the provided images

## Usage

### Basic Profile Page

```dart
class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfilePage();
  }
}
```

### Edit Profile

```dart
// Navigate to edit profile
Get.toNamed('/editProfile');

// Or use the widget directly
EditProfilePage()
```

### API Integration

The profile module now integrates with the `/iam/users/me` endpoint:

- **GET**: Fetches user profile data
- **PUT**: Updates user profile information
- **POST**: Uploads profile picture

### With Bottom Navigation

```dart
// Use the complete screen with navigation
MainProfileScreen()
```

## Dependencies

The profile module depends on:

- **Auth Module**: For User, Language, and Dialect models and entities
- **Core Widgets**: InputBox, Dropdown, Button, DatePicker components
- **Image Picker**: For profile picture selection
- **GetX**: For state management and dependency injection
- **Dio**: For HTTP requests and file uploads
- **Dartz**: For functional error handling (Either)

## Form Handling

The profile module follows the same form handling patterns as the auth module:

1. **Reactive Variables**: Uses `RxString`, `Rxn<T>` for reactive state
2. **Form Controllers**: TextEditingController for input fields
3. **Validation**: Built-in validation in dropdown and input components
4. **Error Handling**: Consistent error display and user feedback
5. **Loading States**: Loading indicators for async operations

## Navigation

The profile module includes:

- Back navigation from profile pages
- Navigation to edit profile, language selection, help, and privacy pages
- Logout functionality with confirmation dialog

## Customization

The profile module is designed to be easily customizable:

- Colors and themes can be modified in `AppColors`
- Layout spacing can be adjusted in the widget files
- Navigation options can be modified in the profile options section
- Statistics can be customized to show different metrics
