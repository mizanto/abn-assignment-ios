# Places App Assignment

## Assignment Overview
The task was to develop a SwiftUI application that fetches a list of locations from a network resource and allows users to open these locations in the Wikipedia app. Additionally, users should be able to enter custom coordinates to open specific locations in Wikipedia. The application should handle various edge cases, provide appropriate error handling, and follow best practices in code organization, testing, accessibility, and localization.

## Project Structure

The repository is organized into two main folders:

1. **Places** - The main application code for the Places app.
2. **Wikipedia** - The modified code of the Wikipedia application to handle custom URL schemes with coordinates.

### 1. Places App

This folder contains the SwiftUI application code for Places. It includes:

- **Models**: Data models for network and display locations.
- **Screens**: SwiftUI screens that contain Views, ViewModels, and ScreenBuilders. In this project, there is only one screens: `LocationsView`.
- **Views**: Common SwiftUI views such as `PlaceholderView`, `LoadingView` and othe reusable components.
- **Services**: The `LocationService` responsible for network requests and `Logger` for logging.
- **Utilities**: Helper functions and extensions.
- **Tests**: Unit and UI tests covering various scenarios.

### 2. Wikipedia App

This folder contains the modified code of the Wikipedia application to support opening locations via custom URL schemes with coordinates. The changes enable the Wikipedia app to open and display a map at the specified coordinates when triggered by the Places app.

## Changes to the Wikipedia Project

To fulfill the assignment requirements, the Wikipedia app was modified to handle deep linking with custom URL schemes that include latitude and longitude parameters.

### Modifications:

- **Parsing Coordinates**: Extracted `latitude` and `longitude` parameters from the incoming URL.
- **Map Changes**: Updated the app to display a map centered at the provided coordinates.
- **Validation**: Added validation for the coordinates.

## Features of the Places App

- **Location List**: Fetches and displays a list of predefined locations from a network resource.
- **Custom Location Entry**: Allows users to input custom latitude and longitude values with validation and error highlighting.
- **Deep Linking to Wikipedia**: Opens the Wikipedia app at the specified coordinates via custom URL schemes.
- **Input Validation**: Validates latitude and longitude inputs to ensure they are within valid ranges (-90 to 90 for latitude, -180 to 180 for longitude).
- **Error Handling**: Provides user-friendly error messages and handles network errors gracefully.
- **Accessibility**: Supports VoiceOver, Dynamic Type, and includes accessibility labels, hints, and identifiers.
- **Localization**: All user-facing strings are localized.
- **Testing**: Comprehensive unit and UI tests covering various scenarios, including edge cases and error handling.
- **Concurrency**: Utilizes Swift Concurrency (`async/await`) for asynchronous operations.

## Usage

1. **Viewing Locations**:

   - Launch the Places app to see a list of locations.
   - Tap on a location to open it in the modified Wikipedia app.

2. **Entering a Custom Location**:

   - Tap the **Custom Location** button.
   - Enter valid latitude and longitude values.
   - If inputs are invalid, error messages will appear, and input fields will be highlighted.
   - Tap **Open Location** to view it in Wikipedia.

## Testing

### Unit Tests

- **LocationsViewModelTests**: Tests for view model logic, state management, and input validation.
- **LocationServiceTests**: Tests for the network layer and error handling.

### UI Tests

- **LocationsUITests**: Tests for UI components and user interactions.
- **Custom Location Tests**: Tests for validation logic and error messages in the custom location view.

---

Thank you for reviewing this assignment. If you have any questions or need further clarification, please feel free to reach out.

---