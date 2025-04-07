import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tax & EMI Calc',
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.fredokaTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F6F2),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF9CAF88), // Sage green
          secondary: Colors.lightGreen.shade100,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9CAF88),
          foregroundColor: Colors.white,
          elevation: 6,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFE6E4DA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF9CAF88)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF9CAF88), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF6B705C)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen.shade300,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            textStyle: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 4,
          ),
        ),
        tabBarTheme: const TabBarTheme(
          indicator: BoxDecoration(
            color: Color(0xFFb7de7f),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.lightGreenAccent,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController incomeController = TextEditingController();
  String taxResult = '';

  final TextEditingController loanController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();
  String emiResult = '';

  double calculateTax(double income) {
    if (income <= 250000) return 0;
    if (income <= 500000) return (income - 250000) * 0.05;
    if (income <= 1000000) return 12500 + (income - 500000) * 0.2;
    return 112500 + (income - 1000000) * 0.3;
  }

  double calculateEMI(double principal, double rate, double time) {
    rate = rate / (12 * 100);
    time = time * 12;
    return (principal * rate * pow(1 + rate, time)) /
        (pow(1 + rate, time) - 1);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget buildCenteredContent(List<Widget> children) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income Tax / EMI Calculator'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '     Income Tax     '),
            Tab(text: '     Loan EMI     '),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'bg.jpeg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.white.withOpacity(0.5), // optional soft overlay
          ),
          TabBarView(
            controller: _tabController,
            children: [
              // Income Tax Tab
              buildCenteredContent([
                TextField(
                  controller: incomeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Annual Income',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final income = double.tryParse(incomeController.text) ?? 0;
                    final tax = calculateTax(income);
                    setState(() {
                      taxResult = 'Estimated Tax: ₹${tax.toStringAsFixed(2)}';
                    });
                  },
                  child: const Text('Calculate Tax'),
                ),
                const SizedBox(height: 20),
                Text(
                  taxResult,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6B705C),
                  ),
                ),
              ]),

              // Loan EMI Tab
              buildCenteredContent([
                TextField(
                  controller: loanController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount (₹)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: interestController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate (%)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tenureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tenure (Years)',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final loan = double.tryParse(loanController.text) ?? 0;
                    final rate = double.tryParse(interestController.text) ?? 0;
                    final years = double.tryParse(tenureController.text) ?? 0;
                    final emi = calculateEMI(loan, rate, years);
                    setState(() {
                      emiResult = 'Monthly EMI: ₹${emi.toStringAsFixed(2)}';
                    });
                  },
                  child: const Text('Calculate EMI'),
                ),
                const SizedBox(height: 20),
                Text(
                  emiResult,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6B705C),
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
