import 'package:flutter/material.dart';

void main() {
  runApp(const ZakatApp());
}

class ZakatApp extends StatelessWidget {
  const ZakatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zakat & Currency Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _silverController = TextEditingController();
  final TextEditingController _goldRateController = TextEditingController(text: '220000');
  final TextEditingController _silverRateController = TextEditingController(text: '2500');

  double _totalAssets = 0;
  double _zakatAmount = 0;

  final TextEditingController _usdController = TextEditingController();
  double _pkrAmount = 0;
  final double _usdToPkrRate = 278.50;

  void _calculateZakat() {
    double cash = double.tryParse(_cashController.text) ?? 0;
    double goldTola = double.tryParse(_goldController.text) ?? 0;
    double silverTola = double.tryParse(_silverController.text) ?? 0;
    double goldRate = double.tryParse(_goldRateController.text) ?? 220000;
    double silverRate = double.tryParse(_silverRateController.text) ?? 2500;

    double goldValue = goldTola * goldRate;
    double silverValue = silverTola * silverRate;

    setState(() {
      _totalAssets = cash + goldValue + silverValue;
      _zakatAmount = _totalAssets * 0.025;
    });
  }

  void _convertCurrency() {
    double usd = double.tryParse(_usdController.text) ?? 0;
    setState(() {
      _pkrAmount = usd * _usdToPkrRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Zakat Calculator' : 'USD to PKR Converter'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _selectedIndex == 0 ? _buildZakatCalculator() : _buildCurrencyConverter(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Zakat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Currency',
          ),
        ],
      ),
    );
  }

  Widget _buildZakatCalculator() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Total Zakat Payable (2.5%):', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'PKR ${_zakatAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  Text('Total Wealth: PKR ${_totalAssets.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cashController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cash / Bank Balance (PKR)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _goldController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Gold (Tola)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _goldRateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Current Gold Rate per Tola (PKR)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _silverController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Silver (Tola)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _silverRateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Current Silver Rate per Tola (PKR)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calculateZakat,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Calculate Zakat', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyConverter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Rate: 1 USD = $_usdToPkrRate PKR', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    'PKR ${_pkrAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount in USD (\$)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _convertCurrency,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Convert to PKR', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
