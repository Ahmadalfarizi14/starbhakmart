import 'package:flutter/material.dart';
import 'addmenu.dart';

class Datamenu extends StatefulWidget {
  const Datamenu({Key? key}) : super(key: key);

  @override
  _DatamenuState createState() => _DatamenuState();
}

class _DatamenuState extends State<Datamenu> {
  
  final List<Map<String, String>> _menuData = [
    {'imageUrl': 'assets/chese_burger.jpg', 'name': 'Cheese Burger', 'price': 'Rp 35,000'},
    {'imageUrl': 'assets/Teh_Botol.jpg', 'name': 'Teh Botol', 'price': 'Rp 8,000'},
    {'imageUrl': 'assets/ayam.jpg', 'name': 'Ayam Original', 'price': 'Rp 45,000'},
  ];

  void _addNewMenu(Map<String, String> newMenu) {
    setState(() {
      
      if (newMenu['imageUrl'] == null || newMenu['imageUrl']!.isEmpty) {
        newMenu['imageUrl'] = 'assets/default_food.jpg';
      }
      _menuData.add(newMenu);
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                setState(() {
                  _menuData.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Menu', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () async {
                  
                  final newMenu = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(builder: (context) => AddMenu()),
                  );
                  if (newMenu != null) {
                    _addNewMenu(newMenu);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _menuData.length,
                itemBuilder: (context, index) {
                  final menu = _menuData[index];
                  return _buildListItem(
                    imageUrl: menu['imageUrl']!,
                    name: menu['name']!,
                    price: menu['price']!,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildListItem({
      required String imageUrl,
      required String name,
      required String price,
      required int index,
    }) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 255, 255, 255), 
            ),
            child: Center(
              child: Icon(
                Icons.fastfood, 
                color: const Color.fromARGB(255, 0, 0, 0),
                size: 30,
              ),
            ),
          ),
          title: Text(name),
          subtitle: Text(price),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _confirmDelete(index);
            },
          ),
        ),
      );
    }
}
