import 'package:flutter/material.dart';
import '../../models/user.dart';

class RiwayatPenarikanPage extends StatefulWidget {
  final User user;

  RiwayatPenarikanPage({required this.user});

  @override
  _RiwayatPenarikanPageState createState() => _RiwayatPenarikanPageState();
}

class _RiwayatPenarikanPageState extends State<RiwayatPenarikanPage> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  // Sample data - replace with actual data from your backend
  List<Map<String, dynamic>> _penarikanData = [
    {
      'id': 'WD001',
      'nasabah': 'Siti Aminah',
      'jumlah': 150000,
      'tanggal': '2024-01-15',
      'status': 'Selesai',
      'metode': 'Transfer Bank',
      'rekening': 'BCA - 1234567890',
      'operator': 'Admin 1',
    },
    {
      'id': 'WD002',
      'nasabah': 'Ahmad Wijaya',
      'jumlah': 250000,
      'tanggal': '2024-01-14',
      'status': 'Pending',
      'metode': 'Cash',
      'rekening': '-',
      'operator': 'Admin 2',
    },
    {
      'id': 'WD003',
      'nasabah': 'Budi Santoso',
      'jumlah': 75000,
      'tanggal': '2024-01-13',
      'status': 'Selesai',
      'metode': 'Transfer Bank',
      'rekening': 'BNI - 0987654321',
      'operator': 'Admin 1',
    },
    {
      'id': 'WD004',
      'nasabah': 'Rina Marlina',
      'jumlah': 100000,
      'tanggal': '2024-01-12',
      'status': 'Ditolak',
      'metode': 'Transfer Bank',
      'rekening': 'Mandiri - 1122334455',
      'operator': 'Admin 2',
    },
    {
      'id': 'WD005',
      'nasabah': 'Joko Susilo',
      'jumlah': 200000,
      'tanggal': '2024-01-11',
      'status': 'Pending',
      'metode': 'Cash',
      'rekening': '-',
      'operator': 'Admin 1',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredData {
    return _penarikanData.where((item) {
      bool matchesFilter =
          _selectedFilter == 'Semua' || item['status'] == _selectedFilter;
      bool matchesSearch = _searchQuery.isEmpty ||
          item['nasabah'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterSection(),
          Expanded(child: _buildPenarikanList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPenarikanDialog(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Penarikan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kelola dan pantau semua transaksi penarikan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nasabah atau ID transaksi...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green[600]!),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          SizedBox(height: 16),
          // Filter chips
          Row(
            children: [
              Text('Filter: ', style: TextStyle(fontWeight: FontWeight.w600)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Pending', 'Selesai', 'Ditolak']
                        .map((filter) => Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter),
                                selected: _selectedFilter == filter,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                selectedColor: Colors.green[100],
                                checkmarkColor: Colors.green[600],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPenarikanList() {
    final filteredData = _filteredData;

    if (filteredData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.money_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Tidak ada data penarikan',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final item = filteredData[index];
        return _buildPenarikanCard(item);
      },
    );
  }

  Widget _buildPenarikanCard(Map<String, dynamic> item) {
    Color statusColor;
    IconData statusIcon;

    switch (item['status']) {
      case 'Selesai':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'Ditolak':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDetailDialog(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['id'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        SizedBox(width: 4),
                        Text(
                          item['status'],
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                item['nasabah'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Rp ${item['jumlah'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    item['tanggal'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.payment, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    item['metode'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Penarikan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID Transaksi', item['id']),
            _buildDetailRow('Nasabah', item['nasabah']),
            _buildDetailRow('Jumlah',
                'Rp ${item['jumlah'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
            _buildDetailRow('Tanggal', item['tanggal']),
            _buildDetailRow('Status', item['status']),
            _buildDetailRow('Metode', item['metode']),
            _buildDetailRow('Rekening', item['rekening']),
            _buildDetailRow('Operator', item['operator']),
          ],
        ),
        actions: [
          if (item['status'] == 'Pending') ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _prosesPernarikan(item['id'], 'Ditolak');
              },
              child: Text('Tolak', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _prosesPernarikan(item['id'], 'Selesai');
              },
              child: Text('Setujui', style: TextStyle(color: Colors.green)),
            ),
          ],
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Text(': ', style: TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _prosesPernarikan(String id, String status) {
    setState(() {
      final index = _penarikanData.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _penarikanData[index]['status'] = status;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Penarikan $id berhasil diproses'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddPenarikanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Penarikan Baru'),
        content:
            Text('Fitur untuk menambah penarikan baru akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
