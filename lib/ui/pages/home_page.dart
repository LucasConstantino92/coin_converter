import 'package:coincov/providers/currency_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrencyProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, child) {
        if (provider.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.initialize(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.isLoading || provider.currencyData == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.conversionResult == null ||
            provider.conversionResult!.rates.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Nenhuma taxa de câmbio disponível")),
          );
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: Color(0xFFff6700),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.baseCurrency,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Text(
                  "1,00",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchRates("USD"),
            child: ListView.builder(
              itemCount: provider.conversionResult!.rates.length,
              itemBuilder: (context, index) {
                final code =
                    provider.conversionResult!.rates.keys.elementAt(index);
                final rate =
                    provider.conversionResult!.rates.values.elementAt(index);
                final currency = provider.currencyData![code];

                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      '${currency?.symbol ?? ''} ${currency?.name ?? code}',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      code,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      rate.toStringAsFixed(3).toString().replaceAll('.', ','),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
