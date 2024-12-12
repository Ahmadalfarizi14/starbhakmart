import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMenu extends StatefulWidget {
  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final List<String> _categories = ['Makanan', 'Minuman'];
  String? _selectedCategory;
  String? _selectedImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data.')),
      );
      return;
    }

    // Format harga dengan "Rp" jika belum ada
    String formattedPrice = _priceController.text.startsWith('Rp')
        ? _priceController.text
        : 'Rp ${_priceController.text}';

    // Kirim data kembali ke halaman sebelumnya
    Navigator.pop(context, {
      'imageUrl': _selectedImagePath!,
      'name': _nameController.text,
      'price': formattedPrice,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              labelText: 'Nama Produk',
              hintText: 'Masukan nama produk',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _priceController,
              labelText: 'Harga',
              hintText: 'Masukan harga',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildDropdownButton(),
            const SizedBox(height: 16),
            _buildImagePicker(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kategori produk'),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedCategory,
          hint: const Text('Pilih Kategori'),
          isExpanded: true,
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedImagePath != null
                    ? 'File terpilih: ${_selectedImagePath!.split('/').last}'
                    : 'Pilih gambar',
              ),
            ),
            const Icon(Icons.add_photo_alternate_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
