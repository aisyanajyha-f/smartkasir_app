import 'package:flutter/material.dart';

void main() {
  runApp(const SmartKasirApp());
}

class SmartKasirApp extends StatelessWidget {
  const SmartKasirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartKasir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const KasirHomePage(),
    );
  }
}

// Model data sederhana untuk produk
class Product {
  final String name;
  final int price;

  Product({required this.name, required this.price});
}

class KasirHomePage extends StatefulWidget {
  const KasirHomePage({super.key});

  @override
  State<KasirHomePage> createState() => _KasirHomePageState();
}

class _KasirHomePageState extends State<KasirHomePage> {
  // Daftar contoh produk
  final List<Product> products = [
    Product(name: 'Kopi Susu Gula Aren', price: 18000),
    Product(name: 'Roti Bakar Coklat', price: 15000),
    Product(name: 'Es Teh Manis', price: 5000),
    Product(name: 'Nasi Goreng Spesial', price: 25000),
  ];

  // Keranjang belanja (menyimpan produk yang dipilih)
  final List<Product> cart = [];

  // Hitung total harga belanjaan
  int get totalPrice {
    return cart.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartKasir - POS Transaksi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          // Bagian Kiri: Daftar Produk
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          child: ListTile(
                            title: Text(product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                'Rp ${product.price.toString()}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  cart.add(product);
                                });
                              },
                              child: const Text('Tambah'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // Bagian Kanan: Keranjang & Pembayaran
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keranjang Belanja',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: cart.isEmpty
                        ? const Center(
                            child: Text('Keranjang masih kosong',
                                style: TextStyle(color: Colors.grey)),
                          )
                        : ListView.builder(
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final item = cart[index];
                              return ListTile(
                                dense: true,
                                title: Text(item.name),
                                trailing: Text('Rp ${item.price}'),
                              );
                            },
                          ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp $totalPrice',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: cart.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Berhasil!'),
                                  content: Text(
                                      'Transaksi sebesar Rp $totalPrice berhasil diproses.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          cart.clear();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: const Text('Bayar Sekarang'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}