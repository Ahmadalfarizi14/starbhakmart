import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({Key? key}) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final List<FoodItem> _items = [
    FoodItem(title: 'Cheese Burger', price: 35000, imagePath: 'assets/chese_burger.jpg', quantity: 1),
    FoodItem(title: 'Teh Botol', price: 8000, imagePath: 'assets/Teh_Botol.jpg', quantity: 2),
    FoodItem(title: 'Ayam Original', price: 45000, imagePath: 'assets/ayam.jpg', quantity: 1),
  ];

  
  void removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.black),
              onPressed: () {
               
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return FoodItemCard(
                      item: _items[index],
                      onQuantityChanged: (newQuantity) {
                        setState(() {
                          _items[index].quantity = newQuantity;
                        });
                      },
                      onRemove: () => removeItem(index), 
                    );
                  },
                ),
              ),
            ),
            CartSummary(items: _items),
          ],
        ),
      ),
    );
  }
}

class FoodItem {
  final String title;
  final int price;
  final String imagePath;
  int quantity;

  FoodItem({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.quantity,
  });
}

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove; 

  const FoodItemCard({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove, 
  }) : super(key: key);

  String formatCurrency(int amount) {
    return 'Rp ' + amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(item.price),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (item.quantity > 1) {
                    onQuantityChanged(item.quantity - 1);
                  }
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('${item.quantity}'),
              IconButton(
                onPressed: () {
                  onQuantityChanged(item.quantity + 1);
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          IconButton(
            onPressed: onRemove, 
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  final List<FoodItem> items;
  static const int fixedTax = 8000;

  const CartSummary({Key? key, required this.items}) : super(key: key);

  String formatCurrency(int amount) {
    return 'Rp ' + amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<int>(0, (sum, item) => sum + (item.price * item.quantity));
    final total = subtotal + fixedTax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(fontSize: 16)),
              Text(formatCurrency(subtotal), style: const TextStyle(fontSize: 16)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pajak', style: TextStyle(fontSize: 16)),
              Text(formatCurrency(fixedTax), style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency(total),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
               
              },
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
