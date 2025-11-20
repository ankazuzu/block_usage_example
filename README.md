# Image Generator

A Flutter application demonstrating image generation with state management using `flutter_bloc` and navigation with `go_router`.

## Features

### 📱 Screens

#### Prompt Screen
- Clean input field with icon in a card with soft shadow
- Primary button with gradient effect and scale animation on tap
- Prompt text preservation when navigating back

#### Result Screen
- **Loading State**: Custom animated loader with rotating gradient circle
- **Success State**: 
  - Smooth fade and scale animation for image appearance
  - Image displayed in a white card with rounded corners and shadows
  - Delayed button appearance animation (150ms after image)
  - "Try another" button for regeneration
  - "New prompt" button (outline style) to return with saved text
- **Error State**: 
  - Friendly error message display
  - Retry button with primary styling
  - Option to start with a new prompt

### 🏗️ Architecture

The project follows **Clean Architecture** principles:

- **Data Layer**: Repository implementations and mock API service
- **Domain Layer**: Business logic and repository interfaces
- **Presentation Layer**: UI, BLoC state management, and navigation

### 🔄 State Management

- **BLoC Pattern**: Using `flutter_bloc` for predictable state management
- **States**: Initial, Loading, Success, Error
- **Events**: GenerateImage, RetryGeneration

### 🧭 Navigation

- **go_router**: Declarative routing with custom page transitions
- **Smooth Transitions**: Fade + slide up animations (300ms)
- **Deep Linking**: Support for prompt parameter in URL

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd bloc_usage_example
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── data/
│   └── repositories/
│       └── image_generation_repository_impl.dart
├── domain/
│   └── repositories/
│       └── image_generation_repository.dart
├── presentation/
│   ├── bloc/
│   │   ├── image_generation_bloc.dart
│   │   ├── image_generation_event.dart
│   │   └── image_generation_state.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── screens/
│   │   ├── prompt_screen.dart
│   │   └── result_screen.dart
│   └── widgets/
│       ├── primary_button.dart
│       ├── secondary_button.dart
│       └── custom_loader.dart
└── main.dart
```

## Usage Flow

1. **Enter Prompt**: Type a description in the input field
2. **Generate**: Tap the "Generate" button (disabled when field is empty)
3. **Loading**: Watch the custom animated loader (2-3 seconds)
4. **View Result**: See the generated image with smooth animations
5. **Actions**:
   - **Try another**: Regenerate with the same prompt
   - **New prompt**: Return to input screen with text preserved
6. **Error Handling**: If generation fails, use "Retry" or start with a new prompt

## Mock API

The application uses a mock API service (`ImageGenerationRepositoryImpl`) that:
- Simulates network delay (2-3 seconds)
- Has approximately 50% chance of throwing an error for testing
- Returns a placeholder image URL on success (using Picsum Photos)

## UI Components

### PrimaryButton
- Gradient background (`#6C63FF` to `#7B73FF`)
- Scale animation on tap (0.97x)
- Soft shadow effect
- Disabled state with reduced opacity

### SecondaryButton
- Outline style with primary color border
- Same height and border radius as primary button
- Used for secondary actions

### CustomLoader
- Rotating gradient circle animation
- Pulsing scale effect
- Custom message support
- Subtle background overlay

## UX Features

- ✅ **Smooth Animations**: All transitions use fade + slide effects
- ✅ **State Preservation**: Prompt text saved when navigating back
- ✅ **Error Recovery**: Clear error messages with retry options
- ✅ **Loading Feedback**: Custom animated loader during generation
- ✅ **Accessibility**: Proper focus management and semantic widgets

## Dependencies

- `flutter_bloc: ^8.1.6` - State management
- `go_router: ^14.2.0` - Declarative routing
- `equatable: ^2.0.5` - Value equality for state objects

## Design Principles

- **Minimalism**: Clean, uncluttered interface
- **Consistency**: Reusable components with unified styling
- **Feedback**: Clear visual states for all user actions
- **Performance**: Smooth 60fps animations
- **Accessibility**: Proper semantic structure

## Development Notes

- Uses Material 3 design system
- Follows Flutter best practices
- Implements proper state disposal
- Handles edge cases (no prompt, navigation errors)
- Optimized for iOS and Android
# block_usage_example
