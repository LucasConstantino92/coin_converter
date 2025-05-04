import 'package:coincov/providers/currency_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCurrencyCodes = [];

  void _filterCurrencies(String query) {
    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    if (provider.currencyData == null) return;

    setState(() {
      _filteredCurrencyCodes = provider.currencyData!.entries
          .where((entry) =>
              entry.value.name.toLowerCase().contains(query.toLowerCase()))
          .map((entry) => entry.key)
          .toList();
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Pesquisar moeda...',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showSearch = false;
                _searchController.clear();
              });
            },
          ),
        ),
        onChanged: _filterCurrencies,
      ),
    );
  }

  void _showCurrencySelector() {
    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    if (provider.currencyData == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Selecione uma moeda', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.currencyData!.length,
                  itemBuilder: (context, index) {
                    final code = provider.currencyData!.keys.elementAt(index);
                    final currency = provider.currencyData![code]!;
                    return ListTile(
                      title: Text(currency.name),
                      subtitle: Text(code),
                      trailing: Text(currency.symbol),
                      onTap: () {
                        Navigator.pop(context);
                        provider.fetchRates(code);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: Color(0xFFff6700),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.currencyData?[provider.baseCurrency]?.name ??
                        provider.baseCurrency,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    '${provider.currencyData?[provider.baseCurrency]?.symbol ?? ''} 1,00',
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
            backgroundColor: Colors.grey[100],
            body: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 80,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 80,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
            title: _showSearch
                ? _buildSearchBar()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.currencyData?[provider.baseCurrency]?.name ??
                            provider.baseCurrency,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '${provider.currencyData?[provider.baseCurrency]?.symbol ?? ''} 1,00',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
            actions: [
              if (_showSearch)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _showSearch = false;
                      _searchController.clear();
                    });
                  },
                )
              else
                IconButton(
                  onPressed: () {
                    setState(() => _showSearch = true);
                  },
                  icon: Icon(Icons.search_outlined,
                      color: Colors.white, size: 30),
                ),
              IconButton(
                onPressed: _showCurrencySelector,
                icon: Icon(Icons.change_circle_outlined,
                    color: Colors.white, size: 30),
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchRates(provider.baseCurrency),
            child: ListView.builder(
              itemCount: _showSearch && _filteredCurrencyCodes.isNotEmpty
                  ? _filteredCurrencyCodes.length
                  : provider.conversionResult?.rates.length ?? 0,
              itemBuilder: (context, index) {
                final code = _showSearch && _filteredCurrencyCodes.isNotEmpty
                    ? _filteredCurrencyCodes[index]
                    : provider.conversionResult!.rates.keys.elementAt(index);
                final rate = provider.conversionResult!.rates[code]!;
                final currency = provider.currencyData![code];

                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      currency?.name ?? code,
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      code,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${currency?.symbol ?? ''} ${rate.toStringAsFixed(2)}',
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
