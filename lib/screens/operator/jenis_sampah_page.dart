import 'package:flutter/material.dart';
import 'package:trasav/models/jenis_sampah.dart';
import 'package:trasav/models/user.dart';
import 'package:trasav/services/jenis_sampah_service.dart';

class JenisSampahPage extends StatefulWidget {
  final User user;
  final String token;

  JenisSampahPage({required this.user, required this.token});

  @override
  _JenisSampahPageState createState() => _JenisSampahPageState();
}

class _JenisSampahPageState extends State<JenisSampahPage> {
  late JenisSampahService _service;
  List<JenisSampah> jenisSampahList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = JenisSampahService(token: widget.token);
    _fetchJenisSampah();
  }

  Future<void> _fetchJenisSampah() async {
    setState(() => isLoading = true);
    try {
      jenisSampahList = await _service.getJenisSampah();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Jenis Sampah'),
        backgroundColor: Colors.green[600],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: jenisSampahList.length,
                    itemBuilder: (context, index) {
                      return _buildJenisSampahCard(jenisSampahList[index]);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddJenisSampahDialog,
        backgroundColor: Colors.green[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildJenisSampahCard(JenisSampah jenisSampah) {
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
        title: Text(
          jenisSampah.namaSampah,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.monetization_on, size: 16, color: Colors.green[600]),
            SizedBox(width: 4),
            Text(
              'Rp ${jenisSampah.hargaPerKg.toStringAsFixed(2)}/kg',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green[600],
                fontSize: 14,
              ),
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
          onSelected: (value) => _handleJenisSampahAction(value, jenisSampah),
        ),
      ),
    );
  }

  void _handleJenisSampahAction(String action, JenisSampah jenisSampah) {
    switch (action) {
      case 'edit':
        _showEditJenisSampahDialog(jenisSampah);
        break;
      case 'delete':
        _showDeleteConfirmDialog(jenisSampah);
        break;
    }
  }

  void _showAddJenisSampahDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Jenis Sampah'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Sampah',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga per Kg',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
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
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                try {
                  await _service.createJenisSampah(
                    JenisSampah(
                      id: 0, // ID akan diisi oleh server
                      namaSampah: nameController.text,
                      hargaPerKg: double.parse(priceController.text),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                  await _fetchJenisSampah();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Jenis sampah berhasil ditambahkan'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditJenisSampahDialog(JenisSampah jenisSampah) {
    final nameController = TextEditingController(text: jenisSampah.namaSampah);
    final priceController = TextEditingController(
      text: jenisSampah.hargaPerKg.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Jenis Sampah'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Sampah',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga per Kg',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
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
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                try {
                  await _service.updateJenisSampah(
                    jenisSampah.id,
                    JenisSampah(
                      id: jenisSampah.id,
                      namaSampah: nameController.text,
                      hargaPerKg: double.parse(priceController.text),
                      createdAt: jenisSampah.createdAt,
                      updatedAt: DateTime.now(),
                    ),
                  );
                  await _fetchJenisSampah();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Jenis sampah berhasil diperbarui')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(JenisSampah jenisSampah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Jenis Sampah'),
        content: Text(
          'Apakah Anda yakin ingin menghapus jenis sampah "${jenisSampah.namaSampah}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _service.deleteJenisSampah(jenisSampah.id);
                await _fetchJenisSampah();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Jenis sampah berhasil dihapus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
