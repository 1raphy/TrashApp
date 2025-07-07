import 'package:flutter/material.dart';
import '../../models/user.dart';

class RiwayatSetoranPage extends StatefulWidget {
  final User user;

  RiwayatSetoranPage({required this.user});

  @override
  _RiwayatSetoranPageState createState() => _RiwayatSetoranPageState();
}

class _RiwayatSetoranPageState extends State<RiwayatSetoranPage> {
  String selectedFilter = 'Semua';
  List<String> filterOptions = ['Semua', 'Pending', 'Diverifikasi', 'Ditolak'];

  // Data dummy untuk riwayat setoran
  List<Map<String, dynamic>> setoranData = [
    {
      'id': 'ST001',
      'nasabah': 'Budi Santoso',
      'kategori': 'Plastik',
      'berat': 2.5,
      'harga': 7500,
      'tanggal': '2024-01-15',
      'status': 'Diverifikasi',
      'foto': 'https://via.placeholder.com/50',
    },
    {
      'id': 'ST002',
      'nasabah': 'Siti Aminah',
      'kategori': 'Kardus',
      'berat': 5.0,
      'harga': 15000,
      'tanggal': '2024-01-15',
      'status': 'Pending',
      'foto': 'https://via.placeholder.com/50',
    },
    {
      'id': 'ST003',
      'nasabah': 'Ahmad Wijaya',
      'kategori': 'Botol Kaca',
      'berat': 3.2,
      'harga': 9600,
      'tanggal': '2024-01-14',
      'status': 'Diverifikasi',
      'foto': 'https://via.placeholder.com/50',
    },
    {
      'id': 'ST004',
      'nasabah': 'Rina Susanti',
      'kategori': 'Kertas',
      'berat': 1.8,
      'harga': 3600,
      'tanggal': '2024-01-14',
      'status': 'Ditolak',
      'foto': 'https://via.placeholder.com/50',
    },
    {
      'id': 'ST005',
      'nasabah': 'Joko Priyono',
      'kategori': 'Aluminium',
      'berat': 0.8,
      'harga': 4000,
      'tanggal': '2024-01-13',
      'status': 'Pending',
      'foto': 'https://via.placeholder.com/50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterSection(),
          Expanded(child: _buildSetoranList()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
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
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.history, color: Colors.green[600], size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Setoran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Kelola dan verifikasi setoran sampah',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.green[600]),
            onPressed: () {
              setState(() {
                // Refresh data
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterOptions.map((filter) {
                bool isSelected = selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[600] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected ? Colors.green[600]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetoranList() {
    List<Map<String, dynamic>> filteredData = setoranData.where((setoran) {
      if (selectedFilter == 'Semua') return true;
      return setoran['status'] == selectedFilter;
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final setoran = filteredData[index];
        return _buildSetoranCard(setoran);
      },
    );
  }

  Widget _buildSetoranCard(Map<String, dynamic> setoran) {
    Color statusColor = _getStatusColor(setoran['status']);
    IconData statusIcon = _getStatusIcon(setoran['status']);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showSetoranDetail(setoran),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.recycling, color: Colors.green[600]),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              setoran['id'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(statusIcon,
                                      size: 12, color: statusColor),
                                  SizedBox(width: 4),
                                  Text(
                                    setoran['status'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          setoran['nasabah'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          setoran['kategori'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${setoran['berat']} kg',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.monetization_on,
                      size: 16, color: Colors.green[600]),
                  SizedBox(width: 4),
                  Text(
                    'Rp ${setoran['harga'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text(
                    setoran['tanggal'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              if (setoran['status'] == 'Pending') ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _verifySetoran(setoran['id'], true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Verifikasi'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _verifySetoran(setoran['id'], false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Tolak'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange[600]!;
      case 'Diverifikasi':
        return Colors.green[600]!;
      case 'Ditolak':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.hourglass_empty;
      case 'Diverifikasi':
        return Icons.check_circle;
      case 'Ditolak':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  void _showSetoranDetail(Map<String, dynamic> setoran) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Detail Setoran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildDetailRow('ID Setoran', setoran['id']),
              _buildDetailRow('Nasabah', setoran['nasabah']),
              _buildDetailRow('Kategori', setoran['kategori']),
              _buildDetailRow('Berat', '${setoran['berat']} kg'),
              _buildDetailRow('Harga',
                  'Rp ${setoran['harga'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'),
              _buildDetailRow('Tanggal', setoran['tanggal']),
              _buildDetailRow('Status', setoran['status']),
              SizedBox(height: 16),
              if (setoran['status'] == 'Pending')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _verifySetoran(setoran['id'], true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Verifikasi'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _verifySetoran(setoran['id'], false);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                        ),
                        child: Text('Tolak'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifySetoran(String id, bool approve) {
    setState(() {
      int index = setoranData.indexWhere((setoran) => setoran['id'] == id);
      if (index != -1) {
        setoranData[index]['status'] = approve ? 'Diverifikasi' : 'Ditolak';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(approve ? 'Setoran berhasil diverifikasi' : 'Setoran ditolak'),
        backgroundColor: approve ? Colors.green[600] : Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Implementasi untuk menambah setoran manual
        _showAddSetoranDialog();
      },
      backgroundColor: Colors.green[600],
      label: Text('Tambah Setoran', style: TextStyle(color: Colors.white)),
      icon: Icon(Icons.add, color: Colors.white),
    );
  }

  void _showAddSetoranDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Setoran Manual'),
        content: Text(
            'Fitur untuk menambah setoran manual akan diimplementasikan di sini.'),
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
