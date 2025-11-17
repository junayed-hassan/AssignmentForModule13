# BMI Calculator - Flutter App

A comprehensive BMI (Body Mass Index) calculator built with Flutter that supports multiple unit systems and provides color-coded health categories.

## Features

- **Multiple Unit Support**
  - Weight: Kilograms (kg) or Pounds (lb)
  - Height: Meters (m), Centimeters (cm), or Feet + Inches (ft + in)

- **Smart Input Handling**
  - Decimal value support (e.g., 70.5 kg, 1.72 m, 5 ft 7.5 in)
  - Auto-carry feature: When inches ≥ 12, automatically converts to feet
  - Input validation with user-friendly error messages
  - Decimal-only keyboard input (FilteringTextInputFormatter)

- **Accurate Calculations**
  - BMI Formula (Metric): `BMI = weight_kg / (height_m)²`
  - Result displayed rounded to 1 decimal place using `toStringAsFixed(1)`

- **Color-Coded Categories**
  - **Underweight** (< 18.5) → Blue
  - **Normal** (18.5 - 24.9) → Green
  - **Overweight** (25.0 - 29.9) → Orange
  - **Obese** (≥ 30.0) → Red

- **Beautiful UI**
  - Material Design 3
  - Gradient background
  - Smooth animations
  - Responsive layout for all screen sizes

## BMI Formula and Unit Conversions

### BMI Calculation
```dart
BMI = weight_kg / (height_m * height_m)
```

### Unit Conversion Functions

**Weight Conversion:**
```dart
double poundsToKg(double pounds) => pounds * 0.45359237;
```

**Height Conversions:**
```dart
// Centimeters to Meters
double cmToMeters(double cm) => cm / 100;

// Feet and Inches to Meters
double feetInchToMeters(double feet, double inches) => (feet * 12 + inches) * 0.0254;
```

## Category-to-Color Mapping

| BMI Range | Category | Color |
|-----------|----------|-------|
| < 18.5 | Underweight | Blue (`Colors.blue.shade100`) |
| 18.5 - 24.9 | Normal | Green (`Colors.green.shade100`) |
| 25.0 - 29.9 | Overweight | Orange (`Colors.orange.shade100`) |
| ≥ 30.0 | Obese | Red (`Colors.red.shade100`) |

## How to Run the App

### Prerequisites
- Flutter SDK installed (version 3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device

### Steps

1. **Clone the repository:**
   ```bash
   git clone <your-repository-url>
   cd bmi-calculator
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

4. **Build APK (Android):**
   ```bash
   flutter build apk --release
   ```
   The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

5. **Build iOS (Mac only):**
   ```bash
   flutter build ios --release
   ```

## Test Cases

The app has been verified with the following test cases:

1. **Test Case 1:**
   - Input: 70 kg, 170 cm
   - Expected: BMI ≈ 24.2, Category: Normal (Green) ✓

2. **Test Case 2:**
   - Input: 155 lb, 5'7"
   - Expected: BMI ≈ 24.3, Category: Normal (Green) ✓

3. **Test Case 3:**
   - Input: 95 kg, 165 cm
   - Expected: BMI ≈ 34.9, Category: Obese (Red) ✓

## Project Structure

```
lib/
└── main.dart          # Main application file with BMI Calculator
```

## Technical Implementation

### Input Validation
- Uses `FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))` for decimal inputs
- Validates empty inputs and shows appropriate error messages
- Prevents negative or zero values

### Conversion Functions
All conversion functions are kept small, testable, and reusable:
- `poundsToKg(double pounds)`
- `cmToMeters(double cm)`
- `feetInchToMeters(double feet, double inches)`

### Display Precision
- BMI result is displayed with `toStringAsFixed(1)` for 1 decimal place
- Full precision is stored internally for accurate calculations

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
```

No external packages required - built with pure Flutter!

## License

This project is open source and available under the MIT License.

## Screenshots

[Add your app screenshots here]

## Contact & Support

For issues, questions, or contributions, please open an issue on GitHub.

---

**Note:** This BMI calculator is for informational purposes only and should not replace professional medical advice.