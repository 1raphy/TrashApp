import 'package:flutter/material.dart';
import '../../models/user.dart';

class KategoriSampahPage extends StatefulWidget {
  final User user;

  KategoriSampahPage({required this.user});

  @override
  _KategoriSampahPageState createState() => _KategoriSampahPageState();
}

class _KategoriSampahPageState extends State<KategoriSampahPage> {
  List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'Plastik Botol',
      'price': 3000,
      'unit': 'kg',
      'description': 'Botol plastik bekas minuman',
      'status': 'Aktif',
      'icon': Icons.local_drink,
      'color': Colors.blue,
    },
    {
      'id': 2,
      'name': 'Kertas',
      'price': 2000,
      'unit': 'kg',
      'description': 'Kertas bekas, koran, majalah',
      'status': 'Aktif',
      'icon': Icons.description,
      'color': Colors.orange,
    },
    {
      'id': 3,
      'name': 'Kaleng',
      'price': 5000,
      'unit': 'kg',
      'description': 'Kaleng bekas minuman dan makanan',
      'status': 'Aktif',
      'icon': Icons.fastfood,
      'color': Colors.grey,
    },
    {
      'id': 4,
      'name': 'Kardus',
      'price': 1500,
      'unit': 'kg',
      'description': 'Kardus bekas kemasan',
      'status': 'Aktif',
      'icon': Icons.inventory_2,
      'color': Colors.brown,
    },
    {
      'id': 5,
      'name': 'Plastik Kresek',
      'price': 2500,
      'unit': 'kg',
      'description': 'Kantong plastik bekas',
      'status': 'Tidak Aktif',
      'icon': Icons.shopping_bag,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(categories[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        backgroundColor: Colors.green[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: Colors.green[600], size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelola Kategori Sampah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${categories.where((c) => c['status'] == 'Aktif').length} kategori aktif',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showFilterDialog,
            icon: Icon(Icons.filter_list, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    bool isActive = category['status'] == 'Aktif';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            category['icon'],
            color: category['color'],
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                category['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category['status'],
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              category['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.monetization_on, size: 16, color: Colors.green[600]),
                SizedBox(width: 4),
                Text(
                  'Rp ${category['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/${category['unit']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    isActive ? Icons.visibility_off : Icons.visibility,
                    color: isActive ? Colors.orange : Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleCategoryAction(value, category),
        ),
      ),
    );
  }

  void _handleCategoryAction(String action, Map<String, dynamic> category) {
    switch (action) {
      case 'edit':
        _showEditCategoryDialog(category);
        break;
      case 'toggle':
        _toggleCategoryStatus(category);
        break;
      case 'delete':
        _showDeleteConfirmDialog(category);
        break;
    }
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedUnit = 'kg';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Kategori Sampah'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga per Unit',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                decoration: InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                items: ['kg', 'gram', 'pcs', 'liter']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (value) => selectedUnit = value!,
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                _addCategory(
                  nameController.text,
                  int.parse(priceController.text),
                  selectedUnit,
                  descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(Map<String, dynamic> category) {
    final nameController = TextEditingController(text: category['name']);
    final priceController =
        TextEditingController(text: category['price'].toString());
    final descriptionController =
        TextEditingController(text: category['description']);
    String selectedUnit = category['unit'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Kategori Sampah'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga per Unit',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                decoration: InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                items: ['kg', 'gram', 'pcs', 'liter']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (value) => selectedUnit = value!,
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                _updateCategory(
                  category['id'],
                  nameController.text,
                  int.parse(priceController.text),
                  selectedUnit,
                  descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Kategori'),
        content: Text(
            'Apakah Anda yakin ingin menghapus kategori "${category['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteCategory(category['id']);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Kategori'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Semua'),
              leading:
                  Radio(value: 'all', groupValue: 'all', onChanged: (value) {}),
            ),
            ListTile(
              title: Text('Aktif'),
              leading: Radio(
                  value: 'active', groupValue: 'all', onChanged: (value) {}),
            ),
            ListTile(
              title: Text('Tidak Aktif'),
              leading: Radio(
                  value: 'inactive', groupValue: 'all', onChanged: (value) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  void _addCategory(String name, int price, String unit, String description) {
    setState(() {
      categories.add({
        'id': categories.length + 1,
        'name': name,
        'price': price,
        'unit': unit,
        'description': description,
        'status': 'Aktif',
        'icon': Icons.recycling,
        'color': Colors.green,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori "$name" berhasil ditambahkan')),
    );
  }

  void _updateCategory(
      int id, String name, int price, String unit, String description) {
    setState(() {
      final index = categories.indexWhere((c) => c['id'] == id);
      if (index != -1) {
        categories[index]['name'] = name;
        categories[index]['price'] = price;
        categories[index]['unit'] = unit;
        categories[index]['description'] = description;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori "$name" berhasil diperbarui')),
    );
  }

  void _toggleCategoryStatus(Map<String, dynamic> category) {
    setState(() {
      final index = categories.indexWhere((c) => c['id'] == category['id']);
      if (index != -1) {
        categories[index]['status'] =
            categories[index]['status'] == 'Aktif' ? 'Tidak Aktif' : 'Aktif';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Status kategori "${category['name']}" berhasil diubah')),
    );
  }

  void _deleteCategory(int id) {
    setState(() {
      categories.removeWhere((c) => c['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori berhasil dihapus')),
    );
  }
}
