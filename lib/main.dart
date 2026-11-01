import 'package:flutter/material.dart';
import 'splash_screen.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class Product {
  final String name;
  final int price;
  final String? badge; // <-- Tambahkan baris ini

  Product({required this.name, required this.price, this.badge});
}

class KasirHomePage extends StatefulWidget {
  const KasirHomePage({super.key});

  @override
  State<KasirHomePage> createState() => _KasirHomePageState();
}

class _KasirHomePageState extends State<KasirHomePage> {
  // 1. Daftar Produk (Bisa ditambah dinamis)
  final List<Product> products = [
  Product(
    name: 'Kopi Susu Gula Aren', 
    price: 18000, 
    badge: 'PROMO 20%' // <-- Tambahkan badge di sini
  ),
  Product(name: 'Roti Bakar Coklat', price: 15000),
  Product(name: 'Es Teh Manis', price: 5000),
  Product(name: 'Nasi Goreng Spesial', price: 25000),
];

  // 2. Keranjang Belanja
  final List<Product> cart = [];

  // Hitung total harga belanjaan
  int get totalPrice {
    return cart.fold(0, (sum, item) => sum + item.price);
  }

  // Controller untuk Form Tambah Produk
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Dialog Tambah Produk Baru
  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _priceController.clear();
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = _nameController.text;
                final int? price = int.tryParse(_priceController.text);

                if (name.isNotEmpty && price != null && price > 0) {
                  setState(() {
                    products.add(Product(name: name, price: price));
                  });
                  _nameController.clear();
                  _priceController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Dialog Pembayaran & Hitung Kembalian
  void _showCheckoutDialog() {
    final TextEditingController cashController = TextEditingController();
    int change = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pembayaran POS'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Tagihan: Rp $totalPrice',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: cashController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Uang Tunai (Rp)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final int cash = int.tryParse(value) ?? 0;
                      setDialogState(() {
                        change = cash - totalPrice;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    change >= 0
                        ? 'Kembalian: Rp $change'
                        : 'Uang Kurang: Rp ${change.abs()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: change >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: change < 0 || cashController.text.isEmpty
                      ? null
                      : () {
                          setState(() {
                            cart.clear();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaksi Berhasil Ditutupi!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                  child: const Text('Selesaikan Transaksi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartKasir - POS Transaksi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            tooltip: 'Tambah Produk',
            onPressed: _showAddProductDialog,
          ),
        ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Produk',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddProductDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Produk Baru'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
  final product = products[index];
  return Card(
    child: ListTile(
      title: Row(
        children: [
          Text(product.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          if (product.badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.badge!,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text('Rp ${product.price}'),
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
          // Bagian Kanan: Keranjang Belanja
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
                                subtitle: Text('Rp ${item.price}'),
                                // Fitur Hapus Item
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      cart.removeAt(index);
                                    });
                                  },
                                ),
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
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: cart.isEmpty ? null : _showCheckoutDialog,
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