import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const BMICalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  // Controllers
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightMController = TextEditingController();
  final TextEditingController heightCmController = TextEditingController();
  final TextEditingController heightFtController = TextEditingController();
  final TextEditingController heightInController = TextEditingController();

  // State variables
  String weightUnit = 'kg';
  String heightUnit = 'cm';
  double? bmi;
  String errorMessage = '';

  @override
  void dispose() {
    weightController.dispose();
    heightMController.dispose();
    heightCmController.dispose();
    heightFtController.dispose();
    heightInController.dispose();
    super.dispose();
  }

  void calculateBMI() {
    setState(() {
      errorMessage = '';
      bmi = null;

      // Validate weight
      final weightText = weightController.text.trim();
      if (weightText.isEmpty) {
        errorMessage = 'Please enter a valid weight';
        return;
      }

      final weightNum = double.tryParse(weightText);
      if (weightNum == null || weightNum <= 0) {
        errorMessage = 'Please enter a valid weight';
        return;
      }

      // Convert weight to kg
      double weightKg = weightNum;
      if (weightUnit == 'lb') {
        weightKg = weightNum * 0.45359237;
      }

      // Calculate height in meters
      double heightMeters = 0;

      if (heightUnit == 'm') {
        final heightMText = heightMController.text.trim();
        if (heightMText.isEmpty) {
          errorMessage = 'Please enter a valid height';
          return;
        }
        final heightMNum = double.tryParse(heightMText);
        if (heightMNum == null || heightMNum <= 0) {
          errorMessage = 'Please enter a valid height';
          return;
        }
        heightMeters = heightMNum;
      } else if (heightUnit == 'cm') {
        final heightCmText = heightCmController.text.trim();
        if (heightCmText.isEmpty) {
          errorMessage = 'Please enter a valid height';
          return;
        }
        final heightCmNum = double.tryParse(heightCmText);
        if (heightCmNum == null || heightCmNum <= 0) {
          errorMessage = 'Please enter a valid height';
          return;
        }
        heightMeters = heightCmNum / 100;
      } else if (heightUnit == 'ft') {
        final ftText = heightFtController.text.trim();
        final inText = heightInController.text.trim();

        double ftNum = double.tryParse(ftText) ?? 0;
        double inNum = double.tryParse(inText) ?? 0;

        if (ftNum <= 0 && inNum <= 0) {
          errorMessage = 'Please enter a valid height';
          return;
        }

        // Auto-carry inches to feet if inches >= 12
        if (inNum >= 12) {
          final additionalFeet = (inNum / 12).floor();
          final newFt = ftNum + additionalFeet;
          final newIn = inNum % 12;
          heightFtController.text = newFt.toString();
          heightInController.text = newIn.toStringAsFixed(1);
          ftNum = newFt;
          inNum = newIn;
        }

        heightMeters = (ftNum * 12 + inNum) * 0.0254;
      }

      // Calculate BMI
      final bmiValue = weightKg / (heightMeters * heightMeters);
      bmi = bmiValue;
    });
  }

  Map<String, dynamic> getBMICategory(double bmiValue) {
    if (bmiValue < 18.5) {
      return {
        'category': 'Underweight',
        'color': Colors.blue.shade100,
        'borderColor': Colors.blue.shade300,
        'textColor': Colors.blue.shade700,
      };
    } else if (bmiValue < 25.0) {
      return {
        'category': 'Normal',
        'color': Colors.green.shade100,
        'borderColor': Colors.green.shade300,
        'textColor': Colors.green.shade700,
      };
    } else if (bmiValue < 30.0) {
      return {
        'category': 'Overweight',
        'color': Colors.orange.shade100,
        'borderColor': Colors.orange.shade300,
        'textColor': Colors.orange.shade700,
      };
    } else {
      return {
        'category': 'Obese',
        'color': Colors.red.shade100,
        'borderColor': Colors.red.shade300,
        'textColor': Colors.red.shade700,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Icon(
                              Icons.calculate,
                              size: 32,
                              color: Colors.indigo.shade600,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'BMI Calculator',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Weight Input
                        const Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: InputDecoration(
                                  hintText: 'Enter weight',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _buildUnitButton(
                                    'kg',
                                    weightUnit == 'kg',
                                    () {
                                      setState(() => weightUnit = 'kg');
                                    },
                                  ),
                                  _buildUnitButton(
                                    'lb',
                                    weightUnit == 'lb',
                                    () {
                                      setState(() => weightUnit = 'lb');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Height Input
                        const Text(
                          'Height',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildUnitButton(
                                  'm',
                                  heightUnit == 'm',
                                  () {
                                    setState(() => heightUnit = 'm');
                                  },
                                ),
                              ),
                              Expanded(
                                child: _buildUnitButton(
                                  'cm',
                                  heightUnit == 'cm',
                                  () {
                                    setState(() => heightUnit = 'cm');
                                  },
                                ),
                              ),
                              Expanded(
                                child: _buildUnitButton(
                                  'ft + in',
                                  heightUnit == 'ft',
                                  () {
                                    setState(() => heightUnit = 'ft');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Height input fields based on selected unit
                        if (heightUnit == 'm')
                          TextField(
                            controller: heightMController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter height in meters',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        if (heightUnit == 'cm')
                          TextField(
                            controller: heightCmController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter height in centimeters',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        if (heightUnit == 'ft')
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: heightFtController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Feet',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: heightInController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    hintText: 'Inches',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),

                        // Error Message
                        if (errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),

                        // Calculate Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: calculateBMI,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Calculate BMI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Result Card
                        if (bmi != null) ...[
                          const SizedBox(height: 24),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: getBMICategory(bmi!)['color'] as Color,
                              border: Border.all(
                                color:
                                    getBMICategory(bmi!)['borderColor']
                                        as Color,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Your BMI',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bmi!.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        getBMICategory(bmi!)['textColor']
                                            as Color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        getBMICategory(bmi!)['color'] as Color,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    getBMICategory(bmi!)['category'] as String,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          getBMICategory(bmi!)['textColor']
                                              as Color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // BMI Categories Reference
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BMI Categories',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildCategoryRow(
                                Colors.blue.shade300,
                                'Underweight: < 18.5',
                              ),
                              const SizedBox(height: 8),
                              _buildCategoryRow(
                                Colors.green.shade300,
                                'Normal: 18.5 - 24.9',
                              ),
                              const SizedBox(height: 8),
                              _buildCategoryRow(
                                Colors.orange.shade300,
                                'Overweight: 25.0 - 29.9',
                              ),
                              const SizedBox(height: 8),
                              _buildCategoryRow(
                                Colors.red.shade300,
                                'Obese: ≥ 30.0',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRow(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }
}
